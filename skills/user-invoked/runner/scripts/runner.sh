#!/usr/bin/env bash
# Pick ready-for-agent issues, hand each to /whips triage intake, land per the risk tier.
# Tracker and label strings come from each repo's docs/agents/*.md (written by /setup-meta).
# The agent command and model come only from the config written by `setup`.
# Renamed from nightshift: RUNNER_* vars and ~/.config/runner paths are current;
# a legacy nightshift config file or env is still honored once, with a warning.
set -euo pipefail

die() { printf 'runner: %s\n' "$*" >&2; exit 2; }
log() { printf '%s runner: %s\n' "$(date -Is)" "$*" >&2; }

# ---------- config ----------

# One-time bridge from the old nightshift names. New code uses RUNNER_* only.
bridge_legacy() {
  local pair new old
  for pair in CONFIG AGENT_CMD MODEL REPOS MODEL_ALLOWLIST MAX_ISSUES MAX_ATTEMPTS TIMEOUT_MIN STATE_DIR WORK_DIR; do
    new="RUNNER_$pair"; old="NIGHTSHIFT_$pair"
    [[ -n "${!new:-}" ]] || [[ -z "${!old:-}" ]] || printf -v "$new" '%s' "${!old}"
  done
}

load_config() {
  bridge_legacy
  RUNNER_CONFIG_PATH="${RUNNER_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/runner/config.sh}"
  if [[ ! -f "$RUNNER_CONFIG_PATH" ]]; then
    local legacy="${XDG_CONFIG_HOME:-$HOME/.config}/nightshift/config.sh"
    if [[ -f "$legacy" ]]; then
      RUNNER_CONFIG_PATH="$legacy"
      log "using legacy nightshift config at $legacy; re-run setup to migrate"
    fi
  fi
  # Caller env wins over the file for one call.
  local -A caller=()
  local v
  for v in ${!RUNNER_@}; do caller[$v]="${!v}"; done
  # shellcheck disable=SC1090
  [[ -f "$RUNNER_CONFIG_PATH" ]] && source "$RUNNER_CONFIG_PATH"
  for v in "${!caller[@]}"; do printf -v "$v" '%s' "${caller[$v]}"; done
  bridge_legacy
  : "${RUNNER_MODEL_ALLOWLIST:=}"
  : "${RUNNER_MAX_ISSUES:=1}"
  : "${RUNNER_MAX_ATTEMPTS:=2}"
  : "${RUNNER_TIMEOUT_MIN:=120}"
  : "${RUNNER_CLAIM_TTL_MIN:=$((RUNNER_TIMEOUT_MIN + 30))}"
  : "${RUNNER_STATE_DIR:=${XDG_STATE_HOME:-$HOME/.local/state}/runner}"
  : "${RUNNER_WORK_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/runner}"
}

require_config() {
  local missing=() k
  for k in RUNNER_AGENT_CMD RUNNER_MODEL RUNNER_REPOS; do
    [[ -n "${!k:-}" ]] || missing+=("$k")
  done
  if ((${#missing[@]})); then
    [[ -f "$RUNNER_CONFIG_PATH" ]] || die "no config at $RUNNER_CONFIG_PATH. Run 'runner.sh setup' in a terminal first."
    die "unset: ${missing[*]}. Run 'runner.sh setup' again."
  fi
  if [[ -n "$RUNNER_MODEL_ALLOWLIST" ]] && ! [[ " $RUNNER_MODEL_ALLOWLIST " == *" $RUNNER_MODEL "* ]]; then
    die "model '$RUNNER_MODEL' is not in RUNNER_MODEL_ALLOWLIST. Refusing to run."
  fi
  for k in git jq flock timeout; do command -v "$k" >/dev/null || die "missing dependency: $k"; done
  mkdir -p "$RUNNER_STATE_DIR/logs" "$RUNNER_WORK_DIR"
  [[ -f "$(state attempts.json)" ]] || echo '{}' >"$(state attempts.json)"
}

state() { printf '%s/%s' "$RUNNER_STATE_DIR" "$1"; }

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
      jq -r '.[] | select((.assignees | length) == 0) | "\(.createdAt) \(.iid)"' ;;
  esac
}

# Batch PR map: one list call per repo per run (issue #87). Filtering loops
# call f_linked_pr per candidate; without a cache that is O(n) API calls.
# preload fills __PR_MAP_JSON once, f_linked_pr filters it locally.
# After an agent may have opened a PR, call refresh_pr_map so the next
# lookup sees the new branch. Total cost is 1 + processed issues per repo.
__PR_MAP_KEY=""
__PR_MAP_JSON=""
preload_pr_map() { # dir ; fetch once per repo per FORGE
  local dir="$1" raw; local key="$FORGE:$dir"
  [[ "$__PR_MAP_KEY" == "$key" ]] && return 0
  case "$FORGE" in
    gh) raw="$(cd "$dir" && gh pr list --state open --limit 100 --json number,url,isDraft,body 2>/dev/null)" || raw="[]" ;;
    glab) raw="$(cd "$dir" && glab mr list --per-page 100 --output json 2>/dev/null)" || raw="[]" ;;
    *) raw="[]" ;;
  esac
  __PR_MAP_KEY="$key"
  __PR_MAP_JSON="$raw"
}
refresh_pr_map() { # dir ; force refetch after an agent run
  __PR_MAP_KEY=""
  preload_pr_map "$1"
}
f_linked_pr() { # dir n -> "number url isDraft" of an open PR/MR whose body closes #n (PRs open ready; isDraft is informational for legacy drafts only)
  local re='(?i)\b(close[sd]?|fix(e[sd])?|resolve[sd]?) #'"$2"'\b'
  preload_pr_map "$1"
  case "$FORGE" in
    gh) jq -r --arg re "$re" 'map(select(.body // "" | test($re))) | first // empty | "\(.number) \(.url) \(.isDraft)"' <<<"$__PR_MAP_JSON" ;;
    glab) jq -r --arg re "$re" 'map(select(.description // "" | test($re))) | first // empty | "\(.iid) \(.web_url) \(.draft)"' <<<"$__PR_MAP_JSON" ;;
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


# Markers live in issue comments on GitHub, so a wiped state dir or a reboot
# keeps the same count. Comments by other logins never count.
me_login() { gh_me_login; }
gh_me_login() {
  if [[ -z "${__ME_LOGIN:-}" ]]; then
    __ME_LOGIN="$(gh api user -q .login 2>/dev/null)" || __ME_LOGIN=""
  fi
  printf '%s' "$__ME_LOGIN"
}
f_comments() { # dir n -> JSON array of {id,author,body}
  case "$FORGE" in
    gh) (cd "$1" && gh issue view "$2" --comments --json comments -q '.comments // [] | map({id, author: .author.login, body})' 2>/dev/null) || echo '[]' ;;
    *) echo '[]' ;;
  esac
}
# Highest n= among my <!-- runner-attempt n=<k> outcome=<...> --> markers, counting only markers after the last reset.
f_attempt_count() { # dir n -> number from GitHub
  local me; me="$(gh_me_login)"
  f_comments "$1" "$2" | jq -r --arg me "$me" '
    [.[] | select(.author == $me) | .body // ""]
    | (map(. | contains("<!-- runner-attempt reset -->")) | to_entries | map(select(.value) | .key) | last) as $r
    | (if $r == null then . else .[$r + 1:] end)
    | ([.[] | capture("<!-- runner-attempt n=(?<k>[0-9]+)")? | select(.) | .k | tonumber] | max // 0)'
}
f_attempt_write() { # dir n k outcome ; append one marker comment
  case "$FORGE" in
    gh) (cd "$1" && gh issue comment "$2" --body "<!-- runner-attempt n=$3 outcome=$4 -->
runner: attempt $3 ended $4" >/dev/null) ;;
  esac
}
f_attempt_reset() { # dir n ; one reset marker comment
  case "$FORGE" in
    gh) (cd "$1" && gh issue comment "$2" --body '<!-- runner-attempt reset -->
runner: attempts reset' >/dev/null) ;;
  esac
}
# My latest <!-- runner-claim run=<id> ts=<epoch> branch=<name> --> comment, "id ts branch" or empty.
f_claim_marker() { # dir n
  local me; me="$(gh_me_login)"
  f_comments "$1" "$2" | jq -r --arg me "$me" '
    [.[] | select(.author == $me) | .body // "" | capture("<!-- runner-claim run=(?<r>[^ >]+) ts=(?<t>[0-9]+) branch=(?<b>[^ >]+) -->")? | select(.) | "\(.r) \(.t) \(.b)"]
    | last // empty'
}
f_claim_write() { # dir n run_id branch ; one comment per claim, edited is folded into the reaper
  case "$FORGE" in
    gh) (cd "$1" && gh issue comment "$2" --body "<!-- runner-claim run=$3 ts=$(date +%s) branch=$4 -->
runner: claimed for run $3" >/dev/null) ;;
  esac
}
f_assignees() { # dir n -> login per line
  case "$FORGE" in
    gh) (cd "$1" && gh issue view "$2" --json assignees -q '.assignees[].login' 2>/dev/null) || true ;;
    glab) (cd "$1" && glab issue view "$2" --output json 2>/dev/null) | jq -r '.assignees[]?' || true ;;
  esac
}
claim_age_min() { # ts_epoch now_epoch -> minutes; one helper for every TTL check
  printf '%s' "$((($2 - $1) / 60))"
}
# Newest commit on origin/<branch> within TTL minutes? Prints yes/no.
branch_fresh() { # dir branch ttl_min
  local ts now
  ts="$(git -C "$1" log -1 --format=%ct "origin/$2" 2>/dev/null)" || { printf 'no'; return; }
  now="$(date +%s)"
  (( (now - ts) / 60 < $3 )) && printf 'yes' || printf 'no'
}
# ---------- attempts and history ----------

# attempts.json is a cache; the count of record comes from GitHub markers.
attempts_of() { jq -r --arg k "$1" '.[$k] // 0' "$(state attempts.json)"; }
set_attempts() { # key n|delta|clear ; syncs the local cache only
  local f; f="$(state attempts.json)"
  if [[ "$2" == clear ]]; then jq --arg k "$1" 'del(.[$k])' "$f";
  elif [[ "$2" =~ ^[0-9]+$ ]]; then jq --arg k "$1" --argjson n "$2" '.[$k] = $n' "$f";
  else jq --arg k "$1" '.[$k] = ((.[$k] // 0) + 1)' "$f"; fi >"$f.tmp"
  mv "$f.tmp" "$f"
}
attempts_live() { # dir n -> count from GitHub, cache synced (GitLab: local cache only)
  local key="$1#$2" live=0
  if [[ "$FORGE" == gh ]]; then
    live="$(f_attempt_count "$1" "$2")"
    set_attempts "$key" "$live"
  else
    live="$(attempts_of "$key")"
  fi
  printf '%s' "$live"
}
record() { # repo n outcome pr log detail
  jq -cn --arg ts "$(date -Is)" --arg repo "$1" --arg n "$2" --arg outcome "$3" --arg pr "$4" \
    --arg log "$5" --arg detail "$6" --arg model "$RUNNER_MODEL" \
    '{ts:$ts, repo:$repo, issue:$n, outcome:$outcome, pr:$pr, model:$model, log:$log, detail:$detail}' >>"$(state runs.jsonl)"
}

# ---------- run ----------

# The reaper releases an orphan claim only when every guard holds:
# the marker is past RUNNER_CLAIM_TTL_MIN, I am the sole assignee,
# no open PR closes the issue, and the recorded branch has no fresh
# commit. An issue assigned to a human is never touched. Runs are
# serialized by the flock in cmd_run, so the lock is free here.
reap_one() { # dir n ; releases an orphan claim or leaves it alone
  local dir="$1" n="$2" me marker run_id ts branch age a mine_only
  me="$(gh_me_login)"
  [[ -n "$me" ]] || return 0
  marker="$(f_claim_marker "$dir" "$n")"
  [[ -n "$marker" ]] || return 0
  read -r run_id ts branch <<<"$marker"
  age="$(claim_age_min "$ts" "$(date +%s)")"
  ((age >= RUNNER_CLAIM_TTL_MIN)) || return 0
  mine_only=1
  while read -r a; do
    [[ -z "$a" ]] || [[ "$a" == "$me" ]] || mine_only=0
  done < <(f_assignees "$dir" "$n")
  ((mine_only)) || return 0
  [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || return 0
  [[ "$(branch_fresh "$dir" "$branch" "$RUNNER_CLAIM_TTL_MIN")" == no ]] || return 0
  log "releasing orphan claim $dir#$n (run $run_id, age ${age}m)"
  f_unclaim "$dir" "$n"
  if [[ "$FORGE" == gh ]]; then
    local k; k=$(( $(f_attempt_count "$dir" "$n") + 1 ))
    f_attempt_write "$dir" "$n" "$k" interrupted
    set_attempts "$dir#$n" "$k"
  else
    set_attempts "$dir#$n" +1
  fi
  record "$dir" "$n" interrupted "" "" "orphan claim released at next start"
}
recover_stale() { # claims a dead run left behind; safe because we hold the lock
  local f dir n; f="$(state active)"
  if [[ -s "$f" ]]; then
    while read -r dir n; do
      [[ -n "$n" ]] || continue
      resolve_repo "$dir"
      [[ "$FORGE" == unsupported ]] && continue
      reap_one "$dir" "$n"
    done <"$f"
    : >"$f"
  fi
  local repo
  for repo in $RUNNER_REPOS; do
    resolve_repo "$repo"
    [[ "$FORGE" == gh ]] || continue
    git -C "$repo" fetch --quiet --prune origin || continue
    preload_pr_map "$repo"
    while read -r n; do
      [[ -n "$n" ]] || continue
      reap_one "$repo" "$n"
    done < <((cd "$repo" && gh issue list --state open --assignee @me --limit 100 --json number -q '.[].number' 2>/dev/null) || true)
  done
}

write_prompt() { # dir n file [resume_branch]
  if [[ -n "${4:-}" ]]; then
    cat >"$3" <<PROMPT
/whips Pick up issue #$2 with playbooks/pickup.md. This is an unattended runner run, so no human is watching.

- Continue from branch $4, checked out in the current directory. Do not create a new branch.
- The prior run timed out or ended without a PR; its trail is in the issue comments and this branch.
- Otherwise finish with playbooks/opening-a-pr.md, landing per the risk tier (low-risk PASS lands, high waits for the human). Never enable auto-merge.
- Never wait for an answer. A decision you cannot make goes into the PR body or an issue comment.
PROMPT
  else
    cat >"$3" <<PROMPT
/whips Pick up issue #$2 with playbooks/triage.md intake. This is an unattended runner run, so no human is watching.

- Work only on #$2, in the current directory: a fresh worktree detached at the default branch. Create your own branch per playbooks/opening-a-pr.md.
- Resolve the tracker and labels from docs/agents/issue-tracker.md and docs/agents/triage-labels.md, as the playbooks say.
- A thin brief follows intake step 4 (triage notes, move to the needs-info role) and stops there.
- Otherwise finish with playbooks/opening-a-pr.md, landing per the risk tier (low-risk PASS lands, high waits for the human). Never enable auto-merge.
- Never wait for an answer. A decision you cannot make goes into the PR body or an issue comment.
PROMPT
  fi
}

# Remote branch that holds prior work for issue n, or empty. The claim
# marker names the branch; the WIP branch is the timeout fallback.
resume_branch() { # dir n -> branch name or empty
  local marker branch
  marker="$(f_claim_marker "$1" "$2")"
  if [[ -n "$marker" ]]; then
    branch="${marker##* }"
    git -C "$1" show-ref --verify --quiet "refs/remotes/origin/$branch" && { printf '%s' "$branch"; return; }
  fi
  if git -C "$1" show-ref --verify --quiet "refs/remotes/origin/wip/runner-issue-$2"; then
    printf 'wip/runner-issue-%s' "$2"
  fi
}
# Push timeout/no_pr work so a later run resumes it. Follows the pause
# rule: one wip: commit for a dirty tree, then push to wip/runner-issue-N.
push_wip() { # dir wt n ; prints the pushed branch or empty
  local dir="$1" wt="$2" n="$3"; local branch="wip/runner-issue-$n"
  git -C "$wt" rev-parse --git-dir >/dev/null 2>&1 || return 0
  if ! git -C "$wt" log --oneline -1 >/dev/null 2>&1; then
    [[ -z "$(git -C "$wt" status --porcelain)" ]] && return 0
  fi
  if [[ -n "$(git -C "$wt" status --porcelain)" ]]; then
    git -C "$wt" add -A 2>/dev/null
    git -C "$wt" -c user.name=runner -c user.email=runner@local \
      commit --quiet -m "wip: unattended run interrupted on issue #$n" \
      -m "Resumable via playbooks/pickup.md." || return 0
  fi
  git -C "$wt" rev-list --count HEAD >/dev/null 2>&1 || return 0
  git -C "$wt" branch -f "$branch" HEAD >/dev/null 2>&1
  git -C "$wt" push --quiet origin "$branch" >/dev/null 2>&1 || return 0
  printf '%s' "$branch"
}

run_one() { # dir n
  local dir="$1" n="$2" key="$1#$2" ts wt logf prompt rc=0 resume="" run_id branch=""
  ts="$(date +%Y%m%d-%H%M%S)-$$"
  logf="$(state logs)/$(basename "$dir")-$n-$ts.log"
  prompt="${logf%.log}.prompt.md"
  run_id="$(basename "$dir")-$n-$ts"

  refresh_pr_map "$dir"
  [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || { log "skip $key: PR opened since listing"; return; }
  resume="$(resume_branch "$dir" "$n")"
  [[ -z "$resume" ]] || log "resuming $key from $resume"

  f_claim "$dir" "$n" || { log "could not claim $key"; return; }
  [[ "$FORGE" == gh ]] && f_claim_write "$dir" "$n" "$run_id" "${resume:-wip/runner-issue-$n}"
  printf '%s %s\n' "$dir" "$n" >>"$(state active)"
  wt="$RUNNER_WORK_DIR/worktrees/$(basename "$dir")-$n-$ts"
  mkdir -p "$(dirname "$wt")"
  if [[ -n "$resume" ]]; then
    git -C "$dir" worktree add --quiet "$wt" "origin/$resume" >&2 || resume_add_failed=1
  fi
  if [[ -z "$resume" ]] || [[ -n "${resume_add_failed:-}" ]]; then
    [[ -z "$resume" ]] || log "resume branch $resume gone, starting fresh"
    resume=""
    if ! git -C "$dir" worktree add --quiet --detach "$wt" "$(default_ref "$dir")" >&2; then
      f_unclaim "$dir" "$n"; sed -i "\|^$dir $n\$|d" "$(state active)"
      fail_attempt "$dir" "$n" setup_failed; record "$dir" "$n" setup_failed "" "" "git worktree add failed"; return
    fi
  fi
  write_prompt "$dir" "$n" "$prompt" "$resume"

  log "running agent on $key (log: $logf)"
  (
    cd "$wt"
    export RUNNER_MODEL RUNNER_ISSUE="$n" RUNNER_WORKTREE="$wt" RUNNER_PROMPT_FILE="$prompt" RUNNER_RESUME_BRANCH="$resume"
    RUNNER_PROMPT="$(cat "$prompt")"; export RUNNER_PROMPT
    timeout --kill-after=60 "$((RUNNER_TIMEOUT_MIN * 60))" bash -c "$RUNNER_AGENT_CMD"
  ) >"$logf" 2>&1 </dev/null || rc=$?

  local pr num url draft outcome detail="agent exit $rc"
  refresh_pr_map "$dir"; pr="$(f_linked_pr "$dir" "$n" || true)"; url=""
  if [[ -n "$pr" ]]; then
    read -r num url draft <<<"$pr"; outcome=pr_opened; clear_attempts "$dir" "$n"
  elif f_has_label "$dir" "$n" "$LABEL_NEEDS_INFO"; then
    outcome=needs_info; clear_attempts "$dir" "$n"
  elif ((rc == 124 || rc == 137)); then
    outcome=timeout; fail_attempt "$dir" "$n" timeout
  else
    outcome=no_pr; fail_attempt "$dir" "$n" no_pr
  fi
  f_unclaim "$dir" "$n"
  sed -i "\|^$dir $n\$|d" "$(state active)"
  if [[ "$outcome" == pr_opened || "$outcome" == needs_info ]]; then
    git -C "$dir" worktree remove --force "$wt" >/dev/null 2>&1 || true
  else
    branch="$(push_wip "$dir" "$wt" "$n")"
    git -C "$dir" worktree remove --force "$wt" >/dev/null 2>&1 || true
    if [[ -n "$branch" ]]; then
      detail="$detail; wip pushed to $branch"
    else
      detail="$detail; no commits to push"
    fi
  fi
  record "$dir" "$n" "$outcome" "$url" "$logf" "$detail"
  SUMMARY+=("$(basename "$dir")#$n $outcome${url:+ $url}")
}
# One failed attempt: append the GitHub marker and sync the cache.
fail_attempt() { # dir n outcome
  if [[ "$FORGE" == gh ]]; then
    local k; k=$(( $(f_attempt_count "$1" "$2") + 1 ))
    f_attempt_write "$1" "$2" "$k" "$3"
    set_attempts "$1#$2" "$k"
  else
    set_attempts "$1#$2" +1
  fi
}
clear_attempts() { set_attempts "$1#$2" clear; }

cmd_run() {
  load_config; require_config
  if [[ -f "$(state stop)" ]]; then log stopped; exit 0; fi
  exec 9>"$(state lock)"
  flock -n 9 || { log "another run holds the lock"; exit 0; }
  date -Is >"$(state last-start)"
  recover_stale
  SUMMARY=()
  local dir created n started=0
  for dir in $RUNNER_REPOS; do
    ((started < RUNNER_MAX_ISSUES)) || break
    git -C "$dir" fetch --quiet --prune origin || { record "$dir" - fetch_failed "" "" ""; continue; }
    resolve_repo "$dir"
    [[ -z "$NOTE" ]] || log "$dir: $NOTE"
    [[ "$FORGE" != unsupported ]] || { record "$dir" - unsupported_tracker "" "" "$NOTE"; continue; }
    preload_pr_map "$dir"
    while read -r created n; do
      [[ -n "${n:-}" ]] || continue
      ((started < RUNNER_MAX_ISSUES)) || break
      (($(attempts_live "$dir" "$n") < RUNNER_MAX_ATTEMPTS)) || continue
      [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || continue
      run_one "$dir" "$n"; started=$((started + 1))
    done < <(f_ready_issues "$dir" "$LABEL_READY" | sort)
    : "$created"
  done
  date -Is >"$(state last-finish)"
  if ((${#SUMMARY[@]})); then printf 'runner: %s\n' "$(IFS=';'; echo "${SUMMARY[*]}")"; else echo 'runner: nothing eligible'; fi
}

cmd_check() { # exit 0 when something is eligible, 1 when not
  load_config; require_config
  if [[ -f "$(state stop)" ]]; then echo stopped; exit 1; fi
  local dir created n
  for dir in $RUNNER_REPOS; do
    resolve_repo "$dir"
    [[ "$FORGE" != unsupported ]] || continue
    preload_pr_map "$dir"
    while read -r created n; do
      [[ -n "${n:-}" ]] || continue
      (($(attempts_live "$dir" "$n") < RUNNER_MAX_ATTEMPTS)) || continue
      [[ -z "$(f_linked_pr "$dir" "$n" || true)" ]] || continue
      printf 'eligible: %s#%s (since %s)\n' "$dir" "$n" "$created"; exit 0
    done < <(f_ready_issues "$dir" "$LABEL_READY" | sort)
  done
  echo 'nothing eligible'; exit 1
}

cmd_status() {
  load_config
  printf 'config: %s\nagent:  %s\nmodel:  %s\nlast:   %s .. %s\n' "$RUNNER_CONFIG_PATH" \
    "${RUNNER_AGENT_CMD:-unset}" "${RUNNER_MODEL:-unset}" \
    "$(cat "$(state last-start)" 2>/dev/null || echo never)" "$(cat "$(state last-finish)" 2>/dev/null || echo never)"
  [[ -f "$(state runs.jsonl)" ]] && tail -n "${1:-10}" "$(state runs.jsonl)" |
    jq -r '"\(.ts)  \(.repo)#\(.issue)  \(.outcome)  \(.pr)  \(.detail)"'
  return 0
}

cmd_reset() {
  load_config; require_config
  local key="${1:?usage: reset <repo-dir>#<n>}"; local dir="${key%%#*}" n="${key##*#}"
  resolve_repo "$dir"
  [[ "$FORGE" == gh ]] && f_attempt_reset "$dir" "$n"
  set_attempts "$key" clear
}

# ---------- setup: detect, ask, persist ----------

AGENTS="opencode pi omp codex claude grok gemini cursor-agent aider goose amp droid kimi qwen crush"

# Offered only where the CLI documents a non-interactive mode; verify with '<agent> --help'.
# omp preset, flags read from `omp --help` on the host (issue #78): -p/--print
# for non-interactive runs, --max-time for the session timeout, --mode for
# structured output, --auto-approve / --approval-mode to skip TUI approval.
preset_cmd() {
  case "$1" in
    omp) printf '%s' 'omp -p --max-time "$RUNNER_TIMEOUT_MIN"m --mode text --auto-approve --model "$RUNNER_MODEL" "$RUNNER_PROMPT"' ;;
    opencode) printf '%s' 'opencode run --auto -m "$RUNNER_MODEL" "$RUNNER_PROMPT"' ;;
    codex) printf '%s' 'codex exec --full-auto -m "$RUNNER_MODEL" "$RUNNER_PROMPT"' ;;
    claude) printf '%s' 'claude -p --model "$RUNNER_MODEL" "$RUNNER_PROMPT"' ;;
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

cmd_pause() { mkdir -p "$RUNNER_STATE_DIR"; : >"$(state stop)"; log "paused: runs exit 0 as stopped until resume"; }

cmd_resume() { rm -f "$(state stop)"; log resumed; }

cmd_detect() {
  load_config
  printf 'config: %s (%s)\n' "$RUNNER_CONFIG_PATH" "$([[ -f "$RUNNER_CONFIG_PATH" ]] && echo exists || echo missing)"
  printf '\nagents on PATH:\n'; detect_agents | sed 's/^/  /'
  printf '\nmodels in harness configs:\n'; detect_models | sort -u | sed 's/^/  /'
  printf '\nprovider env vars (names only):\n'; detect_env_keys | sed 's/^/  /'
  local dir
  for dir in ${RUNNER_REPOS:-}; do
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
    agent_cmd="$(choose 'Agent command (it sees $RUNNER_MODEL, $RUNNER_PROMPT, $RUNNER_PROMPT_FILE):' "${opts[@]}")"
    [[ "$agent_cmd" != *"<type the full"* ]] || agent_cmd="$(ask 'full command' "")"
  fi
  if [[ -z "$model" ]]; then
    ((tty)) || die "setup needs a terminal to ask, or --model"
    printf '\nprovider env vars set: %s\n' "$(detect_env_keys | tr '\n' ' ')" >&2
    local models=(); mapfile -t models < <(detect_models | sort -u)
    model="$(choose 'Model for every run:' "${models[@]}")"
  fi
  if ((tty)); then
    [[ -n "$repos" ]] || repos="$(ask 'local clones to work on (space separated paths)' "${RUNNER_REPOS:-}")"
    [[ -n "$allow" ]] || allow="$(ask 'model allowlist (space separated, empty for none)' "${RUNNER_MODEL_ALLOWLIST:-}")"
    [[ -n "$maxi" ]] || maxi="$(ask 'issues per run' "$RUNNER_MAX_ISSUES")"
  fi
  [[ -n "$agent_cmd" && -n "$model" ]] || die "agent command and model are required"
  repos="${repos:-${RUNNER_REPOS:-}}"; [[ -n "$repos" ]] || die "no repos given"
  local abs=()
  for dir in $repos; do
    dir="$(cd "${dir/#\~/$HOME}" 2>/dev/null && pwd)" || die "not a directory: $dir"
    git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || die "not a git clone: $dir"
    abs+=("$dir")
  done
  mkdir -p "$(dirname "$RUNNER_CONFIG_PATH")"
  {
    printf '# Written by "runner.sh setup" on %s. Re-run setup to change.\n' "$(date -Is)"
    printf 'RUNNER_AGENT_CMD=%q\nRUNNER_MODEL=%q\nRUNNER_MODEL_ALLOWLIST=%q\n' "$agent_cmd" "$model" "$allow"
    printf 'RUNNER_REPOS=%q\nRUNNER_MAX_ISSUES=%q\n' "${abs[*]}" "${maxi:-$RUNNER_MAX_ISSUES}"
  } >"$RUNNER_CONFIG_PATH"
  unset RUNNER_AGENT_CMD RUNNER_MODEL RUNNER_MODEL_ALLOWLIST RUNNER_REPOS RUNNER_MAX_ISSUES
  load_config; require_config
  echo "saved $RUNNER_CONFIG_PATH"
  cmd_detect | sed -n '/^\//,$p'
}

case "${1:-}" in
  setup) shift; cmd_setup "$@" ;;
  detect) cmd_detect ;;
  check) cmd_check ;;
  run) cmd_run ;;
  pause) load_config; cmd_pause ;;
  resume) load_config; cmd_resume ;;
  status) shift; cmd_status "${1:-10}" ;;
  reset) shift; cmd_reset "${1:-}" ;;
  *) echo 'usage: runner.sh setup [flags] | detect | check | run | pause | resume | status [N] | reset <repo-dir>#<n>' >&2; exit 2 ;;
esac
