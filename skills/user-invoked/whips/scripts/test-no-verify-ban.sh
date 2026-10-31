#!/usr/bin/env bash
# Stub test for ensure-worktree-hooks plus no-verify-guard (issue #167).
# No network, no gh, no push to any remote: a local bare repo plus local
# worktrees only. Exercises: copy/install, nonzero when still hookless,
# --check, idempotence, argv ban, and scan mode.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ENSURE="$HERE/ensure-worktree-hooks"
GUARD="$HERE/no-verify-guard"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

git init --quiet --bare "$TMP/origin.git"
git clone --quiet "$TMP/origin.git" "$TMP/main"
git -C "$TMP/main" config user.email t@t.t
git -C "$TMP/main" config user.name t
echo base >"$TMP/main/file.txt"
git -C "$TMP/main" add -A
git -C "$TMP/main" commit --quiet -m base
git -C "$TMP/main" branch -M main
MAIN="$TMP/main"

# Source hooks dir with a pre-push verifier stand-in.
mkdir -p "$MAIN/.githooks"
printf '#!/usr/bin/env bash\nexit 0\n' >"$MAIN/.githooks/pre-push"
chmod +x "$MAIN/.githooks/pre-push"

mkworktree() { # branch -> path; fresh worktrees ship hookless
  git -C "$MAIN" branch "$1" main 2>/dev/null || true
  git -C "$MAIN" worktree add "$TMP/$1" "$1" >/dev/null 2>&1
  printf '%s\n' "$TMP/$1"
}
gitdir_of() { git -C "$1" rev-parse --absolute-git-dir; }

# 1. Fresh worktree has no pre-push hook; --check exits 1 (fail closed).
WT1="$(mkworktree feat-one)"
T1="$(gitdir_of "$WT1")/hooks/pre-push"
[[ ! -f "$T1" ]] || fail "fresh worktree unexpectedly has $T1"
if "$ENSURE" --check --worktree "$WT1" >/dev/null 2>&1; then
  fail "--check passed on a hookless worktree"
fi
pass "hookless worktree fails --check with nonzero exit"

# 2. Ensure copies the hook from the source dir; --check then passes.
"$ENSURE" --worktree "$WT1" --source "$MAIN/.githooks" >/dev/null \
  || fail "ensure failed on $WT1"
[[ -x "$T1" ]] || fail "hook not installed executable at $T1"
"$ENSURE" --check --worktree "$WT1" >/dev/null \
  || fail "--check still failing after ensure"
pass "ensure installs pre-push and --check passes"

# 3. Default source resolution finds .githooks without --source.
WT2="$(mkworktree feat-two)"
"$ENSURE" --worktree "$MAIN" >/dev/null || fail "ensure on main failed"
T2="$(gitdir_of "$WT2")/hooks/pre-push"
[[ ! -f "$T2" ]] || fail "second worktree unexpectedly has $T2"
(cd "$MAIN" && "$ENSURE" --worktree "$WT2" >/dev/null) \
  || fail "ensure with default source resolution failed"
[[ -x "$T2" ]] || fail "default resolution did not install $T2"
pass "default source resolution finds .githooks"

# 4. No source anywhere: ensure exits nonzero and installs nothing.
WT3="$(mkworktree feat-three)"
T3="$(gitdir_of "$WT3")/hooks/pre-push"
rm -f "$T3"
if (cd "$TMP" && WHIPS_HOOKS_SOURCE="" "$ENSURE" --worktree "$WT3" --source "$TMP/empty-src" >/dev/null 2>&1); then
  fail "ensure passed with a missing source dir"
fi
mkdir -p "$TMP/empty-src"
if (cd "$TMP" && WHIPS_HOOKS_SOURCE="" "$ENSURE" --worktree "$WT3" --source "$TMP/empty-src" >/dev/null 2>&1); then
  fail "ensure passed with a source dir lacking pre-push"
fi
[[ ! -f "$T3" ]] || fail "ensure wrote a hook with no source"
pass "ensure fails closed with no pre-push source"

# 5. Idempotent: second ensure exits 0 and keeps the hook.
"$ENSURE" --worktree "$WT1" --source "$MAIN/.githooks" >/dev/null \
  || fail "second ensure failed"
[[ -x "$T1" ]] || fail "hook lost after second ensure"
pass "ensure is idempotent"

# 6. Guard argv mode: --no-verify refused, plain push and --verify clean.
if "$GUARD" -- push origin feat-one --no-verify >/dev/null 2>&1; then
  fail "guard passed push argv carrying --no-verify"
fi
if "$GUARD" -- push --no-verify=true origin feat-one >/dev/null 2>&1; then
  fail "guard passed push argv carrying --no-verify=true"
fi
"$GUARD" -- push origin feat-one >/dev/null 2>&1 \
  || fail "guard refused a plain push with hooks on"
"$GUARD" -- push --verify origin feat-one >/dev/null 2>&1 \
  || fail "guard refused an explicit --verify push"
pass "guard refuses --no-verify argv, accepts hooks-on pushes"

# 7. Guard scan mode: hookless worktree refused, hooked worktree clean.
if "$GUARD" --scan "$WT3" >/dev/null 2>&1; then
  fail "guard --scan passed a hookless worktree"
fi
"$GUARD" --scan "$WT1" >/dev/null 2>&1 \
  || fail "guard --scan refused a hooked worktree"
pass "guard --scan treats hookless as bypass, hooked as clean"

# 8. No GitHub writes: guard and ensure never invoke gh or push.
for s in "$ENSURE" "$GUARD"; do
  if sed 's/#.*//' "$s" | grep -qE '(^|[[:space:];])gh([[:space:];]|$)|git[[:space:]]+push'; then
    fail "$s invokes gh or git push"
  fi
done
pass "scripts never call gh or git push"

echo "no-verify stub: all 8 scenarios green"
