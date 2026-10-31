#!/usr/bin/env bash
# test-aliases.sh: alias resolution test for the #175 rename batch.
#
# Reads docs/aliases.md (the Old -> New table) and asserts:
#   1. Every old name resolves: its new skill folder exists with SKILL.md
#      whose frontmatter name equals the new folder name.
#   2. Every old name is gone as a folder (no stale skill dir answers it).
#   3. The table holds exactly 54 rows (53 ticketed plus ketchup-video).
#
# Usage: bash scripts/test-aliases.sh
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

pass() { printf 'aliases ok: %s\n' "$1"; }
fail() { printf 'aliases FAIL: %s\n' "$1" >&2; exit 1; }

[[ -f docs/aliases.md ]] || fail "docs/aliases.md missing"

rows=0
while IFS='|' read -r _ old new _; do
  old="$(printf '%s' "$old" | tr -d ' `' )"
  new="$(printf '%s' "$new" | tr -d ' `' )"
  [[ -z "$old" || "$old" == "Old" || "$old" == ---* ]] && continue
  [[ -z "$new" || "$new" == "New" ]] && continue
  rows=$((rows + 1))
  new_dir="$(find skills -maxdepth 2 -type d -name "$new" | head -n 1)"
  [[ -n "$new_dir" ]] || fail "new skill missing for old '$old': no skills/*/$new/"
  front="$(sed -n 's/^name: //p' "$new_dir/SKILL.md" | head -n 1)"
  [[ "$front" == "$new" ]] || fail "frontmatter mismatch in $new_dir/SKILL.md: '$front' vs '$new'"
  if find skills -maxdepth 2 -type d -name "$old" | grep -q .; then
    fail "old skill folder still present: skills/*/$old/"
  fi
done < <(grep -E '^\| `' docs/aliases.md)

[[ "$rows" == "54" ]] || fail "alias table holds $rows rows, want 54"
pass "54 old names resolve to new skills with matching frontmatter, no stale folders"
