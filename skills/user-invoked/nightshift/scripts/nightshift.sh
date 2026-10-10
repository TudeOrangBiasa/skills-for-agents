#!/usr/bin/env bash
# nightshift: pick ready issues, hand each to /whips triage intake, keep only draft PRs.
# Runner agnostic: Orca, systemd, cron, or a human call this the same way.
# Contract: see ../CONTRACT.md. No agent, model, or provider is assumed here.
set -euo pipefail

VERSION=1

die() { printf 'nightshift: %s\n' "$*" >&2; exit 2; }
log() { printf '%s nightshift: %s\n' "$(date -Is)" "$*" >&2; }

load_config() {
  local cfg="${NIGHTSHIFT_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/nightshift/config.sh}"
  # Env set by the caller wins over the file: remember it, source the file, re-apply.
  local -A caller=()
  local v
  for v in ${!NIGHTSHIFT_@}; do caller[$v]="${!v}"; done
  if [[ -f "$cfg" ]]; then
    # shellcheck disable=SC1090
    source "$cfg"
  fi
  for v in "${!caller[@]}"; do printf -v "$v" '%s' "${caller[$v]}"; export "${v?}"; done

  : "${NIGHTSHIFT_READY_LABEL:=ready-for-agent}"
  : "${NIGHTSHIFT_CLAIM_LABEL:=nightshift-claimed}"
  : "${NIGHTSHIFT_NEEDS_INFO_LABEL:=needs-info}"
  : "${NIGHTSHIFT_MAX_ISSUES:=1}"
  : "${NIGHTSHIFT_MAX_ATTEMPTS:=2}"
  : "${NIGHTSHIFT_TIMEOUT_MIN:=120}"
  : "${NIGHTSHIFT_WINDOW:=}"
  : "${NIGHTSHIFT_MODEL_ALLOWLIST:=}"
  : "${NIGHTSHIFT_ENFORCE_DRAFT:=1}"
  : "${NIGHTSHIFT_NOTIFY_CMD:=}"
  : "${NIGHTSHIFT_STATE_DIR:=${XDG_STATE_HOME:-$HOME/.local/state}/nightshift}"
  : "${NIGHTSHIFT_WORK_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/nightshift}"
  NIGHTSHIFT_CONFIG_PATH="$cfg"
}

require_config() {
  local missing=()
  [[ -n "${NIGHTSHIFT_REPOS:-}" ]] || missing+=(NIGHTSHIFT_REPOS)
  [[ -n "${NIGHTSHIFT_AGENT_CMD:-}" ]] || missing+=(NIGHTSHIFT_AGENT_CMD)
  [[ -n "${NIGHTSHIFT_MODEL:-}" ]] || missing+=(NIGHTSHIFT_MODEL)
  if ((${#missing[@]})); then
    if [[ ! -f "$NIGHTSHIFT_CONFIG_PATH" ]]; then
      die "no config at $NIGHTSHIFT_CONFIG_PATH. Run 'nightshift.sh setup' in a terminal first (it detects your agents and models and asks which to use). There is no default agent or model."
    fi
    die "unset: ${missing[*]}. Re-run 'nightshift.sh setup' or set them in $NIGHTSHIFT_CONFIG_PATH. There is no default agent or model."
  fi
  if [[ -n "$NIGHTSHIFT_MODEL_ALLOWLIST" ]]; then
    local ok=0 m
    for m in $NIGHTSHIFT_MODEL_ALLOWLIST; do [[ "$m" == "$NIGHTSHIFT_MODEL" ]] && ok=1; done
    ((ok)) || die "model '$NIGHTSHIFT_MODEL' is not in NIGHTSHIFT_MODEL_ALLOWLIST ($NIGHTSHIFT_MODEL_ALLOWLIST). Refusing to run."
  fi
  local bin
  for bin in gh git jq flock timeout; do
    command -v "$bin" >/dev/null || die "missing dependency: $bin"
  done
  mkdir -p "$NIGHTSHIFT_STATE_DIR/logs" "$NIGHTSHIFT_WORK_DIR"
  [[ -f "$NIGHTSHIFT_STATE_DIR/attempts.json" ]] || echo '{}' >"$NIGHTSHIFT_STATE_DIR/attempts.json"
}

state() { printf '%s/%s' "$NIGHTSHIFT_STATE_DIR" "$1"; }

attempts_of() { jq -r --arg k "$1" '.[$k] // 0' "$(state attempts.json)"; }
bump_attempts() {
  local f; f="$(state attempts.json)"
  jq --arg k "$1" '.[$k] = ((.[$k] // 0) + 1)' "$f" >"$f.tmp" && mv "$f.tmp" "$f"
}
clear_attempts() {
  local f; f="$(state attempts.json)"
  jq --arg k "$1" 'del(.[$k])' "$f" >"$f.tmp" && mv "$f.tmp" "$f"
}

# Open PR whose body links the issue with a closing keyword. Prints "number url isDraft" or nothing.
linked_pr() {
  local repo="$1" n="$2"
  gh pr list -R "$repo" --state open --limit 100 --json number,url,isDraft,body |
    jq -r --arg n "$n" '
      map(select(.body // "" | test("(?i)\\b(close[sd]?|fix(e[sd])?|resolve[sd]?) #" + $n + "\\b")))
      | first // empty | "\(.number) \(.url) \(.isDraft)"'
}

ensure_claim_label() {
  gh label create "$NIGHTSHIFT_CLAIM_LABEL" -R "$1" --color BFD4F2 \
    --description "Claimed by a nightshift run; removed when the run ends" >/dev/null 2>&1 || true
}

# Candidates across repos, oldest first: "createdAt repo number".
candidates() {
  local repo
  for repo in $NIGHTSHIFT_REPOS; do
    gh issue list -R "$repo" --state open --label "$NIGHTSHIFT_READY_LABEL" --limit 100 \
      --json number,createdAt,assignees,labels |
      jq -r --arg repo "$repo" --arg claim "$NIGHTSHIFT_CLAIM_LABEL" '
        .[] | select((.assignees | length) == 0)
            | select([.labels[].name] | index($claim) | not)
            | "\(.createdAt) \($repo) \(.number)"' || log "could not list issues in $repo"
  done | sort
}

eligible() {
  local repo="$1" n="$2" key="$1#$2"
  (( $(attempts_of "$key") < NIGHTSHIFT_MAX_ATTEMPTS )) || return 1
  [[ -z "$(linked_pr "$repo" "$n")" ]]
}

# NIGHTSHIFT_WINDOW="22:00-07:00": start new issues only inside it (wraps midnight). Empty means always.
outside_window() {
  [[ -n "$NIGHTSHIFT_WINDOW" ]] || return 1
  local start="${NIGHTSHIFT_WINDOW%-*}" end="${NIGHTSHIFT_WINDOW#*-}" now; now="$(date +%H:%M)"
  if [[ "$start" < "$end" ]]; then
    [[ "$now" < "$start" || ! "$now" < "$end" ]]
  else
    [[ "$now" < "$start" && ! "$now" < "$end" ]]
  fi
}

record() { # repo n outcome pr_url log detail
  jq -cn --arg ts "$(date -Is)" --arg repo "$1" --argjson n "$2" --arg outcome "$3" \
    --arg pr "$4" --arg log "$5" --arg detail "$6" --arg model "$NIGHTSHIFT_MODEL" \
    '{ts:$ts, repo:$repo, issue:$n, outcome:$outcome, pr:$pr, model:$model, log:$log, detail:$detail}' \
    >>"$(state runs.jsonl)"
}

# Release claims a previous run left behind (crash, laptop off, killed). Safe: we hold the lock.
recover_stale() {
  local f; f="$(state active)"
  [[ -s "$f" ]] || return 0
  local repo n
  while read -r repo n; do
    [[ -n "$repo" ]] || continue
    log "releasing stale claim $repo#$n"
    gh issue edit "$n" -R "$repo" --remove-label "$NIGHTSHIFT_CLAIM_LABEL" >/dev/null 2>&1 || true
    if [[ -n "$(linked_pr "$repo" "$n")" ]]; then
      record "$repo" "$n" recovered_pr "" "" "previous run ended without reporting, PR exists"
    else
      bump_attempts "$repo#$n"
      record "$repo" "$n" interrupted "" "" "previous run ended without reporting"
    fi
  done <"$f"
  : >"$f"
}

prepare_worktree() { # repo n -> prints path
  local repo="$1" n="$2" base="$NIGHTSHIFT_WORK_DIR/repos/${1//\//__}"
  if [[ ! -d "$base/.git" ]]; then
    gh repo clone "$repo" "$base" -- --quiet >&2 || return 1
  fi
  git -C "$base" fetch --quiet --prune origin >&2 || return 1
  git -C "$base" worktree prune
  local head; head="$(git -C "$base" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)"
  local wt stamp; stamp="$(date +%Y%m%d%H%M%S)"
  wt="$NIGHTSHIFT_WORK_DIR/worktrees/${1//\//__}-$n-$stamp-$$"
  mkdir -p "$(dirname "$wt")"
  git -C "$base" worktree add --quiet --detach "$wt" "$head" >&2 || return 1
  printf '%s' "$wt"
}

drop_worktree() {
  local wt="$1" base="$NIGHTSHIFT_WORK_DIR/repos/${2//\//__}"
  git -C "$base" worktree remove --force "$wt" >/dev/null 2>&1 || true
}

write_prompt() { # repo n file
  cat >"$3" <<PROMPT
/whips Pick up issue $1#$2 with playbooks/triage.md intake. This is an unattended nightshift run.

Rules for this run:
- Work only on $1#$2, inside the current directory (a fresh worktree of $1, detached at the default branch). Create your own branch per playbooks/opening-a-pr.md.
- If the brief is insufficient, follow intake step 4 (triage notes, label to $NIGHTSHIFT_NEEDS_INFO_LABEL) and stop.
- Otherwise finish with playbooks/opening-a-pr.md: gh pr create --draft, body contains "Closes #$2".
- Never run gh pr ready, never merge, never enable auto-merge.
- No human is watching. Do not wait for answers; anything that needs a decision goes into the PR body or an issue comment.
- Last line of your reply: NIGHTSHIFT_RESULT: pr=<url or none> status=<pr_opened|needs_info|blocked>
PROMPT
}

run_one() { # repo n
  local repo="$1" n="$2" key="$1#$2" ts; ts="$(date +%Y%m%d-%H%M%S)-$$"
  local logf; logf="$(state logs)/${repo//\//__}-$n-$ts.log"

  ensure_claim_label "$repo"
  gh issue edit "$n" -R "$repo" --add-label "$NIGHTSHIFT_CLAIM_LABEL" >/dev/null
  printf '%s %s\n' "$repo" "$n" >>"$(state active)"
  log "claimed $key"

  local wt prompt_file rc=0
  if ! wt="$(prepare_worktree "$repo" "$n")"; then
    gh issue edit "$n" -R "$repo" --remove-label "$NIGHTSHIFT_CLAIM_LABEL" >/dev/null 2>&1 || true
    sed -i "\|^$repo $n\$|d" "$(state active)"
    bump_attempts "$key"; record "$repo" "$n" setup_failed "" "" "worktree setup failed"
    return
  fi
  prompt_file="$(state logs)/${repo//\//__}-$n-$ts.prompt.md"
  write_prompt "$repo" "$n" "$prompt_file"

  log "running agent for $key in $wt (log: $logf)"
  (
    cd "$wt"
    export NIGHTSHIFT_REPO="$repo" NIGHTSHIFT_ISSUE="$n" NIGHTSHIFT_WORKTREE="$wt"
    export NIGHTSHIFT_PROMPT_FILE="$prompt_file" NIGHTSHIFT_MODEL
    NIGHTSHIFT_PROMPT="$(cat "$prompt_file")"; export NIGHTSHIFT_PROMPT
    timeout --kill-after=60 "$((NIGHTSHIFT_TIMEOUT_MIN * 60))" bash -c "$NIGHTSHIFT_AGENT_CMD"
  ) >"$logf" 2>&1 </dev/null || rc=$?

  local pr outcome detail="agent exit $rc" pr_url=""
  pr="$(linked_pr "$repo" "$n" || true)"
  if [[ -n "$pr" ]]; then
    local num url draft; read -r num url draft <<<"$pr"; pr_url="$url"
    outcome=pr_opened
    if [[ "$draft" != "true" ]]; then
      detail="$detail; PR was not a draft"
      if [[ "$NIGHTSHIFT_ENFORCE_DRAFT" == 1 ]]; then
        gh pr ready "$num" -R "$repo" --undo >/dev/null 2>&1 && detail="$detail, converted back to draft"
      fi
    fi
    clear_attempts "$key"
  elif gh issue view "$n" -R "$repo" --json labels -q '.labels[].name' | grep -qx "$NIGHTSHIFT_NEEDS_INFO_LABEL"; then
    outcome=needs_info; clear_attempts "$key"
  elif ((rc == 124 || rc == 137)); then
    outcome=timeout; bump_attempts "$key"
  else
    outcome=no_pr; bump_attempts "$key"
  fi

  gh issue edit "$n" -R "$repo" --remove-label "$NIGHTSHIFT_CLAIM_LABEL" >/dev/null 2>&1 || true
  sed -i "\|^$repo $n\$|d" "$(state active)"
  case "$outcome" in
    pr_opened|needs_info) drop_worktree "$wt" "$repo" ;;
    *) detail="$detail; worktree kept at $wt" ;;
  esac
  record "$repo" "$n" "$outcome" "$pr_url" "$logf" "$detail"
  log "$key -> $outcome ${pr_url:-}"
  SUMMARY+=("$key $outcome ${pr_url:-}")
}

cmd_run() {
  load_config; require_config
  exec 9>"$(state lock)"
  if ! flock -n 9; then
    log "another nightshift run holds the lock; exiting"
    exit 0
  fi
  date -Is >"$(state last-start)"
  recover_stale

  SUMMARY=()
  local done_count=0 repo n
  while read -r _ repo n; do
    [[ -n "${n:-}" ]] || continue
    ((done_count < NIGHTSHIFT_MAX_ISSUES)) || break
    if outside_window; then log "outside NIGHTSHIFT_WINDOW $NIGHTSHIFT_WINDOW; not starting new issues"; break; fi
    eligible "$repo" "$n" || continue
    run_one "$repo" "$n"
    done_count=$((done_count + 1))
  done < <(candidates)

  date -Is >"$(state last-finish)"
  local msg
  if ((${#SUMMARY[@]})); then
    msg="nightshift: ${#SUMMARY[@]} issue(s): $(printf '%s; ' "${SUMMARY[@]}")"
  else
    msg="nightshift: nothing eligible with label $NIGHTSHIFT_READY_LABEL"
  fi
  printf '%s\n' "$msg"
  if [[ -n "$NIGHTSHIFT_NOTIFY_CMD" ]]; then
    NIGHTSHIFT_SUMMARY="$msg" bash -c "$NIGHTSHIFT_NOTIFY_CMD" || log "notify command failed"
  fi
}

# Exit 0 when at least one issue is eligible, 1 when none. Cheap gate for schedulers.
cmd_check() {
  load_config; require_config
  local repo n
  while read -r _ repo n; do
    [[ -n "${n:-}" ]] || continue
    if eligible "$repo" "$n"; then printf 'eligible: %s#%s\n' "$repo" "$n"; exit 0; fi
  done < <(candidates)
  printf 'nothing eligible\n'; exit 1
}

cmd_status() {
  load_config
  local f; f="$(state runs.jsonl)"
  printf 'last start:  %s\n' "$(cat "$(state last-start)" 2>/dev/null || echo never)"
  printf 'last finish: %s\n' "$(cat "$(state last-finish)" 2>/dev/null || echo never)"
  printf 'config:      %s\n' "$NIGHTSHIFT_CONFIG_PATH"
  printf 'agent/model: %s / %s\n' "${NIGHTSHIFT_AGENT_CMD:-unset}" "${NIGHTSHIFT_MODEL:-unset}"
  printf 'active:      %s\n' "$( { tr '\n' ' ' <"$(state active)"; } 2>/dev/null || true)"
  [[ -f "$f" ]] && tail -n "${1:-10}" "$f" | jq -r '"\(.ts)  \(.repo)#\(.issue)  \(.outcome)  \(.pr)  \(.detail)"'
  return 0
}

cmd_reset() { # repo#n: forget attempts so the issue is eligible again
  load_config; require_config
  [[ "${1:-}" == *#* ]] || die "usage: nightshift.sh reset owner/repo#N"
  clear_attempts "$1"; log "attempts cleared for $1"
}

# ---------- setup: detect harnesses, ask, persist. Never runs unattended. ----------

KNOWN_AGENTS="opencode pi omp codex claude grok gemini cursor-agent aider goose amp droid kimi qwen crush"

# Preset command templates are offered only for CLIs whose non-interactive flags are documented
# upstream; verify with '<agent> --help'. Anything else is entered by hand.
preset_cmd() {
  case "$1" in
    opencode) printf '%s' 'opencode run --auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    codex) printf '%s' 'codex exec --full-auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    claude) printf '%s' 'claude -p --model "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    *) return 1 ;;
  esac
}

detect_agents() {
  local a
  for a in $KNOWN_AGENTS; do command -v "$a" >/dev/null 2>&1 && printf '%s\n' "$a"; done
  return 0
}

# Prints candidate model ids, one per line, from the CLIs and config files that are present.
detect_models() {
  local c="${XDG_CONFIG_HOME:-$HOME/.config}" f
  if command -v opencode >/dev/null 2>&1; then
    timeout 30 opencode models 2>/dev/null | grep -E '^[^[:space:]]+/[^[:space:]]+$' || true
  fi
  for f in "$c/opencode/opencode.json" "$c/opencode/opencode.jsonc" "./opencode.json"; do
    [[ -f "$f" ]] && sed -nE 's/.*"(model|small_model)"[[:space:]]*:[[:space:]]*"([^"]+)".*/\2/p' "$f"
  done
  for f in "$HOME/.pi/agent/settings.json" "$HOME/.omp/agent/settings.json" "$c/pi/settings.json"; do
    [[ -f "$f" ]] && jq -r '[.defaultProvider, .defaultModel] | select(.[1] != null) | if .[0] then "\(.[0])/\(.[1])" else .[1] end' "$f" 2>/dev/null
  done
  f="$HOME/.codex/config.toml"
  [[ -f "$f" ]] && sed -nE 's/^[[:space:]]*model[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' "$f"
  f="$HOME/.claude/settings.json"
  [[ -f "$f" ]] && jq -r '.model // empty' "$f" 2>/dev/null
  return 0
}

# Names only, never values.
detect_env_keys() {
  compgen -e | grep -E '(_API_KEY|_TOKEN)$' | grep -vE '^(GH_TOKEN|GITHUB_TOKEN)$' | sort || true
}

cmd_detect() {
  load_config
  printf 'config file: %s (%s)\n' "$NIGHTSHIFT_CONFIG_PATH" "$([[ -f "$NIGHTSHIFT_CONFIG_PATH" ]] && echo exists || echo missing)"
  printf '\nagents on PATH:\n'; detect_agents | sed 's/^/  /'
  printf '\nmodels found in harness configs:\n'; detect_models | sort -u | sed 's/^/  /'
  printf '\nprovider env vars set (names only):\n'; detect_env_keys | sed 's/^/  /'
  if command -v orca >/dev/null 2>&1 || command -v orca-ide >/dev/null 2>&1; then
    printf '\norca CLI found: see ADAPTERS.md for the Orca automation adapter\n'
  fi
}

choose() { # prompt, options... -> prints chosen value; last choice is free text
  local prompt="$1"; shift
  local opts=("$@") i reply
  {
    printf '\n%s\n' "$prompt"
    for i in "${!opts[@]}"; do printf '  %d) %s\n' "$((i + 1))" "${opts[$i]}"; done
    printf '  %d) enter manually\n' "$(( ${#opts[@]} + 1 ))"
  } >&2
  while :; do
    read -r -p '> ' reply </dev/tty
    if [[ "$reply" =~ ^[0-9]+$ ]] && ((reply >= 1 && reply <= ${#opts[@]})); then
      printf '%s' "${opts[$((reply - 1))]}"; return
    elif [[ "$reply" =~ ^[0-9]+$ ]] && ((reply == ${#opts[@]} + 1)); then
      read -r -p 'value> ' reply </dev/tty; [[ -n "$reply" ]] && { printf '%s' "$reply"; return; }
    fi
    printf 'pick a number from the list\n' >&2
  done
}

ask() { # prompt, current -> value (empty allowed when current empty)
  local reply; read -r -p "$1${2:+ [$2]}: " reply </dev/tty; printf '%s' "${reply:-$2}"
}

cmd_setup() {
  load_config
  local agent_cmd="" model="" repos="" allow="" label="" window="" maxi=""
  while (($#)); do
    case "$1" in
      --agent-cmd) agent_cmd="$2"; shift 2 ;;
      --model) model="$2"; shift 2 ;;
      --repos) repos="$2"; shift 2 ;;
      --allowlist) allow="$2"; shift 2 ;;
      --label) label="$2"; shift 2 ;;
      --window) window="$2"; shift 2 ;;
      --max-issues) maxi="$2"; shift 2 ;;
      *) die "unknown setup flag: $1" ;;
    esac
  done
  local tty=0; [[ -r /dev/tty ]] && { : </dev/tty; } 2>/dev/null && tty=1

  if [[ -z "$agent_cmd" ]]; then
    ((tty)) || die "setup needs a terminal to ask, or pass --agent-cmd and --model"
    mapfile -t agents < <(detect_agents)
    local a choice opts=()
    for a in "${agents[@]}"; do
      if preset_cmd "$a" >/dev/null; then opts+=("$(preset_cmd "$a")"); else opts+=("$a ... (type the full non-interactive command)"); fi
    done
    choice="$(choose 'Which agent command should nightshift run? It sees $NIGHTSHIFT_MODEL, $NIGHTSHIFT_PROMPT, $NIGHTSHIFT_PROMPT_FILE.' "${opts[@]}")"
    if [[ "$choice" == *"(type the full non-interactive command)" ]]; then
      choice="$(ask 'full command (check the agent --help for its non-interactive mode)' "")"
    fi
    agent_cmd="$choice"
  fi
  [[ -n "$agent_cmd" ]] || die "no agent command chosen"

  if [[ -z "$model" ]]; then
    ((tty)) || die "setup needs a terminal to ask, or pass --model"
    mapfile -t models < <(detect_models | sort -u)
    ((${#models[@]})) || printf '\nNo models detected from harness configs; enter one manually.\n' >&2
    printf '\nProvider env vars set: %s\n' "$(detect_env_keys | tr '\n' ' ')" >&2
    model="$(choose 'Which model should every nightshift run use?' "${models[@]}")"
  fi
  [[ -n "$model" ]] || die "no model chosen"

  if ((tty)); then
    [[ -n "$repos" ]] || repos="$(ask 'repos (space separated owner/repo)' "${NIGHTSHIFT_REPOS:-}")"
    [[ -n "$allow" ]] || allow="$(ask 'model allowlist (space separated, empty for none)' "${NIGHTSHIFT_MODEL_ALLOWLIST:-$model}")"
    [[ -n "$label" ]] || label="$(ask 'ready label' "$NIGHTSHIFT_READY_LABEL")"
    [[ -n "$window" ]] || window="$(ask 'start window HH:MM-HH:MM (empty for any time)' "$NIGHTSHIFT_WINDOW")"
    [[ -n "$maxi" ]] || maxi="$(ask 'max issues per run' "$NIGHTSHIFT_MAX_ISSUES")"
  fi
  [[ -n "$repos" ]] || repos="${NIGHTSHIFT_REPOS:-}"
  [[ -n "$repos" ]] || die "no repos given (--repos 'owner/a owner/b')"

  mkdir -p "$(dirname "$NIGHTSHIFT_CONFIG_PATH")"
  {
    printf '# nightshift config, written by "nightshift.sh setup" on %s. Re-run setup to change.\n' "$(date -Is)"
    printf 'NIGHTSHIFT_AGENT_CMD=%q\n' "$agent_cmd"
    printf 'NIGHTSHIFT_MODEL=%q\n' "$model"
    printf 'NIGHTSHIFT_MODEL_ALLOWLIST=%q\n' "$allow"
    printf 'NIGHTSHIFT_REPOS=%q\n' "$repos"
    printf 'NIGHTSHIFT_READY_LABEL=%q\n' "${label:-$NIGHTSHIFT_READY_LABEL}"
    printf 'NIGHTSHIFT_WINDOW=%q\n' "${window:-}"
    printf 'NIGHTSHIFT_MAX_ISSUES=%q\n' "${maxi:-$NIGHTSHIFT_MAX_ISSUES}"
  } >"$NIGHTSHIFT_CONFIG_PATH.tmp"
  mv "$NIGHTSHIFT_CONFIG_PATH.tmp" "$NIGHTSHIFT_CONFIG_PATH"
  printf 'saved %s\n' "$NIGHTSHIFT_CONFIG_PATH"
  # Validate what was written, including the allowlist.
  unset NIGHTSHIFT_AGENT_CMD NIGHTSHIFT_MODEL NIGHTSHIFT_MODEL_ALLOWLIST NIGHTSHIFT_REPOS
  load_config; require_config
  printf 'ok: agent "%s", model "%s"\n' "$NIGHTSHIFT_AGENT_CMD" "$NIGHTSHIFT_MODEL"
}

case "${1:-}" in
  run) cmd_run ;;
  check) cmd_check ;;
  status) shift; cmd_status "${1:-10}" ;;
  reset) shift; cmd_reset "${1:-}" ;;
  setup) shift; cmd_setup "$@" ;;
  detect) cmd_detect ;;
  version) echo "nightshift $VERSION" ;;
  *) printf 'usage: nightshift.sh setup [flags]|detect|run|check|status [N]|reset owner/repo#N|version\n' >&2; exit 2 ;;
esac
