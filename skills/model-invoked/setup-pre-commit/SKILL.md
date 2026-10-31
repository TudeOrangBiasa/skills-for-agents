---
name: setup-pre-commit
description: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate. Use when user wants commit-time formatting/linting/typechecking/testing.
---

# Setup Pre-Commit Hooks

## What This Sets Up

- **Husky** pre-commit hook
- **Toolchain detection first**: oxlint plus oxfmt when the repo already uses them ( configs `oxlintrc.json`, oxfmt devDependency), else Biome on `biome.json`, else Prettier with lint-staged. Rust toolchains run whole-repo in milliseconds, so they need no staged runner.
- **typecheck** and **test** scripts in a pre-push hook (never pre-commit: slow gates flood agents with known-broken state)
- **timing split**: pre-commit stays under 3 seconds (format, token gate, staged-file checks); everything slower goes to pre-push plus the configured verifier
- **token-size gate**: staged text files stay under ~5,000 tokens so no file grows past reviewable size

## Steps

### 1. Detect package manager and toolchain

Check for `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (yarn), `bun.lockb` (bun). Use whichever is present. Default to npm if unclear.

Then detect the lint/format toolchain in this order: oxlint (`oxlintrc.json` or an `oxlint` devDependency) plus oxfmt (devDependency) wins first; else Biome (`biome.json`); else Prettier (config file or devDependency); else nothing yet, which means asking the user which toolchain to install (never defaulting to oxlint unasked). Record the choice: every step below branches on it.

### 2. Install dependencies

Always: `husky`. Plus per toolchain: oxlint path means `oxlint` and `oxfmt` devDependencies; Biome path means `biome`; Prettier path means `lint-staged` and `prettier`.

### 3. Initialize Husky

```bash
npx husky init
```

This creates `.husky/` dir and adds `prepare: "husky"` to package.json.

### 4. Create `.husky/pre-commit`

Write this file (no shebang needed for Husky v9+), branching on the detected toolchain:

```
# oxlint/oxfmt path (whole repo, milliseconds, no staged runner needed)
npx oxlint --deny-warnings
npx oxfmt --check .
```

```
# Biome path
npx biome check --write .
```

```
# Prettier path
npx lint-staged
```

Pre-commit runs format plus lint plus the token gate only: batch the feedback at commit time, never per edit (per-edit checks flood the agent with tokens about breakage it already knows). Typecheck and tests do not belong here.

### 4b. Create `.husky/pre-push`

Slow gates live here and in the configured verifier (solo: docs/agents/verifier.md plus pre-push; team: CI running the same commands), never in pre-commit:

```
npm run typecheck
npm run test
```


### 4c. Create `.husky/commit-msg`

Enforce Conventional Commits on the message (`type(scope): subject`, types `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, same list as the whips `opening-a-pr` playbook). Use `commitlint` only when the repo already has it; otherwise append this dependency-free shell (under 1 second, git merge/revert messages exempt):

```bash
# Conventional Commits gate: type(scope): subject, no trailing period; merge/revert exempt
msg="$(cat "$1")"
case "$msg" in "Merge "*|"Revert "*) exit 0;; esac
echo "$msg" | grep -qE '^(feat|fix|docs|refactor|test|chore|perf)(\(.+\))?: .+' || \
  { echo "commit message must be Conventional Commits: type(scope): subject"; exit 1; }
echo "$msg" | grep -qE '\.$' && \
  { echo "commit subject must not end with a period"; exit 1; }
exit 0
```


### 5. Create `.lintstagedrc` (Prettier path only; oxlint, oxfmt, and Biome run whole-repo fast enough to skip staged runners)

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. Create `.prettierrc` (if missing)

Only create if no Prettier config exists. Use these defaults:

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. Token-size gate

Refuse staged files over ~5,000 tokens (tokens = bytes/4), so nothing grows past agent-reviewable size. Append to `.husky/pre-commit`:

```bash
# token budget: staged text files stay under ~5000 tokens
oversize="$(git diff --cached --name-only --diff-filter=ACM | grep -vE '(\.lock$|lock\.yaml$|lockb$|\.min\.|/dist/|/build/|CHANGELOG\.md$|package-lock\.json$)' | while read -r f; do
  [ -f "$f" ] || continue
  bytes=$(wc -c <"$f"); [ "$bytes" -gt 20000 ] && echo "$f ($((bytes / 4)) tokens)";
done)"
[ -z "$oversize" ] || { echo "oversized staged files (split first, then commit):"; echo "$oversize"; exit 1; }
```

Lockfiles, minified bundles, build output, and the generated changelog are exempt (not agent-authored). The error names the files plus token counts so the split is obvious.

### 8. Verify

- [ ] `.husky/pre-commit` exists and is executable, running the detected toolchain's fast gate
- [ ] `.lintstagedrc` exists
- [ ] `prepare` script in package.json is `"husky"`
- [ ] `prettier` config exists
- [ ] token gate rejects a staged text file over 20k bytes (test once with a scratch file, then unstage it)
- [ ] Run `npx lint-staged` to verify it works

### 9. Commit

Stage all changed/created files and commit with message: `Add pre-commit hooks (husky + lint-staged + prettier)`

This will run through the new pre-commit hooks: a good smoke test that everything works.

## The four layers

Pre-commit is fast (format, token gate, staged checks, under 3 seconds). Pre-push is slow (typecheck, tests). Commit-msg is format (`type(scope): subject`). The final verifier is the command in `docs/agents/verifier.md` (solo: pre-push; team: CI running the same commands plus a PR-title check): hooks are the first filter, the verifier decides. Hooks can be skipped with `--no-verify`; agents never use that flag to bypass a gate.

## Notes

- Husky v9+ doesn't need shebangs in hook files
- `prettier --ignore-unknown` skips files Prettier can't parse (images, etc.)
- The pre-commit runs lint-staged plus the token gate only (fast, staged-only, under 3 seconds); full typecheck and tests run at pre-push and CI
