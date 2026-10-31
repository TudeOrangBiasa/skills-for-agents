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

# 4c. Guide thin-router pack budget (issue #193). The guide SKILL.md is
#    the default load for the router, so it stays tiny; the whole pack
#    (exact file set: SKILL.md, COOKBOOK.md, FACTORY.md,
#    PHASE-BOUNDARIES.md, CREDITS.md) stays under its plafond so the
#    deep module keeps a small interface. Tokens = bytes/4, same as 4b.
GUIDE_ROUTER_BUDGET_TOKENS=400
GUIDE_PACK_BUDGET_TOKENS=5300
guide_router_bytes="$(wc -c < skills/user-invoked/guide/SKILL.md)"
guide_router_tokens="$((guide_router_bytes / 4))"
if [[ "$guide_router_tokens" -gt "$GUIDE_ROUTER_BUDGET_TOKENS" ]]; then
  fail "guide router $guide_router_tokens tokens exceeds budget $GUIDE_ROUTER_BUDGET_TOKENS (shrink SKILL.md, move detail to COOKBOOK/FACTORY)"
else
  pass "guide router $guide_router_tokens/$GUIDE_ROUTER_BUDGET_TOKENS tokens"
fi
guide_pack_bytes=0
for guide_file in SKILL.md COOKBOOK.md FACTORY.md PHASE-BOUNDARIES.md CREDITS.md; do
  guide_pack_bytes="$((guide_pack_bytes + $(wc -c < "skills/user-invoked/guide/$guide_file")))"
done
guide_pack_tokens="$((guide_pack_bytes / 4))"
if [[ "$guide_pack_tokens" -gt "$GUIDE_PACK_BUDGET_TOKENS" ]]; then
  fail "guide pack $guide_pack_tokens tokens exceeds budget $GUIDE_PACK_BUDGET_TOKENS (cut the pack or raise the plafond in this script with reason)"
else
  pass "guide pack $guide_pack_tokens/$GUIDE_PACK_BUDGET_TOKENS tokens"
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

# 7. Alias table stays resolvable (issue #175). Old names must answer the
#    new skill with matching frontmatter; otherwise the 1-release alias rots.
if [[ -f docs/aliases.md && -f scripts/test-aliases.sh ]]; then
  if bash scripts/test-aliases.sh >/dev/null 2>&1; then
    pass "aliases resolve"
  else
    fail "docs/aliases.md no longer resolves (run: bash scripts/test-aliases.sh)"
  fi
else
  pass "no alias table to check"
fi

# 8. Harness-name gate (issue #190): denylisted names fail unless scripts/harness-name-allowlist.txt exempts the path (glob) or the line (path-glob:line-regex).
HARNESS_ALLOW="scripts/harness-name-allowlist.txt"
DENY_RE='\b(omp|opencode|codex|claude|orca|fedora|oh-my-pi)\b|~/\.omp|\.omp/|\.codex/|\.claude/|\.pi/|opencode\.json|claude\.md'
match_path() { # file glob (a leading **/ also matches nested paths)
  local f="$1" pat="$2"
  [[ "$f" == $pat ]] && return 0
  if [[ "$pat" == "**/"* ]]; then
    local suffix="${pat#\*\*/}"
    [[ "$f" == "$suffix" || "$f" == */"$suffix" ]] && return 0
  fi
  return 1
}
allowed_hit() { # file line
  local f="$1" ln="$2" rule="" pat="" rx=""
  while IFS= read -r rule || [[ -n "$rule" ]]; do
    [[ -z "$rule" || "$rule" == \#* ]] && continue
    if [[ "$rule" == *:* ]]; then
      pat="${rule%%:*}"; rx="${rule#*:}"
      if match_path "$f" "$pat" && grep -qE "$rx" <<<"$ln"; then return 0; fi
    else
      if match_path "$f" "$rule"; then return 0; fi
    fi
  done < "$HARNESS_ALLOW"
  return 1
}
harness_hits=0
if [[ -f "$HARNESS_ALLOW" ]]; then
  while IFS= read -r hit; do
    hfile="${hit%%:*}"; hrest="${hit#*:}"; hline="${hrest#*:}"
    if ! allowed_hit "$hfile" "$hline"; then
      fail "harness-specific name in $hfile: $hline"
      harness_hits=$((harness_hits + 1))
    fi
  done < <(grep -rInE -e "$DENY_RE" skills README.md docs 2>/dev/null || true)
else
  fail "missing $HARNESS_ALLOW (the harness-name gate needs its allowlist)"
  harness_hits=$((harness_hits + 1))
fi
[[ "$harness_hits" == "0" ]] && pass "no harness-specific names outside the allowlist"

if [[ "$failures" -gt 0 ]]; then
  echo "check-docs: $failures check(s) failed."
  exit 1
fi
echo "check-docs: all checks passed."
