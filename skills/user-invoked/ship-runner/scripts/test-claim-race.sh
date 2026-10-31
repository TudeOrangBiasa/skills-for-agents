#!/usr/bin/env bash
# Stub test for runner claim check-after-write (issue #194). No network, no gh auth.
# A stub gh answers from a JSON state file; a local bare repo is the remote.
# Two simulated racers claim one fixture issue; exactly one proceeds.
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
# Minimal gh stub for issue #194: issue list/view/edit/comment, api user.
# STUB_RACE=1 makes the first --add-assignee also inject a rival claim
# (rival assignee plus an earlier rival marker), so the re-read sees a race.
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
      --add-assignee)
        jqw --argjson n "$n" --arg me "$ME" '(.issues[] | select(.number==$n) | .assignees) |= (if index($me) then . else . + [$me] end)'
        if [[ "${STUB_RACE:-0}" == "1" && ! -f "$TMP/race-armed" ]]; then
          : >"$TMP/race-armed"
          earlier=$(( $(date +%s) - 30 ))
          jqw --argjson n "$n" --argjson ts "$earlier" \
            '(.issues[] | select(.number==$n) | .assignees) |= (if index("rivalbot") then . else . + ["rivalbot"] end) |
             (.issues[] | select(.number==$n) | .comments) += [{id: 900, author: {login: "rivalbot"}, body: ("<!-- runner-claim run=rival-1 ts=" + ($ts|tostring) + " branch=wip/runner-issue-21 -->\nrunner: claimed for run rival-1")}]'
        fi
        shift 2 ;;
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
export TMP

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

S1="$TMP/state1"
mkdir -p "$S1/logs" "$TMP/work"
cat >"$TMP/conf1.sh" <<CONF
RUNNER_AGENT_CMD='exit 0'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_STATE_DIR='$S1'
RUNNER_WORK_DIR='$TMP/work'
RUNNER_TIMEOUT_MIN=1
CONF

# ---------- 1. rival wins the race: exactly one proceeds ----------

rm -f "$TMP/race-armed"
mkstate "[$(issue 21 '["ready-for-agent"]' '[]' '[]')]"
export STUB_RACE=1
out="$(RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" run 2>&1)"
unset STUB_RACE
[[ "$out" == *"claim_lost"* ]] || fail "loser did not back off with claim_lost: $out"
[[ "$(jq -r '.issues[0].assignees | join(",")' "$STUB_STATE")" == "rivalbot" ]] || fail "loser left its own assign behind: $(jq -c '.issues[0].assignees' "$STUB_STATE")"
grep -q 'claim_lost' "$S1/runs.jsonl" || fail "claim_lost not recorded"
[[ "$(jq -r '[.issues[0].comments[] | select(.author.login=="runnerbot") | select(.body | contains("runner-claim"))] | length' "$STUB_STATE")" == "1" ]] || fail "expected one own marker comment, state: $(jq -c '.issues[0].comments' "$STUB_STATE")"
pass "lost race backs off: rival keeps the claim, this runner unassigns and skips"

# ---------- 2. no rival: sole claimant proceeds ----------

rm -f "$TMP/race-armed"
mkstate "[$(issue 22 '["ready-for-agent"]' '[]' '[]')]"
out="$(RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" run 2>&1)"
[[ "$out" != *"claim_lost"* ]] || fail "sole claimant wrongly backed off: $out"
[[ "$(jq -r '.issues[0].assignees | length' "$STUB_STATE")" == "0" ]] || fail "sole claim not released after work"
grep -q '"issue":"22"' "$S1/runs.jsonl" || fail "issue 22 run not recorded"
pass "sole claimant proceeds and releases normally"

# ---------- 3. I am earliest: later rival marker does not stop me ----------

rm -f "$TMP/race-armed"
LATER=$(( $(date +%s) + 300 ))
mkstate "[$(issue 23 '["ready-for-agent"]' '["rivalbot"]' "[$(comment rivalbot "<!-- runner-claim run=rival-9 ts=$LATER branch=wip/runner-issue-23 -->")]")]"
out="$(RUNNER_CONFIG="$TMP/conf1.sh" "$RUNNER" run 2>&1)"
[[ "$out" == *"nothing eligible"* ]] || fail "already-assigned issue should not be picked: $out"
pass "listing still skips an assigned issue before any claim write"

printf 'stub: all runner claim-race #194 checks passed\n'
