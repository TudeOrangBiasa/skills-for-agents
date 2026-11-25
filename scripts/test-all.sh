#!/usr/bin/env bash
# test-all.sh: one aggregator for every local stub suite (issue #217).
# Runs check-docs, the alias table, and each skill stub; any failure
# fails the whole run. No network, no CI.
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
pass() { printf 'test-all ok: %s\n' "$1"; }
fail() { printf 'test-all FAIL: %s\n' "$1" >&2; exit 1; }

bash scripts/check-docs.sh "${DOCS_BASE:-origin/main}" || fail "check-docs.sh"
pass "check-docs"
bash scripts/test-aliases.sh || fail "test-aliases.sh"
pass "test-aliases"
bash skills/user-invoked/whips/scripts/test-no-verify-ban.sh || fail "test-no-verify-ban.sh"
pass "no-verify-ban"
bash skills/user-invoked/whips/scripts/test-verify-proof.sh || fail "test-verify-proof.sh"
pass "verify-proof"
bash skills/user-invoked/whips/scripts/test-plan-map-handoff.sh || fail "test-plan-map-handoff.sh"
pass "plan-map-handoff"
bash skills/user-invoked/whips/scripts/test-worktree-prune.sh || fail "test-worktree-prune.sh"
pass "worktree-prune"
bash skills/user-invoked/whips/scripts/verdict-check-test || fail "verdict-check-test"
pass "verdict-check"
bash skills/user-invoked/whips/scripts/repo-settings-test || fail "repo-settings-test"
pass "repo-settings"
node skills/user-invoked/whips/scripts/check-plan-test.mjs || fail "check-plan-test.mjs"
pass "check-plan"
echo "test-all: all suites passed."
