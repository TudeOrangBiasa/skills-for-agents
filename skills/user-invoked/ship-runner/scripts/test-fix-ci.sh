#!/usr/bin/env bash
# Stub test for runner fix-ci (issue #56). No network, no gh auth.
# A stub gh answers from a JSON state file; a local bare repo is the remote.
# Covers: dry-run with skip reasons, conflict detection, lock exclusion,
# kill -9 claim durability, the 3-fail cap with no 4th spawn, push outcome
# with a single marker, rerun no-op, the stop file, and the force probe.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
RUNNER="$HERE/scripts/runner.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }
export STUB_STATE="$TMP/gh-state.json"
export STUB_ME="runnerbot"
export STUB_PR_STATUS_BIN=""

# ---------- fixture: origin + clone with docs/agents (team mode) ----------

git init --quiet --bare "$TMP/origin.git"
git init --quiet "$TMP/seed"
git -C "$TMP/seed" config user.email t@t.t
git -C "$TMP/seed" config user.name t
mkdir -p "$TMP/seed/docs/agents"
printf '# Issue tracker: GitHub\n' >"$TMP/seed/docs/agents/issue-tracker.md"
printf '| role | label |\n| --- | --- |\n| ready-for-agent | ready-for-agent |\n| needs-info | needs-info |\n' >"$TMP/seed/docs/agents/triage-labels.md"
printf '# Repo mode\n\n- **Mode:** `team`\n' >"$TMP/seed/docs/agents/repo-mode.md"
git -C "$TMP/seed" add -A
git -C "$TMP/seed" commit --quiet -m init
git -C "$TMP/seed" branch -M main
git -C "$TMP/seed" remote add origin "$TMP/origin.git"
git -C "$TMP/seed" push --quiet origin main
git clone --quiet "$TMP/origin.git" "$TMP/repo"
git -C "$TMP/repo" config user.email t@t.t
git -C "$TMP/repo" config user.name t
REPO="$TMP/repo"
mkbranch() { # name -> pushes a branch with one commit
  git -C "$REPO" checkout --quiet -b "$1" origin/main
  echo "$1" >"$REPO/$1.txt"
  git -C "$REPO" add -A
  git -C "$REPO" commit --quiet -m "$1"
  git -C "$REPO" push --quiet origin "$1"
  git -C "$REPO" checkout --quiet main
}
mkbranch feat-red
mkbranch feat-conflict
mkbranch feat-ship
HEAD_RED="$(git -C "$REPO" rev-parse origin/feat-red)"
HEAD_CONFLICT="$(git -C "$REPO" rev-parse origin/feat-conflict)"
HEAD_SHIP="$(git -C "$REPO" rev-parse origin/feat-ship)"

# ---------- stub gh ----------

mkdir -p "$TMP/bin"
cat >"$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
# Minimal gh stub for issue #56: pr list/view/edit/comment/merge, api user,
# repo view, events, issue-comment PATCH. Answers from $STUB_STATE.
set -euo pipefail
S="$STUB_STATE"; ME="$STUB_ME"
jqw() { jq "$@" "$S" >"$S.tmp" && mv "$S.tmp" "$S"; }
case "${1:-} ${2:-}" in
  "api user") jq -rn --arg me "$ME" '$me' ;;
  "repo view") jq -rn '"stubowner\nstubname"' ;;
  "pr list")
    jq -c '[.prs[] | select(.state=="open") | {number, headRefName, headRefOid,
      isCrossRepository, author: {login: .author}, labels: [.labels[] | {name: .}],
      mergeable}]' "$S" ;;
  "pr view")
    n="$3"; shift 3
    q=""
    while (($#)); do case "$1" in
      -q) q="$2"; shift 2 ;;
      --comments) shift ;;
      --json) shift 2 ;;
      *) shift ;;
    esac; done
    if [[ "$q" == *".comments"* ]]; then
      jq -c --argjson n "$n" '.prs[] | select(.number==$n) | .comments | map({id, body})' "$S"
    elif [[ "$q" == ".labels" ]]; then
      jq -c --argjson n "$n" '.prs[] | select(.number==$n) | [.labels[] | {name: .}]' "$S"
    else
      jq -c --argjson n "$n" '.prs[] | select(.number==$n)' "$S"
    fi ;;
  "pr edit")
    n="$3"; shift 3
    adds=""; rms=""
    while (($#)); do case "$1" in
      --add-label) adds="$adds $2"; shift 2 ;;
      --remove-label) rms="$rms $2"; shift 2 ;;
      *) shift ;;
    esac; done
    jqw --argjson n "$n" --arg adds "$adds" --arg rms "$rms" '
      .prs |= map(if .number==$n then
        .labels |= ((. + ($adds | split(" ") | map(select(. != "")))) | unique
          | map(select((. as $l | $rms | split(" ") | index($l) | not))))
      else . end)' ;;
  "pr comment")
    n="$3"; body="$5"
    jqw --argjson n "$n" --arg me "$ME" --arg b "$body" '
      .prs |= map(if .number==$n then
        .comments += [{id: ((.comments | length) + 1), author: {login: $me}, body: $b}]
      else . end)' ;;
  "pr merge")
    n="$3"
    jqw --argjson n "$n" '.prs |= map(if .number==$n then .autoMergeOff = true else . end)' ;;
  "api repos/"*)
    url="${2:-}"; rest=("${@:3}"); q=""; body=""
    i=0
    while ((i < ${#rest[@]})); do case "${rest[$i]}" in
      -q) q="${rest[$((i+1))]}"; i=$((i+2)) ;;
      -f) body="${rest[$((i+1))]#body=}"; i=$((i+2)) ;;
      *) i=$((i+1)) ;;
    esac; done
    if [[ "$url" == *"/events"* ]]; then
      n="$(sed -nE 's#.*/issues/([0-9]+)/events.*#\1#p' <<<"$url")"
      raw="$(jq -c --argjson n "$n" '[.prs[] | select(.number==$n) | .events[]?]' "$S")"
      if [[ -n "$q" ]]; then jq -r "$q" <<<"$raw"; else printf '%s\n' "$raw"; fi
    elif [[ "$url" == *"/issues/comments/"* ]]; then
      id="${url##*/}"
      jqw --argjson id "$id" --arg b "$body" '
        .prs |= map(.comments |= map(if .id==$id then .body = $b else . end))'
    else
      echo "stub gh: unsupported api: $url" >&2; exit 3
    fi ;;
  "pr status") "$STUB_PR_STATUS_BIN" "$3" ;;
  *) echo "stub gh: unsupported: $*" >&2; exit 3 ;;
esac
STUB
chmod +x "$TMP/bin/gh"
export PATH="$TMP/bin:$PATH"

# ---------- stub pr-status: classify from state, same JSON shape ----------

cat >"$TMP/bin/pr-status" <<'STUB'
#!/usr/bin/env bash
# Minimal pr-status stub: state from $STUB_STATE, JSON shape of the real one.
set -euo pipefail
S="$STUB_STATE"; n="$1"
jq -c --argjson n "$n" '.prs[] | select(.number==$n) |
  {number, state: .wantState, mergeable, labels: [.labels[]],
   failedRuns: (if .wantState == "red" then ["ci"] else [] end)}' "$S"
STUB
chmod +x "$TMP/bin/pr-status"
export STUB_PR_STATUS_BIN="$TMP/bin/pr-status"

mkstate() { # $1 = prs JSON array
  jq -n --argjson prs "$1" '{prs: $prs}' >"$STUB_STATE"
}
pr() { # n branch head author cross labels-json wantState mergeable events-json comments-json
  jq -cn --argjson n "$1" --arg b "$2" --arg h "$3" --arg a "$4" --argjson x "$5" \
    --argjson l "$6" --arg w "$7" --arg m "$8" --argjson e "$9" --argjson c "${10}" \
    '{number:$n, state:"open", headRefName:$b, headRefOid:$h, author:$a,
      isCrossRepository:$x, labels:$l, wantState:$w, mergeable:$m, events:$e, comments:$c}'
}
labeled_event() { # created_at
  jq -cn --arg c "$1" '{event:"labeled", label:{name:"agent:fixing"}, created_at:$c}'
}
OLD_TS="$(date -u -d '8 hours ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-8H +%Y-%m-%dT%H:%M:%SZ)"
FRESH_TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkconf() { # name agent-cmd -> config path
  local f="$TMP/conf-$1.sh"
  cat >"$f" <<CONF
RUNNER_AGENT_CMD='$2'
RUNNER_MODEL='stub/model'
RUNNER_REPOS='$REPO'
RUNNER_MAX_ISSUES=0
RUNNER_MAX_ATTEMPTS=2
RUNNER_TIMEOUT_MIN=1
RUNNER_STATE_DIR='$TMP/state-$1'
RUNNER_WORK_DIR='$TMP/work-$1'
CONF
  mkdir -p "$TMP/state-$1/logs" "$TMP/work-$1"
  printf '%s' "$f"
}

# ---------- 1. dry-run lists eligible PRs plus every skip reason ----------

mkstate "[$(pr 21 feat-red "$HEAD_RED" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]'),$(pr 22 feat-conflict "$HEAD_CONFLICT" runnerbot false '[]' conflict CONFLICTING '[]' '[]'),$(pr 23 feat-red "$HEAD_RED" runnerbot true '["ci-failed"]' red MERGEABLE '[]' '[]'),$(pr 24 feat-red "$HEAD_RED" runnerbot false '["ci-failed","agent:fixing"]' red MERGEABLE "[$(labeled_event "$FRESH_TS")]" '[]'),$(pr 25 feat-red "$HEAD_RED" runnerbot false '["ci-failed","needs-human"]' red MERGEABLE '[]' '[]'),$(pr 26 feat-red "$HEAD_RED" humandev false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
C1="$(mkconf dry 'exit 3')"
out="$(RUNNER_CONFIG="$C1" "$RUNNER" fix-ci --dry-run 2>&1)"
[[ "$out" == *"would fix: repo#21 kind=ci"* ]] || fail "dry-run misses red PR 21: $out"
[[ "$out" == *"would fix: repo#22 kind=conflict"* ]] || fail "dry-run misses conflict PR 22: $out"
[[ "$out" == *"would skip: repo#23 (fork"* ]] || fail "dry-run misses fork skip: $out"
[[ "$out" == *"would skip: repo#24 (agent:fixing claim fresh"* ]] || fail "dry-run misses fresh claim skip: $out"
[[ "$out" == *"would skip: repo#25 (needs-human set)"* ]] || fail "dry-run misses needs-human skip: $out"
[[ "$out" == *"would skip: repo#26 (author @humandev not in scope)"* ]] || fail "dry-run misses author skip: $out"
[[ "$(jq '[.prs[] | .labels] | flatten | length' "$STUB_STATE")" == "7" ]] || fail "dry-run mutated labels"
[[ "$(jq '[.prs[] | .comments] | flatten | length' "$STUB_STATE")" == "0" ]] || fail "dry-run posted comments"
pass "dry-run lists eligible PRs plus fork, claim, needs-human, and author skips"

# ---------- 2. conflict without ci-failed is claimed ----------

C2="$(mkconf conflict 'exit 0')"
mkstate "[$(pr 31 feat-conflict "$HEAD_CONFLICT" runnerbot false '[]' conflict CONFLICTING '[]' '[]')]"
RUNNER_CONFIG="$C2" "$RUNNER" fix-ci >/dev/null 2>&1
[[ "$(jq -r '.prs[] | select(.number==31) | .labels | join(",")' "$STUB_STATE")" == "fix-attempt-1" ]] || fail "conflict PR not claimed with attempt 1: $(jq -c '.prs[0].labels' "$STUB_STATE")"
grep -q 'fix_nochange' "$TMP/state-conflict/runs.jsonl" || fail "conflict run left no row"
pass "conflict without ci-failed is claimed and attempted"

# ---------- 3. second pass exits at the lock, no double claim ----------

C3="$(mkconf lock 'sleep 20')"
mkstate "[$(pr 32 feat-red "$HEAD_RED" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
RUNNER_CONFIG="$C3" "$RUNNER" fix-ci >/dev/null 2>&1 &
first=$!
sleep 2
out2="$(RUNNER_CONFIG="$C3" "$RUNNER" fix-ci 2>&1)"
wait "$first"
[[ "$out2" == *"another run holds the lock"* ]] || fail "second pass did not report the lock: $out2"
[[ "$(jq -r '.prs[] | select(.number==32) | [.labels[] | select(startswith("fix-attempt-"))] | length' "$STUB_STATE")" == "1" ]] || fail "double claim under lock"
pass "second pass exits at the lock with no double claim"

# ---------- 4. kill -9 after claim: next pass releases, attempt kept ----------

C4="$(mkconf kill9 'sleep 60')"
mkstate "[$(pr 33 feat-red "$HEAD_RED" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
RUNNER_CONFIG="$C4" "$RUNNER" fix-ci >/dev/null 2>&1 &
victim=$!
sleep 2
kill -9 "$victim"
wait "$victim" 2>/dev/null || true
[[ "$(jq -r '.prs[] | select(.number==33) | .labels | join(",")' "$STUB_STATE")" == *"agent:fixing"* ]] || fail "kill -9 pass never claimed"
[[ "$(jq -r '.prs[] | select(.number==33) | .labels | join(",")' "$STUB_STATE")" == *"fix-attempt-1"* ]] || fail "kill -9 pass lost the attempt bump"
jq --arg ts "$OLD_TS" '(.prs[] | select(.number==33) | .events) += [{event:"labeled", label:{name:"agent:fixing"}, created_at:$ts}]' "$STUB_STATE" >"$STUB_STATE.tmp" && mv "$STUB_STATE.tmp" "$STUB_STATE"
C4b="$(mkconf kill9b 'exit 0')"
RUNNER_CONFIG="$C4b" "$RUNNER" fix-ci >/dev/null 2>&1
[[ "$(jq -r '.prs[] | select(.number==33) | .labels | join(",")' "$STUB_STATE")" == *"fix-attempt-2"* ]] || fail "repass did not bump to attempt 2: $(jq -c '.prs[0].labels' "$STUB_STATE")"
[[ "$(jq -r '.prs[] | select(.number==33) | .labels | join(",")' "$STUB_STATE")" != *"agent:fixing"* ]] || fail "stale claim not released"
jq -r '.prs[] | select(.number==33) | .comments[].body' "$STUB_STATE" | grep -q 'released stale agent:fixing claim' || fail "stale release comment missing"
pass "kill -9 keeps the attempt, next pass releases the stale claim"

# ---------- 5. three fails cap out with no fourth spawn ----------

rm -f "$TMP/spawns.count"
C5="$(mkconf cap "echo x >> $TMP/spawns.count; exit 1")"
mkstate "[$(pr 34 feat-red "$HEAD_RED" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
RUNNER_CONFIG="$C5" "$RUNNER" fix-ci >/dev/null 2>&1
RUNNER_CONFIG="$C5" "$RUNNER" fix-ci >/dev/null 2>&1
RUNNER_CONFIG="$C5" "$RUNNER" fix-ci >/dev/null 2>&1
[[ "$(wc -l <"$TMP/spawns.count")" == "3" ]] || fail "spawn count is not 3: $(cat "$TMP/spawns.count" 2>/dev/null)"
RUNNER_CONFIG="$C5" "$RUNNER" fix-ci >/dev/null 2>&1
[[ "$(wc -l <"$TMP/spawns.count")" == "3" ]] || fail "fourth spawn happened after the cap"
[[ "$(jq -r '.prs[] | select(.number==34) | .labels | join(",")' "$STUB_STATE")" == *"needs-human"* ]] || fail "capped PR lacks needs-human"
[[ "$(jq -r '.prs[] | select(.number==34) | .autoMergeOff // false' "$STUB_STATE")" == "true" ]] || fail "capped PR left auto-merge armed"
grep -q '"outcome":"capped"' "$TMP/state-cap/runs.jsonl" || fail "capped row missing"
pass "three fails cap out with needs-human plus disarm and no fourth spawn"

# ---------- 6. push means fix_pushed with one marker ----------

C6="$(mkconf push 'echo fix >> fix.txt && git add -A && git -c user.name=t -c user.email=t@t.t commit -qm fix && git push --quiet origin HEAD:feat-ship')"
mkstate "[$(pr 35 feat-ship "$HEAD_SHIP" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
RUNNER_CONFIG="$C6" "$RUNNER" fix-ci >/dev/null 2>&1
[[ "$(jq -r '.prs[] | select(.number==35) | .labels | join(",")' "$STUB_STATE")" != *"agent:fixing"* ]] || fail "claim label left on pushed PR"
grep -q '"outcome":"fix_pushed"' "$TMP/state-push/runs.jsonl" || fail "fix_pushed row missing"
[[ "$(jq -r '.prs[] | select(.number==35) | [.comments[] | select(.body | contains("<!-- runner-fix attempt=1 "))] | length' "$STUB_STATE")" == "1" ]] || fail "marker comment not exactly once"
pass "push records fix_pushed with the claim off and one marker"

# ---------- 7. rerun after success is a no-op ----------

jq '(.prs[] | select(.number==35) | .wantState) = "ready"' "$STUB_STATE" >"$STUB_STATE.tmp" && mv "$STUB_STATE.tmp" "$STUB_STATE"
before_comments="$(jq '[.prs[] | select(.number==35) | .comments | length] | add' "$STUB_STATE")"
before_rows="$(wc -l <"$TMP/state-push/runs.jsonl")"
out7="$(RUNNER_CONFIG="$C6" "$RUNNER" fix-ci 2>&1)"
[[ "$out7" == *"nothing eligible"* ]] || fail "rerun did not report idle: $out7"
[[ "$(jq '[.prs[] | select(.number==35) | .comments | length] | add' "$STUB_STATE")" == "$before_comments" ]] || fail "rerun posted comments"
[[ "$(wc -l <"$TMP/state-push/runs.jsonl")" == "$before_rows" ]] || fail "rerun appended rows"
pass "rerun after success changes nothing"

# ---------- 8. stop file halts the next pass without a spawn ----------

rm -f "$TMP/spawns8.count"
C8="$(mkconf stop "echo x >> $TMP/spawns8.count; exit 0")"
mkstate "[$(pr 36 feat-red "$HEAD_RED" runnerbot false '["ci-failed"]' red MERGEABLE '[]' '[]')]"
RUNNER_CONFIG="$C8" "$RUNNER" pause >/dev/null 2>&1
out8="$(RUNNER_CONFIG="$C8" "$RUNNER" fix-ci 2>&1)"
RUNNER_CONFIG="$C8" "$RUNNER" resume >/dev/null 2>&1
[[ "$out8" == *"stopped"* ]] || fail "stop file did not halt the pass: $out8"
[[ ! -f "$TMP/spawns8.count" ]] || fail "stop file pass spawned the agent"
pass "stop file halts the pass with no spawn"

# ---------- 9. no bare force push anywhere in the skill ----------

# The probe string is built at run time so this file stays out of its own scan.
force_probe="--for$(printf 'ce')$(printf '[%s]' '^')-]"
if grep -rn -- "$force_probe" "$HERE" >/dev/null 2>&1; then
  grep -rn -- "$force_probe" "$HERE" >&2 || true
  fail "bare force push found in the ship-runner skill"
fi
pass "no bare force push in the ship-runner skill"

printf 'stub: all runner fix-ci #56 checks passed\n'
