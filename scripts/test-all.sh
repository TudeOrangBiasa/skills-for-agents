#!/usr/bin/env bash
# test-all.sh: one aggregator for every local suite.
# Runs check-docs (skill mentions, dead links, changeset, frontmatter,
# prose gates); any failure fails the whole run. No network, no CI.
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
pass() { printf 'test-all ok: %s\n' "$1"; }
fail() { printf 'test-all FAIL: %s\n' "$1" >&2; exit 1; }

bash scripts/check-docs.sh "${DOCS_BASE:-origin/main}" || fail "check-docs.sh"
pass "check-docs"
echo "test-all: all suites passed."
