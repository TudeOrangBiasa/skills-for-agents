#!/usr/bin/env bash
# Stub test for incremental triage cursor (#195) and fingerprint dedupe
# (#196). No network, no forge calls: every fixture is a local JSON file.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TICK="$HERE/triage-tick.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

cat >"$TMP/issues.json" <<'STATE'
{"issues": [
  {"number": 1, "state": "open", "title": "Fix cart crash", "updatedAt": "2026-10-20T00:00:00Z"},
  {"number": 2, "state": "open", "title": "fix(skill): cart crash.", "updatedAt": "2026-10-28T00:00:00Z"},
  {"number": 3, "state": "open", "title": "  FIX   cart  crash  ", "updatedAt": "2026-10-29T00:00:00Z"},
  {"number": 4, "state": "open", "title": "Add dark mode toggle", "updatedAt": "2026-10-21T00:00:00Z"},
  {"number": 5, "state": "closed", "title": "Fix cart crash", "updatedAt": "2026-10-30T00:00:00Z"},
  {"number": 6, "state": "open", "title": "enhancement: cart crash!!", "updatedAt": "2026-10-30T00:00:00Z"}
]}
STATE

fp() { "$TICK" --fingerprint "$1"; }
a="$(fp 'Fix cart crash')"

# 1. Fingerprint: near-duplicates share one hash.
[[ "$(fp 'fix(skill): cart crash.')" == "$a" ]] || fail "punctuation/prefix variant differs"
[[ "$(fp '  FIX   cart  crash  ')" == "$a" ]] || fail "case/whitespace variant differs"
[[ "$(fp 'enhancement: cart crash!!')" == "$a" ]] || fail "type-prefix variant differs"
[[ "$(fp 'fix cart crash')" == "$a" ]] || fail "bare prefix variant differs"
pass "near-duplicates (case, punctuation, type prefix, whitespace) share one fingerprint"

# 2. Fingerprint: distinct titles never collide.
b="$(fp 'Add dark mode toggle')"
[[ "$b" != "$a" ]] || fail "distinct title collides"
pass "distinct titles are not flagged"

# 3. Type-prefix-only differences fingerprint equal.
[[ "$(fp 'feat: retry queue')" == "$(fp 'deprecate: retry queue')" ]] || fail "prefix-only difference differs"
pass "type-prefix-only differences are fingerprint-equal"

# 4. One-pass map over the working set: delta issues dedupe locally, no pairs, no LLM.
out="$(RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/missing-cursor" --dry-run)"
[[ "$out" == *"mode=full-scan reason=missing"* ]] || fail "missing cursor did not full-scan: $out"
[[ "$out" == *"decision=duplicate-of 2 survivor=1"* ]] || fail "one-pass map missed delta duplicate: $out"
pass "missing cursor gives full-scan rescan with one-pass dedupe"

# 5. Valid cursor: steady tick only considers issues updated since the cursor.
printf '2026-10-29T00:00:00Z\n' >"$TMP/cursor-valid"
out="$(RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/cursor-valid" --dry-run)"
[[ "$out" == *"mode=delta cursor=2026-10-29T00:00:00Z"* ]] || fail "valid cursor did not give delta mode: $out"
[[ "$out" == *"working-set=2"* ]] || fail "delta working set is not O(delta I): $out"
[[ "$out" != *"survivor=1"* ]] || fail "delta tick reached behind the cursor: $out"
pass "valid cursor restricts steady tick to O(delta I) (working-set=2)"

# 6. Corrupt cursor: full rescan fallback.
printf 'not-a-timestamp\n' >"$TMP/cursor-corrupt"
out="$(RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/cursor-corrupt" --dry-run)"
[[ "$out" == *"mode=full-scan reason=corrupt"* ]] || fail "corrupt cursor did not rescan: $out"
[[ "$out" == *"working-set=5"* ]] || fail "corrupt cursor missed an open issue: $out"
pass "corrupt cursor triggers full open-issue rescan"

# 7. Crash before write leaves the old cursor.
printf '2026-10-20T00:00:00Z\n' >"$TMP/cursor-crash"
if RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/cursor-crash" --fail-before-write >/dev/null 2>&1; then
  fail "simulated crash exited 0"
fi
[[ "$(cat "$TMP/cursor-crash")" == "2026-10-20T00:00:00Z" ]] || fail "crash moved the cursor"
pass "crash-before-write leaves the old cursor in place"

# 8. Successful tick advances the cursor exactly once, to the newest updatedAt.
printf '2026-10-20T00:00:00Z\n' >"$TMP/cursor-ok"
out="$(RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/cursor-ok")"
[[ "$out" == *"cursor=stored value=2026-10-30T00:00:00Z"* ]] || fail "cursor did not advance: $out"
[[ "$(cat "$TMP/cursor-ok")" == "2026-10-30T00:00:00Z" ]] || fail "cursor file mismatch"
printf '2026-10-30T00:00:00Z\n' >"$TMP/cursor-new"
out="$(RUNNER_STATE_DIR="$TMP/state" "$TICK" --issues "$TMP/issues.json" --cursor "$TMP/cursor-new")"
[[ "$out" == *"mode=delta"* && "$out" == *"working-set=1"* ]] || fail "repeated tick is not O(1) delta: $out"
pass "success writes the cursor once; the next tick is a one-issue delta"

# 9. Closed issues and stale cursor data never enter the working set.
[[ "$out" != *"decision=duplicate-of 5"* ]] || fail "closed issue entered the working set"
pass "closed issues stay out of the working set"

echo "triage cursor/fingerprint stub: all 9 scenarios green"
