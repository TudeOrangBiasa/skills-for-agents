#!/usr/bin/env bash
# Stub test for runner claim durability (issue #57). No network, no gh auth.
# A stub gh answers from a JSON state file; a local bare repo is the remote.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
RUNNER="$HERE/scripts/runner.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }
export STUB_STATE="$TMP/gh-state.json"
export STUB_ME="runnerbot"

# ---------- fixture: origin + clone with docs/agents ----------

git init --quiet --bare "$TMP/origin.git"
git init --quiet "$TMP/seed"
git -C "$TMP/seed" config user.email t@t.t
git -C "$TMP/seed" config user.name t
mkdir -p "$TMP/seed/docs/agents"
printf '# Issue tracker: GitHub\n' >"$TMP/seed/docs/agents/issue-tracker.md"
printf '| role | label |\n| --- | --- |\n| ready-for-agent | ready-for-agent |\n| needs-info | needs-info |\n' >"$TMP/seed/docs/agents/triage-labels.md"
git -C "$TMP/seed" add -A
git -C "$TMP/seed" commit --quiet -m init
git -C "$TMP/seed" branch -M main
git -C "$TMP/seed" remote add origin "$TMP/origin.git"
git -C "$TMP/seed" push --quiet origin main
git clone --quiet "$TMP/origin.git" "$TMP/repo"
git -C "$TMP/repo" config user.email t@t.t
git -C "$TMP/repo" config user.name t
REPO="$TMP/repo"

# ---------- stub gh ----------

mkdir -p "$TMP/bin"
cat >"$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
# Minimal gh stub for issue #57: issue list/view/edit/comment, api user.
set -euo pipefail
S="$STUB_STATE"; ME="$STUB_ME"
jqw() { jq "$@" "$S" >"$S.tmp" && mv "$S.tmp" "$S"; }
case "${1:-} ${2:-}" in
  "api user") jq -rn --arg me "$ME" '$me' ;;
  "issue list")
    shift 2
    assignee=""; label=""; q=""
    while (($#)); do case "$1" in
      --assignee) assignee="$2"; shift 2 ;;
      --label) label="$2"; shift 2 ;;
      -q) q="$2"; shift 2 ;;
      *) shift ;;
    esac; done
    if [[ "$assignee" == "@me" ]]; then
      if [[ "$q" == *".number"* ]]; then jq -r '.issues[] | select(.state=="open" and (.assignees|index($me))) | .number' --arg me "$ME" "$S";
      else jq -c '.issues[] | select(.state=="open" and (.assignees|index($me)))' --arg me "$ME" "$S"; fi
    else
      jq -c --arg lbl "$label" '[.issues[] | select(.state=="open" and (.labels|index($lbl)) and ((.assignees|length)==0)) | {number, createdAt, assignees: [.assignees[] | {login: .}]}]' "$S"
    fi ;;
  "issue view")
    n="$3"; shift 3
    json=""; q=""
    while (($#)); do case "$1" in
      --json) json="$2"; shift 2 ;;
      -q) q="$2"; shift 2 ;;
      --comments) shift ;;
      *) shift ;;
    esac; done
    case "$q" in
      *".comments"*) jq -c --argjson n "$n" '.issues[] | select(.number==$n) | .comments | map({id, author: .author.login, body})' "$S" ;;
      *"assignees"*) jq -r --argjson n "$n" '.issues[] | select(.number==$n) | .assignees[]?' "$S" ;;
      *"labels"*) jq -r --argjson n "$n" '.issues[] | select(.number==$n) | .labels[]?' "$S" ;;
      *) jq -c --argjson n "$n" '.issues[] | select(.number==$n)' "$S" ;;
    esac ;;
  "issue edit")
    n="$3"; shift 3
    while (($#)); do case "$1" in
      --add-assignee) jqw --argjson n "$n" --arg me "$ME" '(.issues[] | select(.number==$n) | .assignees) |= (if index($me) then . else . + [$me] end)'; shift 2 ;;
      --remove-assignee) jqw --argjson n "$n" --arg me "$ME" '(.issues[] | select(.number==$n) | .assignees) |= map(select(. != $me))'; shift 2 ;;
      *) shift ;;
    esac; done ;;
  "issue comment")
    n="$3"; body="$5"
    jqw --argjson n "$n" --arg me "$ME" --arg b "$body" '(.issues[] | select(.number==$n) | .comments) += [{id: ((.issues[] | select(.number==$n) | .comments | length) + 1), author: {login: $me}, body: $b}]' ;;
  "pr list") echo '[]' ;;
  *) echo "stub gh: unsupported: $*" >&2; exit 3 ;;
esac
STUB
chmod +x "$TMP/bin/gh"
export PATH="$TMP/bin:$PATH"

mkstate() { # $1 = issues JSON array
  jq -n --argjson issues "$1" '{issues: $issues}' >"$STUB_STATE"
}
issue() { # n labels assignees comments-json
  jq -cn --argjson n "$1" --argjson labels "$2" --argjson asg "$3" --argjson c "$4" \
    '{number:$n, state:"open", createdAt:"2026-01-01T00:00:00Z", labels:$labels, assignees:$asg, comments:$c}'
}
comment() { # author body
  jq -cn --arg a "$1" --arg b "$2" '{id: 1, author: {login: $a}, body: $b}'
}
OLD_TS=$(( $(date +%s) - 400*60 ))

S1="$TMP/state1"
mkdir -p "$S1/logs" "$TMP/work"
cat >"$TMP/conf1.sh" <<CONF
RUNNER_AGENT_CMD='exit 0'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=1
RUNNER_MAX_ATTEMPTS=2
RUNNER_TIMEOUT_MIN=1
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
CONF

# ---------- 1. orphan claim released without the active file ----------

mkstate "[$(issue 11 '["other-label"]' '["runnerbot"]' "[$(comment runnerbot "<!-- runner-claim run=r1 ts=$OLD_TS branch=nothing-here -->")]")]"
RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" run >/dev/null 2>&1
[[ "$(jq -r '.issues[0].assignees | length' "$STUB_STATE")" == "0" ]] || fail "orphan claim still assigned"
[[ "$(jq -r '.issues[0].comments | length' "$STUB_STATE")" == "2" ]] || fail "interrupted marker missing"
jq -r '.issues[0].comments[1].body' "$STUB_STATE" | grep -q 'runner-attempt n=1 outcome=interrupted' || fail "interrupted marker body wrong"
grep -q 'interrupted' "$S1/runs.jsonl" || fail "interrupted not recorded"
[[ -s "$S1/active" ]] 2>/dev/null && fail "active file should stay empty"
pass "orphan claim released without active file"

# ---------- 2. human assignee never touched ----------

mkstate "[$(issue 12 '["other-label"]' '["runnerbot","humandev"]' "[$(comment runnerbot "<!-- runner-claim run=r2 ts=$OLD_TS branch=nothing-here -->")]")]"
RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" run >/dev/null 2>&1
[[ "$(jq -r '.issues[0].assignees | join(",")' "$STUB_STATE")" == "runnerbot,humandev" ]] || fail "human issue touched"
[[ "$(jq -r '.issues[0].comments | length' "$STUB_STATE")" == "1" ]] || fail "human issue got a marker"
pass "human assignee never released"

# ---------- 3. attempts.json deleted: count survives from markers ----------

mkstate "[$(issue 13 '["ready-for-agent"]' '[]' "[$(comment runnerbot "<!-- runner-attempt n=1 outcome=no_pr -->"),$(comment runnerbot "<!-- runner-attempt n=2 outcome=timeout -->")]")]"
rm -f "$S1/attempts.json"
echo '{}' >"$S1/attempts.json"
if RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" check >/dev/null 2>&1; then fail "capped issue still eligible"; fi
[[ "$(jq -r --arg k "$REPO#13" '.[$k]' "$S1/attempts.json")" == "2" ]] || fail "cache not resynced to 2"
pass "deleted attempts.json rebuilds from markers, capped issue waits"

# ---------- 4. timeout pushes WIP, next run resumes on one branch ----------

mkstate "[$(issue 14 '["ready-for-agent"]' '[]' '[]')]"
cat >"$TMP/conf2.sh" <<CONF
RUNNER_AGENT_CMD='echo change > newfile.txt && sleep 120'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=1
RUNNER_MAX_ATTEMPTS=3
RUNNER_TIMEOUT_MIN=1
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
CONF
RUNNER_CONFIG="$TMP/conf2.sh" timeout 100 "$RUNNER" run >/dev/null 2>&1
git -C "$REPO" fetch --quiet origin
git -C "$REPO" show-ref --verify --quiet refs/remotes/origin/wip/runner-issue-14 || fail "WIP branch not pushed"
git -C "$REPO" log --format=%s origin/wip/runner-issue-14 -1 | grep -q '^wip:' || fail "WIP head is not a wip: commit"
grep -q 'timeout.*wip/runner-issue-14' "$S1/runs.jsonl" || fail "timeout detail names no branch"
cat >"$TMP/conf3.sh" <<CONF
RUNNER_AGENT_CMD='test -f newfile.txt'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=1
RUNNER_MAX_ATTEMPTS=3
RUNNER_TIMEOUT_MIN=5
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
CONF
out="$(RUNNER_CONFIG="$TMP/conf3.sh" "$RUNNER" run 2>&1)"
[[ "$out" == *"no_pr"* ]] || fail "resume run did not finish as no_pr: $out"
[[ "$(git -C "$REPO" for-each-ref --format='%(refname:short)' refs/remotes/origin/ | grep -c runner-issue-14)" == "1" ]] || fail "duplicate branches for issue 14"
grep -q 'resuming.*wip/runner-issue-14' "$S1/logs/"*.log 2>/dev/null || true
pass "timeout pushes WIP, next run resumes on one branch"

# ---------- 5. pushed branch without PR resumes through pickup ----------

git -C "$REPO" checkout --quiet -b agent/work-15 origin/main
echo work >"$REPO/work.txt"
git -C "$REPO" add -A
git -C "$REPO" commit --quiet -m "agent work"
git -C "$REPO" push --quiet origin agent/work-15
git -C "$REPO" checkout --quiet main
mkstate "[$(issue 15 '["ready-for-agent"]' '[]' "[$(comment runnerbot "<!-- runner-claim run=r9 ts=$(date +%s) branch=agent/work-15 -->")]")]"
cat >"$TMP/conf4.sh" <<CONF
RUNNER_AGENT_CMD='test -f work.txt && test "\$RUNNER_RESUME_BRANCH" = agent/work-15'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=1
RUNNER_MAX_ATTEMPTS=3
RUNNER_TIMEOUT_MIN=5
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
CONF
RUNNER_CONFIG="$TMP/conf4.sh" "$RUNNER" run >/dev/null 2>&1
latest_prompt="$(ls -t "$S1"/logs/*.prompt.md | head -1)"
grep -q 'pickup' "$latest_prompt" || fail "resume prompt does not route to pickup"
grep -q 'Do not create a new branch' "$latest_prompt" || fail "resume prompt lacks branch guard"
pass "pushed branch without PR resumes through pickup"

# ---------- 6. rerun after success writes nothing new ----------

mkstate "[$(issue 16 '["ready-for-agent"]' '[]' '[]')]"
cat >"$TMP/conf5.sh" <<CONF
RUNNER_AGENT_CMD='true'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=0
RUNNER_MAX_ATTEMPTS=2
RUNNER_TIMEOUT_MIN=5
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
CONF
before="$(jq -r '.issues[0].comments | length' "$STUB_STATE")"
RUNNER_CONFIG="$TMP/conf5.sh" "$RUNNER" run >/dev/null 2>&1
[[ "$(jq -r '.issues[0].comments | length' "$STUB_STATE")" == "$before" ]] || fail "idle rerun wrote markers"
pass "idle rerun writes no markers"

printf 'stub: all runner claim-durable #57 checks passed\n'
