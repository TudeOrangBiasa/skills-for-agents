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

# 2. Dead internal links in added markdown lines. Links inside fenced code
#    blocks are template examples, not pointers, so added lines that sit
#    within fences in the worktree file are skipped (a whole-file rename
#    otherwise fails on its own placeholders).
dead_links=0
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  [[ "$f" == *.md ]] || continue
  [[ -f "$f" ]] || continue
  dir="$(dirname "$f")"
  fenced="$(awk 'BEGIN{f=0} /^```/{f=!f; next} f{print NR}' "$f")"
  while IFS=$'\t' read -r lineno target; do
    [[ -z "$target" ]] && continue
    case "$target" in http*|mailto:*|"#"*) continue ;; esac
    target="${target%%#*}"
    if grep -qx "$lineno" <<< "$fenced" 2>/dev/null; then continue; fi
    [[ -e "$dir/$target" ]] || { fail "dead link in $f: $target"; dead_links=1; }
  done < <(git diff -U0 "$RANGE" -- "$f" | awk '
    /^@@ -[0-9]+(,[0-9]+)? \+[0-9]+(,[0-9]+)? @@/ { s=$0; sub(/.*\+/, "", s); sub(/[, ].*/, "", s); n=s+0; next }
    /^\+\+\+/ { next }
    /^-/ { next }
    /^\+/ { line=substr($0,2); rest=line; while (match(rest, /\]\([^)]+\)/)) { link=substr(rest, RSTART+2, RLENGTH-3); sub(/ ".*"$/, "", link); print n "\t" link; rest=substr(rest, RSTART+RLENGTH) } n++; next }
    { n++ }
  ' || true)
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

# 4b. Whips always-on pack budget (issue #120). The whips SKILL.md entry
#    point loads on every run; cap its size locally (tokens = bytes/4).
#    Plafond: WHIPS_PACK_BUDGET_TOKENS below (raised 3000 -> 3200 for the
#    pstack trigger parity in #68: seven trigger rows plus grant clause).
#    A PR growing the file past the budget fails here, in pre-commit,
#    with no Actions involved.
WHIPS_PACK_BUDGET_TOKENS=3200
whips_bytes="$(wc -c < skills/user-invoked/whips/SKILL.md)"
whips_tokens="$((whips_bytes / 4))"
if [[ "$whips_tokens" -gt "$WHIPS_PACK_BUDGET_TOKENS" ]]; then
  fail "whips pack $whips_tokens tokens exceeds budget $WHIPS_PACK_BUDGET_TOKENS (shrink SKILL.md or raise the plafond in this script with reason)"
else
  pass "whips pack $whips_tokens/$WHIPS_PACK_BUDGET_TOKENS tokens"
fi

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

# 6. Skill frontmatter name equals the folder name (issue #21). Full-tree
#    scan: a renamed skill that forgot its frontmatter breaks installs.
name_mismatch=0
while IFS= read -r skill_file; do
  dir="$(dirname "$skill_file")"
  folder="$(basename "$dir")"
  fname="$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//;s/^[\"'"']//;s/[\"'"']$//')"
  if [[ -z "$fname" ]]; then fail "missing frontmatter name in $skill_file"; name_mismatch=1;
  elif [[ "$fname" != "$folder" ]]; then fail "frontmatter name '$fname' != folder '$folder' in $skill_file"; name_mismatch=1; fi
done < <(find skills -name SKILL.md)
[[ "$name_mismatch" == "0" ]] && pass "skill names match folders"

if [[ "$failures" -gt 0 ]]; then
  echo "check-docs: $failures check(s) failed."
  exit 1
fi
echo "check-docs: all checks passed."
