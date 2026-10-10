#!/usr/bin/env bash
# Pick ready-for-agent issues, hand each to /whips triage intake, keep only draft PRs.
# Tracker and label strings come from each repo's docs/agents/*.md (written by /setup-meta).
# The agent command and model come only from the config written by `setup`.
set -euo pipefail

die() { printf 'nightshift: %s\n' "$*" >&2; exit 2; }
log() { printf '%s nightshift: %s\n' "$(date -Is)" "$*" >&2; }

# ---------- config ----------

load_config() {
  NIGHTSHIFT_CONFIG_PATH="${NIGHTSHIFT_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/nightshift/config.sh}"
  # Caller env wins over the file for one call.
  local -A caller=()
  local v
  for v in ${!NIGHTSHIFT_@}; do caller[$v]="${!v}"; done
  # shellcheck disable=SC1090
  [[ -f "$NIGHTSHIFT_CONFIG_PATH" ]] && source "$NIGHTSHIFT_CONFIG_PATH"
  for v in "${!caller[@]}"; do printf -v "$v" '%s' "${caller[$v]}"; done
  : "${NIGHTSHIFT_MODEL_ALLOWLIST:=}"
  : "${NIGHTSHIFT_MAX_ISSUES:=1}"
  : "${NIGHTSHIFT_MAX_ATTEMPTS:=2}"
  : "${NIGHTSHIFT_TIMEOUT_MIN:=120}"
  : "${NIGHTSHIFT_STATE_DIR:=${XDG_STATE_HOME:-$HOME/.local/state}/nightshift}"
  : "${NIGHTSHIFT_WORK_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/nightshift}"
}

require_config() {
  local missing=() k
  for k in NIGHTSHIFT_AGENT_CMD NIGHTSHIFT_MODEL NIGHTSHIFT_REPOS; do
    [[ -n "${!k:-}" ]] || missing+=("$k")
  done
  if ((${#missing[@]})); then
    [[ -f "$NIGHTSHIFT_CONFIG_PATH" ]] || die "no config at $NIGHTSHIFT_CONFIG_PATH. Run 'nightshift.sh setup' in a terminal first."
    die "unset: ${missing[*]}. Run 'nightshift.sh setup' again."
  fi
  if [[ -n "$NIGHTSHIFT_MODEL_ALLOWLIST" ]] && ! [[ " $NIGHTSHIFT_MODEL_ALLOWLIST " == *" $NIGHTSHIFT_MODEL "* ]]; then
    die "model '$NIGHTSHIFT_MODEL' is not in NIGHTSHIFT_MODEL_ALLOWLIST. Refusing to run."
  fi
  for k in git jq flock timeout; do command -v "$k" >/dev/null || die "missing dependency: $k"; done
  mkdir -p "$NIGHTSHIFT_STATE_DIR/logs" "$NIGHTSHIFT_WORK_DIR"
  [[ -f "$(state attempts.json)" ]] || echo '{}' >"$(state attempts.json)"
}

state() { printf '%s/%s' "$NIGHTSHIFT_STATE_DIR" "$1"; }

# ---------- per-repo resolution from docs/agents (the /setup-meta output) ----------

default_ref() { git -C "$1" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main; }
repo_doc() { git -C "$1" show "$(default_ref "$1"):docs/agents/$2" 2>/dev/null; }

# Sets FORGE (gh|glab|unsupported), LABEL_READY, LABEL_NEEDS_INFO, NOTE for the clone at $1.
# Missing docs fall back the way whips' opening-a-pr does: gh and the canonical role names.
resolve_repo() {
  local dir="$1" tracker labels heading
  NOTE=""
  tracker="$(repo_doc "$dir" issue-tracker.md || true)"
  if [[ -z "$tracker" ]]; then
    FORGE=gh; NOTE="no docs/agents/issue-tracker.md, using gh; run /setup-meta"
  else
    heading="$(sed -n 's/^# Issue tracker:[[:space:]]*//p' <<<"$tracker" | head -n1)"
    case "$heading" in
      GitHub*) FORGE=gh ;;
      GitLab*) FORGE=glab ;;
      *) FORGE=unsupported; NOTE="tracker '${heading:-unknown}' has no CLI mapping here" ;;
    esac
  fi
  labels="$(repo_doc "$dir" triage-labels.md || true)"
  LABEL_READY="$(role_label "$labels" ready-for-agent)"
  LABEL_NEEDS_INFO="$(role_label "$labels" needs-info)"
  [[ -n "$labels" ]] || NOTE="${NOTE:+$NOTE; }no docs/agents/triage-labels.md, using canonical role names"
}

# Right-hand column of the triage-labels table for a canonical role; the role itself when absent.
role_label() {
  local found
  found="$(sed -nE "s/^\|[[:space:]]*\`?$2\`?[[:space:]]*\|[[:space:]]*\`?([^|\`]+)\`?[[:space:]]*\|.*/\1/p" <<<"$1" | head -n1)"
  found="${found%"${found##*[![:space:]]}"}"
  printf '%s' "${found:-$2}"
}

# ---------- forge commands (from the issue-tracker templates), run inside the clone ----------

f_ready_issues() { # dir label -> "createdAt number" for open, unassigned issues
  case "$FORGE" in
    gh) (cd "$1" && gh issue list --state open --label "$2" --limit 100 --json number,createdAt,assignees) |
      jq -r '.[] | select((.assignees | length) == 0) | "\(.createdAt) \(.number)"' ;;
    glab) (cd "$1" && glab issue list --label "$2" --per-page 100 --output json) |
      jq -r '.[] | select((.assignees | length) == 0) | "\(.created_at) \(.iid)"' ;;
  esac
}

f_linked_pr() { # dir n -> "number url isDraft" of an open PR/MR whose body closes #n
  local re='(?i)\b(close[sd]?|fix(e[sd])?|resolve[sd]?) #'"$2"'\b'
  case "$FORGE" in
    gh) (cd "$1" && gh pr list --state open --limit 100 --json number,url,isDraft,body) |
      jq -r --arg re "$re" 'map(select(.body // "" | test($re))) | first // empty | "\(.number) \(.url) \(.isDraft)"' ;;
    glab) (cd "$1" && glab mr list --per-page 100 --output json) |
      jq -r --arg re "$re" 'map(select(.description // "" | test($re))) | first // empty | "\(.iid) \(.web_url) \(.draft)"' ;;
  esac
}

f_has_label() { # dir n label
  case "$FORGE" in
    gh) (cd "$1" && gh issue view "$2" --json labels -q '.labels[].name') | grep -qxF "$3" ;;
    glab) (cd "$1" && glab issue view "$2" --output json) | jq -r '.labels[]' | grep -qxF "$3" ;;
  esac
}

# Claim is the tracker's own: assign the issue to the authenticated user (see the wayfinding Claim).
f_claim() {
  case "$FORGE" in
    gh) (cd "$1" && gh issue edit "$2" --add-assignee @me >/dev/null) ;;
    glab) (cd "$1" && glab issue update "$2" --assignee "$(glab api user | jq -r .username)" >/dev/null) ;;
  esac
}
f_unclaim() {
  case "$FORGE" in
    gh) (cd "$1" && gh issue edit "$2" --remove-assignee @me >/dev/null 2>&1) || true ;;
    glab) (cd "$1" && glab issue update "$2" --unassign >/dev/null 2>&1) || true ;;
  esac
}
f_to_draft() {
  case "$FORGE" in
    gh) (cd "$1" && gh pr ready "$2" --undo >/dev/null 2>&1) ;;
    glab) (cd "$1" && glab mr update "$2" --draft >/dev/null 2>&1) ;;
  esac
}

# ---------- attempts and history ----------

attempts_of() { jq -r --arg k "$1" '.[$k] // 0' "$(state attempts.json)"; }
set_attempts() { # key delta|clear
  local f; f="$(state attempts.json)"
  if [[ "$2" == clear ]]; then jq --arg k "$1" 'del(.[$k])' "$f"; else jq --arg k "$1" '.[$k] = ((.[$k] // 0) + 1)' "$f"; fi >"$f.tmp"
  mv "$f.tmp" "$f"
}
record() { # repo n outcome pr log detail
  jq -cn --arg ts "$(date -Is)" --arg repo "$1" --arg n "$2" --arg outcome "$3" --arg pr "$4" \
    --arg log "$5" --arg detail "$6" --arg model "$NIGHTSHIFT_MODEL" \
    '{ts:$ts, repo:$repo, issue:$n, outcome:$outcome, pr:$pr, model:$model, log:$log, detail:$detail}' >>"$(state runs.jsonl)"
}

# ---------- run ----------

recover_stale() { # claims a dead run left behind; safe because we hold the lock
  local f dir n; f="$(state active)"
  [[ -s "$f" ]] || return 0
  while read -r dir n; do
    [[ -n "$n" ]] || continue
    resolve_repo "$dir"
    log "releasing stale claim $dir#$n"
    f_unclaim "$dir" "$n"
    if [[ -n "$(f_linked_pr "$dir" "$n" || true)" ]]; then
      record "$dir" "$n" recovered_pr "" "" "previous run ended without reporting"
    else
      set_attempts "$dir#$n" +1; record "$dir" "$n" interrupted "" "" "previous run ended without reporting"
    fi
  done <"$f"
  : >"$f"
}

write_prompt() { # dir n file
  cat >"$3" <<PROMPT
/whips Pick up issue #$2 with playbooks/triage.md intake. This is an unattended nightshift run, so no human is watching.

- Work only on #$2, in the current directory: a fresh worktree detached at the default branch. Create your own branch per playbooks/opening-a-pr.md.
- Resolve the tracker and labels from docs/agents/issue-tracker.md and docs/agents/triage-labels.md, as the playbooks say.
- A thin brief follows intake step 4 (triage notes, move to the needs-info role) and stops there.
- Otherwise finish with playbooks/opening-a-pr.md: a draft PR whose body says "Closes #$2". Never mark it ready, never merge, never enable auto-merge.
- Never wait for an answer. A decision you cannot make goes into the PR body or an issue comment.
PROMPT
}

run_one() { # dir n
  local dir="$1" n="$2" key="$1#$2" ts wt logf prompt rc=0
  ts="$(date +%Y%m%d-%H%M%S)-$$"
  logf="$(state logs)/$(basename "$dir")-$n-$ts.log"
  prompt="${logf%.log}.prompt.md"

  f_claim "$dir" "$n" || { log "could not claim $key"; return; }
  printf '%s %s\n' "$dir" "$n" >>"$(state active)"
  wt="$NIGHTSHIFT_WORK_DIR/worktrees/$(basename "$dir")-$n-$ts"
  mkdir -p "$(dirname "$wt")"
  if ! git -C "$dir" worktree add --quiet --detach "$wt" "$(default_ref "$dir")" >&2; then
    f_unclaim "$dir" "$n"; sed -i "\|^$dir $n\$|d" "$(state active)"
    set_attempts "$key" +1; record "$dir" "$n" setup_failed "" "" "git worktree add failed"; return
  fi
  write_prompt "$dir" "$n" "$prompt"

  log "running agent on $key (log: $logf)"
  (
    cd "$wt"
    export NIGHTSHIFT_MODEL NIGHTSHIFT_ISSUE="$n" NIGHTSHIFT_WORKTREE="$wt" NIGHTSHIFT_PROMPT_FILE="$prompt"
    NIGHTSHIFT_PROMPT="$(cat "$prompt")"; export NIGHTSHIFT_PROMPT
    timeout --kill-after=60 "$((NIGHTSHIFT_TIMEOUT_MIN * 60))" bash -c "$NIGHTSHIFT_AGENT_CMD"
  ) >"$logf" 2>&1 </dev/null || rc=$?

  local pr num url draft outcome detail="agent exit $rc"
  pr="$(f_linked_pr "$dir" "$n" || true)"; url=""
  if [[ -n "$pr" ]]; then
    read -r num url draft <<<"$pr"; outcome=pr_opened; set_attempts "$key" clear
    if [[ "$draft" != true ]]; then
      detail="$detail; PR was not a draft"
      f_to_draft "$dir" "$num" && detail="$detail, converted back to draft"
    fi
  elif f_has_label "$dir" "$n" "$LABEL_NEEDS_INFO"; then
    outcome=needs_info; set_attempts "$key" clear
  elif ((rc == 124 || rc == 137)); then
    outcome=timeout; set_attempts "$key" +1
  else
    outcome=no_pr; set_attempts "$key" +1
  fi
  f_unclaim "$dir" "$n"
  sed -i "\|^$dir $n\$|d" "$(state active)"
  if [[ "$outcome" == pr_opened || "$outcome" == needs_info ]]; then
    git -C "$dir" worktree remove --force "$wt" >/dev/null 2>&1 || true
  else
    detail="$detail; worktree kept at $wt"
  fi
  record "$dir" "$n" "$outcome" "$url" "$logf" "$detail"
  SUMMARY+=("$(basename "$dir")#$n $outcome${url:+ $url}")
}

cmd_run() {
  load_config; require_config
  exec 9>"$(state lock)"
  flock -n 9 || { log "another run holds the lock"; exit 0; }
  date -Is >"$(state last-start)"
  recover_stale
  SUMMARY=()
  local dir created n started=0
  for dir in $NIGHTSHIFT_REPOS; do
    ((started < NIGHTSHIFT_MAX_ISSUES)) || break
    git -C "$dir" fetch --quiet --prune origin || { record "$dir" - fetch_failed "" "" ""; continue; }
    resolve_repo "$dir"
    [[ -z "$NOTE" ]] || log "$dir: $NOTE"
    [[ "$FORGE" != unsupported ]] || { record "$dir" - unsupported_tracker "" "" "$NOTE"; continue; }
    while read -r created n; do
      [[ -n "${n:-}" ]] || continue
      ((started < NIGHTSHIFT_MAX_ISSUES)) || break
      (($(attempts_of "$dir#$n") < NIGHTSHIFT_MAX_ATTEMPTS)) || continue
      [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || continue
      run_one "$dir" "$n"; started=$((started + 1))
    done < <(f_ready_issues "$dir" "$LABEL_READY" | sort)
    : "$created"
  done
  date -Is >"$(state last-finish)"
  if ((${#SUMMARY[@]})); then printf 'nightshift: %s\n' "$(IFS=';'; echo "${SUMMARY[*]}")"; else echo 'nightshift: nothing eligible'; fi
}

cmd_check() { # exit 0 when something is eligible, 1 when not
  load_config; require_config
  local dir created n
  for dir in $NIGHTSHIFT_REPOS; do
    resolve_repo "$dir"
    [[ "$FORGE" != unsupported ]] || continue
    while read -r created n; do
      [[ -n "${n:-}" ]] || continue
      (($(attempts_of "$dir#$n") < NIGHTSHIFT_MAX_ATTEMPTS)) || continue
      [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || continue
      printf 'eligible: %s#%s (since %s)\n' "$dir" "$n" "$created"; exit 0
    done < <(f_ready_issues "$dir" "$LABEL_READY" | sort)
  done
  echo 'nothing eligible'; exit 1
}

cmd_status() {
  load_config
  printf 'config: %s\nagent:  %s\nmodel:  %s\nlast:   %s .. %s\n' "$NIGHTSHIFT_CONFIG_PATH" \
    "${NIGHTSHIFT_AGENT_CMD:-unset}" "${NIGHTSHIFT_MODEL:-unset}" \
    "$(cat "$(state last-start)" 2>/dev/null || echo never)" "$(cat "$(state last-finish)" 2>/dev/null || echo never)"
  [[ -f "$(state runs.jsonl)" ]] && tail -n "${1:-10}" "$(state runs.jsonl)" |
    jq -r '"\(.ts)  \(.repo)#\(.issue)  \(.outcome)  \(.pr)  \(.detail)"'
  return 0
}

cmd_reset() { load_config; require_config; set_attempts "${1:?usage: reset <repo-dir>#<n>}" clear; }

# ---------- setup: detect, ask, persist ----------

AGENTS="opencode pi omp codex claude grok gemini cursor-agent aider goose amp droid kimi qwen crush"

# Offered only where the CLI documents a non-interactive mode; verify with '<agent> --help'.
preset_cmd() {
  case "$1" in
    opencode) printf '%s' 'opencode run --auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    codex) printf '%s' 'codex exec --full-auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    claude) printf '%s' 'claude -p --model "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"' ;;
    *) return 1 ;;
  esac
}

detect_agents() { local a; for a in $AGENTS; do command -v "$a" >/dev/null 2>&1 && echo "$a"; done; return 0; }

detect_models() {
  local c="${XDG_CONFIG_HOME:-$HOME/.config}" f
  command -v opencode >/dev/null 2>&1 && { timeout 30 opencode models 2>/dev/null | grep -E '^[^[:space:]]+/[^[:space:]]+$' || true; }
  for f in "$c/opencode/opencode.json" "$c/opencode/opencode.jsonc"; do
    [[ -f "$f" ]] && sed -nE 's/.*"(model|small_model)"[[:space:]]*:[[:space:]]*"([^"]+)".*/\2/p' "$f"
  done
  for f in "$HOME/.pi/agent/settings.json" "$HOME/.omp/agent/settings.json"; do
    [[ -f "$f" ]] && jq -r 'select(.defaultModel) | [.defaultProvider, .defaultModel] | map(select(.)) | join("/")' "$f" 2>/dev/null
  done
  f="$HOME/.codex/config.toml"
  [[ -f "$f" ]] && sed -nE 's/^[[:space:]]*model[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/p' "$f"
  f="$HOME/.claude/settings.json"
  [[ -f "$f" ]] && jq -r '.model // empty' "$f" 2>/dev/null
  return 0
}

detect_env_keys() { compgen -e | grep -E '(_API_KEY|_TOKEN)$' | grep -vxE 'GH_TOKEN|GITHUB_TOKEN|GITLAB_TOKEN' | sort || true; }

cmd_detect() {
  load_config
  printf 'config: %s (%s)\n' "$NIGHTSHIFT_CONFIG_PATH" "$([[ -f "$NIGHTSHIFT_CONFIG_PATH" ]] && echo exists || echo missing)"
  printf '\nagents on PATH:\n'; detect_agents | sed 's/^/  /'
  printf '\nmodels in harness configs:\n'; detect_models | sort -u | sed 's/^/  /'
  printf '\nprovider env vars (names only):\n'; detect_env_keys | sed 's/^/  /'
  local dir
  for dir in ${NIGHTSHIFT_REPOS:-}; do
    resolve_repo "$dir"
    printf '\n%s: tracker %s, ready label "%s", needs-info label "%s"%s\n' "$dir" "$FORGE" "$LABEL_READY" "$LABEL_NEEDS_INFO" "${NOTE:+ ($NOTE)}"
  done
}

choose() { # prompt options... ; the extra last entry is free text
  local prompt="$1" reply i o; shift
  { printf '\n%s\n' "$prompt"
    i=1; for o in "$@"; do printf '  %d) %s\n' "$i" "$o"; i=$((i + 1)); done
    printf '  %d) enter manually\n' "$i"; } >&2
  while read -r -p '> ' reply </dev/tty; do
    if [[ "$reply" =~ ^[0-9]+$ ]] && ((reply >= 1 && reply <= $#)); then printf '%s' "${!reply}"; return; fi
    if [[ "$reply" == "$i" ]]; then read -r -p 'value> ' reply </dev/tty; [[ -n "$reply" ]] && { printf '%s' "$reply"; return; }; fi
    echo 'pick a number from the list' >&2
  done
}
ask() { local r; read -r -p "$1${2:+ [$2]}: " r </dev/tty; printf '%s' "${r:-$2}"; }

cmd_setup() {
  load_config
  local agent_cmd="" model="" repos="" allow="" maxi="" tty=0 a dir
  while (($#)); do
    case "$1" in
      --agent-cmd) agent_cmd="$2" ;; --model) model="$2" ;; --repos) repos="$2" ;;
      --allowlist) allow="$2" ;; --max-issues) maxi="$2" ;;
      *) die "unknown setup flag: $1" ;;
    esac
    shift 2
  done
  { : </dev/tty; } 2>/dev/null && tty=1
  if [[ -z "$agent_cmd" ]]; then
    ((tty)) || die "setup needs a terminal to ask, or --agent-cmd and --model"
    local opts=()
    while read -r a; do opts+=("$(preset_cmd "$a" || echo "$a <type the full non-interactive command>")"); done < <(detect_agents)
    agent_cmd="$(choose 'Agent command (it sees $NIGHTSHIFT_MODEL, $NIGHTSHIFT_PROMPT, $NIGHTSHIFT_PROMPT_FILE):' "${opts[@]}")"
    [[ "$agent_cmd" != *"<type the full"* ]] || agent_cmd="$(ask 'full command' "")"
  fi
  if [[ -z "$model" ]]; then
    ((tty)) || die "setup needs a terminal to ask, or --model"
    printf '\nprovider env vars set: %s\n' "$(detect_env_keys | tr '\n' ' ')" >&2
    local models=(); mapfile -t models < <(detect_models | sort -u)
    model="$(choose 'Model for every run:' "${models[@]}")"
  fi
  if ((tty)); then
    [[ -n "$repos" ]] || repos="$(ask 'local clones to work on (space separated paths)' "${NIGHTSHIFT_REPOS:-}")"
    [[ -n "$allow" ]] || allow="$(ask 'model allowlist (space separated, empty for none)' "${NIGHTSHIFT_MODEL_ALLOWLIST:-}")"
    [[ -n "$maxi" ]] || maxi="$(ask 'issues per run' "$NIGHTSHIFT_MAX_ISSUES")"
  fi
  [[ -n "$agent_cmd" && -n "$model" ]] || die "agent command and model are required"
  repos="${repos:-${NIGHTSHIFT_REPOS:-}}"; [[ -n "$repos" ]] || die "no repos given"
  local abs=()
  for dir in $repos; do
    dir="$(cd "${dir/#\~/$HOME}" 2>/dev/null && pwd)" || die "not a directory: $dir"
    git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || die "not a git clone: $dir"
    abs+=("$dir")
  done
  mkdir -p "$(dirname "$NIGHTSHIFT_CONFIG_PATH")"
  {
    printf '# Written by "nightshift.sh setup" on %s. Re-run setup to change.\n' "$(date -Is)"
    printf 'NIGHTSHIFT_AGENT_CMD=%q\nNIGHTSHIFT_MODEL=%q\nNIGHTSHIFT_MODEL_ALLOWLIST=%q\n' "$agent_cmd" "$model" "$allow"
    printf 'NIGHTSHIFT_REPOS=%q\nNIGHTSHIFT_MAX_ISSUES=%q\n' "${abs[*]}" "${maxi:-$NIGHTSHIFT_MAX_ISSUES}"
  } >"$NIGHTSHIFT_CONFIG_PATH"
  unset NIGHTSHIFT_AGENT_CMD NIGHTSHIFT_MODEL NIGHTSHIFT_MODEL_ALLOWLIST NIGHTSHIFT_REPOS NIGHTSHIFT_MAX_ISSUES
  load_config; require_config
  echo "saved $NIGHTSHIFT_CONFIG_PATH"
  cmd_detect | sed -n '/^\//,$p'
}

case "${1:-}" in
  setup) shift; cmd_setup "$@" ;;
  detect) cmd_detect ;;
  check) cmd_check ;;
  run) cmd_run ;;
  status) shift; cmd_status "${1:-10}" ;;
  reset) shift; cmd_reset "${1:-}" ;;
  *) echo 'usage: nightshift.sh setup [flags] | detect | check | run | status [N] | reset <repo-dir>#<n>' >&2; exit 2 ;;
esac
