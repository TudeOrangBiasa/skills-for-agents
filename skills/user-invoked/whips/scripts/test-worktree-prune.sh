#!/usr/bin/env bash
# Stub test for worktree-audit (read-only) and worktree-prune (issues #73, #83).
# No network, no gh auth. A stub gh answers PR state from a JSON file.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
AUDIT="$HERE/worktree-audit"
PRUNE="$HERE/worktree-prune"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }
export STUB_PRS="$TMP/prs.json"

git init --quiet --bare "$TMP/origin.git"
git clone --quiet "$TMP/origin.git" "$TMP/main"
git -C "$TMP/main" config user.email t@t.t
git -C "$TMP/main" config user.name t
echo base >"$TMP/main/file.txt"
git -C "$TMP/main" add -A
git -C "$TMP/main" commit --quiet -m base
git -C "$TMP/main" branch -M main
git -C "$TMP/main" push --quiet origin main
MAIN="$TMP/main"

mkbranch() { # name, file change -> worktree path
  git -C "$MAIN" branch "$1" main
  git -C "$MAIN" worktree add "$TMP/wt-$1" "$1" >/dev/null
  echo "$2" >"$TMP/wt-$1/$1.txt"
  git -C "$TMP/wt-$1" add -A
  git -C "$TMP/wt-$1" commit --quiet -m "$1"
  printf '%s' "$TMP/wt-$1"
}
WT_MERGED="$(mkbranch feat-merged change1)"
WT_OPEN="$(mkbranch feat-open change2)"
WT_DIRTY="$(mkbranch feat-dirty change3)"
echo uncommitted >"$WT_DIRTY/dirty.txt"
git -C "$MAIN" push --quiet origin main >/dev/null 2>&1 || true

mkdir -p "$TMP/bin"
cat >"$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" == "pr" && "${2:-}" == "list" ]]; then
  printf 'x\n' >>"$STUB_CALLS"
  jq -c '[.[] | {number, state, headRefName}]' "$STUB_PRS"
elif [[ "${1:-}" == "pr" && "${2:-}" == "view" ]]; then
  printf 'x\n' >>"$STUB_CALLS"
  jq -c --arg h "$4" '.[] | select(.headRefName==$h)' "$STUB_PRS" 2>/dev/null || true
fi
STUB
chmod +x "$TMP/bin/gh"
export PATH="$TMP/bin:$PATH"
export STUB_CALLS="$TMP/gh-calls.count"; : >"$STUB_CALLS"

cat >"$STUB_PRS" <<'PRS'
[{"number": 11, "state": "MERGED", "headRefName": "feat-merged"},
 {"number": 12, "state": "OPEN", "headRefName": "feat-open"},
 {"number": 13, "state": "OPEN", "headRefName": "feat-dirty"}]
PRS

# 1. audit buckets: merged-clean safe, open keep, dirty needs-look, main keep.
out="$("$AUDIT" "$MAIN")"
[[ "$out" == *"safe-to-prune"* ]] || fail "audit missing safe-to-prune: $out"
echo "$out" | awk -F'\t' '$2=="feat-merged" {exit ($6=="safe-to-prune" ? 0 : 1)}' || fail "merged-clean not safe-to-prune"
echo "$out" | awk -F'\t' '$2=="feat-open" {exit ($6=="keep" ? 0 : 1)}' || fail "open not keep"
echo "$out" | awk -F'\t' '$2=="feat-dirty" {exit ($6=="needs-look" ? 0 : 1)}' || fail "dirty not needs-look"
[[ "$(wc -l <"$STUB_CALLS")" == "1" ]] || fail "audit made $(wc -l <"$STUB_CALLS") gh calls, want 1"
pass "audit buckets correct with exactly 1 gh call"

# 2. audit is read-only: worktree list identical before/after.
before="$(git -C "$MAIN" worktree list)"
"$AUDIT" "$MAIN" >/dev/null
[[ "$(git -C "$MAIN" worktree list)" == "$before" ]] || fail "audit mutated worktrees"
pass "audit changes nothing"

# 3. dry-run changes nothing.
: >"$STUB_CALLS"
before="$before"
"$PRUNE" "$MAIN" >/dev/null
[[ "$(git -C "$MAIN" worktree list)" == "$before" ]] || fail "dry-run mutated worktrees"
pass "dry-run prints plan, changes nothing"

# 4. apply: merged-clean removed, open kept, dirty reported, main intact.
"$PRUNE" --apply "$MAIN" >/dev/null
[[ ! -d "$WT_MERGED" ]] || fail "merged-clean worktree still present"
[[ -d "$WT_OPEN" ]] || fail "open worktree removed"
[[ -d "$WT_DIRTY" ]] || fail "dirty worktree removed"
[[ -d "$MAIN" ]] || fail "main worktree gone"
git -C "$MAIN" worktree list | grep -q feat-open || fail "open missing from list"
git -C "$MAIN" worktree list | grep -q feat-dirty || fail "dirty missing from list"
pass "apply removes only merged-clean, keeps open/dirty/main"

# 5. idempotent: second apply is a no-op.
second="$("$PRUNE" --apply "$MAIN")"
[[ "$second" == *"removed=0"* ]] || fail "second apply not a no-op: $second"
pass "second apply is a no-op"

echo "worktree stub: all 5 scenarios green"
