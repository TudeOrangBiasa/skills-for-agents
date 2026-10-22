#!/usr/bin/env bash
# check-docs.sh: docs hygiene gate for skills-for-agents.
#
# Compares HEAD against a base ref (default: origin/main) and fails when:
#   1. Any added or modified skill (skills/<bucket>/<name>/SKILL.md) is not
#      mentioned in its bucket README.md and the top-level README.md.
#      Names drift otherwise; mentions are the cheapest contract this repo has.
#   2. Added markdown lines link at dead internal targets: every
#      [text](./target) must resolve, so moved files get their pointers
#      updated in the same PR. External URLs, anchors, and mailto: skipped.
#
# Usage:
#   scripts/check-docs.sh [base-ref]
#
# Env:
#   DOCS_BASE   base ref when no argument is given.
#   DOCS_SKIP=1 skip all checks (escape hatch for chore commits).
#
# Exit 0 when everything passes, 1 with a checklist of failures otherwise.
set -euo pipefail

BASE="${1:-${DOCS_BASE:-origin/main}}"

if [[ "${DOCS_SKIP:-0}" == "1" ]]; then
  echo "check-docs: skipped via DOCS_SKIP=1"
  exit 0
fi

if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
  echo "check-docs: FAIL: base ref '$BASE' not found. Fetch it first (git fetch origin main)."
  exit 1
fi

RANGE="${DOCS_RANGE:-$BASE...HEAD}"
failures=0
fail() { echo "check-docs: FAIL: $1"; failures=$((failures + 1)); }
pass() { echo "check-docs: ok: $1"; }

changed="$(git diff --name-only --diff-filter=ACMR "$RANGE" -- || true)"

# 1. Skill mentions in both READMEs.
changed_skills="$(grep -E '^skills/[^/]+/[^/]+/SKILL\.md$' <<< "$changed" || true)"
if [[ -z "$changed_skills" ]]; then
  pass "no skills touched"
else
  while IFS= read -r skill_file; do
    [[ -z "$skill_file" ]] && continue
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    bucket="$(basename "$(dirname "$skill_dir")")"
    grep -qF "$skill_name" "skills/$bucket/README.md" \
      && pass "$skill_name in skills/$bucket/README.md" \
      || fail "$skill_name is not mentioned in skills/$bucket/README.md"
    grep -qF "$skill_name" README.md \
      && pass "$skill_name in top-level README.md" \
      || fail "$skill_name is not mentioned in top-level README.md"
  done <<< "$changed_skills"
fi

# 2. Dead internal links in added markdown lines.
dead_links=0
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  [[ "$f" == *.md ]] || continue
  dir="$(dirname "$f")"
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    case "$target" in http*|mailto:*|"#"*) continue ;; esac
    target="${target%%#*}"
    [[ -e "$dir/$target" ]] || { fail "dead link in $f: $target"; dead_links=1; }
  done < <(git diff -U0 "$RANGE" -- "$f" | grep '^+' | grep -v '^+++' | grep -oE '\]\([^)]+\)' | sed 's/^](//;s/)$//;s/ "[^"]*"$//' || true)
done <<< "$(git diff --name-only --diff-filter=ACMR "$RANGE" -- '*.md' || true)"
[[ "$dead_links" == "0" ]] && pass "no dead internal links in added lines"


# 3. Changeset for user-facing changes (skills/ or top-level README).
needs_changeset=0
if grep -qx "README.md" <<< "$changed"; then needs_changeset=1; fi
while IFS= read -r f; do
  [[ "$f" == skills/* ]] && needs_changeset=1
done <<< "$changed"
if [[ "$needs_changeset" == "1" ]]; then
  if git diff --name-only --diff-filter=A "$RANGE" -- '.changeset/*.md' | grep -qv '^.changeset/README.md$'; then
    pass "changeset present"
  else
    fail "skills/ or README.md changed but no .changeset/*.md added (run: npx changeset)"
  fi
else
  pass "no user-facing changes, changeset not required"
fi

# 4. No em dashes in added markdown lines (repo rule).
if git diff -U0 "$RANGE" -- '*.md' | grep '^+' | grep -v '^+++' | grep -q '—'; then
  fail "em dash found in added markdown lines (rewrite with comma, colon, period, or parens)"
else
  pass "no em dashes in added lines"
fi

# 5. PRs open ready, never as a draft (issue #15). Ban the create-as-draft
#    flag and the "always a draft" instruction anywhere under skills/.
#    Allowed: the word "draft" for prose drafts, and legacy-draft handling
#    (`gh pr ready`, pickup/runner notes). Full-tree scan so the rule
#    cannot slide back in outside the diff.
if grep -rn --include='*.md' -E 'gh pr create --draft|glab mr create .*--draft' skills/ >/dev/null 2>&1; then
  fail "draft-PR flag found in skills/ (open every PR ready: \`gh pr create\` with no --draft)"
elif grep -rni --include='*.md' -E 'always a.? draft' skills/ >/dev/null 2>&1; then
  fail "'always (a) draft' instruction found in skills/ (PRs open ready; the verdict gates the merge)"
else
  pass "no draft-PR instruction in skills/"
fi

if [[ "$failures" -gt 0 ]]; then
  echo "check-docs: $failures check(s) failed."
  exit 1
fi
echo "check-docs: all checks passed."
