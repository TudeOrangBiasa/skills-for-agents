#!/usr/bin/env bash
# check-proof-urls.sh: fail a proof PR body that hotlinks branch URLs.
#
# Evidence must hotlink from main (or a permanent store): branch URLs rot
# when the branch is deleted. This checks a PR body for
# github.com/<owner>/<repo>/blob/<branch>/... links pointing anywhere
# except the default branch, and fails listing them.
#
# Usage:
#   scripts/check-proof-urls.sh <owner/repo> <pr-number> [main-branch]
#
# Needs: gh (authenticated for private repos).
# Exit 0 when clean, 1 with the offending URLs otherwise.
set -euo pipefail

REPO="${1:?usage: check-proof-urls.sh <owner/repo> <pr-number> [main-branch]}"
PR="${2:?usage: check-proof-urls.sh <owner/repo> <pr-number> [main-branch]}"
MAIN="${3:-main}"

body="$(gh pr view "$PR" -R "$REPO" --json body --jq .body)"
mapfile -t urls < <(grep -oE "github\.com/[^/[:space:]]+/[^/[:space:]]+/blob/[^/)[:space:]\"]+" <<< "$body" || true)

failures=0
for u in "${urls[@]}"; do
  branch="$(cut -d/ -f5 <<< "$u")"
  if [[ "$branch" != "$MAIN" ]]; then
    echo "check-proof-urls: FAIL: branch URL (rots on deletion): https://$u"
    failures=$((failures + 1))
  fi
done

if [[ "$failures" -gt 0 ]]; then
  echo "check-proof-urls: $failures branch URL(s). Move the files onto $MAIN and link there."
  exit 1
fi
echo "check-proof-urls: clean (all evidence URLs on $MAIN)."
