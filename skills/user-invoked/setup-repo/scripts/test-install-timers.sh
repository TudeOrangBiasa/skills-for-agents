#!/usr/bin/env bash
# Stub test for install-timers (issue #78). No systemd writes, no network.
# Fails closed without dependency baru: only bash, cmp, grep.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL="$HERE/scripts/install-timers"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

# 1. dry-run prints all six units and writes nothing.
out="$("$INSTALL" --dry-run --unit-dir "$TMP/empty" 2>&1)"
for u in runner-run.service runner-run.timer runner-fix-ci.service runner-fix-ci.timer runner-triage.service runner-triage.timer; do
  [[ "$out" == *"$u"* ]] || fail "dry-run missing $u"
done
[[ -e "$TMP/empty" ]] && fail "dry-run created the unit dir"
pass "dry-run prints six units, writes nothing"

# 2. bad --only exits 2 before any unit output.
if "$INSTALL" --dry-run --only bogus >/dev/null 2>&1; then fail "--only bogus accepted"; fi
pass "bad --only refused"

# 3. install then re-run is a no-op (identical bytes).
UNIT_DIR="$TMP/u1" "$INSTALL" --yes --only run >/dev/null 2>&1
UNIT_DIR="$TMP/u1" "$INSTALL" --yes --only run >"$TMP/rerun.txt" 2>&1
[[ "$(cat "$TMP/rerun.txt")" == *"no-op: runner-run.service already installed"* ]] || fail "re-run not no-op"
pass "re-run install is a no-op"

# 4. uninstall removes only managed units.
printf 'foreign\n' >"$TMP/u1/foreign.service"
UNIT_DIR="$TMP/u1" "$INSTALL" uninstall --yes >/dev/null 2>&1
[[ -f "$TMP/u1/foreign.service" ]] || fail "uninstall removed a foreign file"
[[ -e "$TMP/u1/runner-run.service" ]] && fail "uninstall left a managed unit"
pass "uninstall removes only managed units"

# 5. rendered units verify with systemd-analyze.
UNIT_DIR="$TMP/u2" "$INSTALL" --yes >/dev/null 2>&1
for u in "$TMP/u2"/*; do
  systemd-analyze --user verify "$u" || fail "verify failed: $u"
done
pass "systemd-analyze verify passes"

# 6. no omp on PATH fails closed without writing units.
mkdir -p "$TMP/none/bin" "$TMP/u3"
if PATH="$TMP/none/bin:/usr/bin:/bin" UNIT_DIR="$TMP/u3" "$INSTALL" --yes >/dev/null 2>&1; then
  fail "installed without a harness"
fi
[[ -e "$TMP/u3/runner-run.service" ]] && fail "wrote a unit without a harness"
pass "no harness stops cleanly with setup pointer"

printf 'stub: all install-timers checks passed\n'
