---
name: setup-pre-commit
description: Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, tests, and a token-size gate in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing.
---

# Setup Pre-Commit Hooks

## What This Sets Up

- **Husky** pre-commit hook
- **lint-staged** running Prettier on all staged files
- **Prettier** config (if missing)
- **typecheck** and **test** scripts in the pre-commit hook
- **token-size gate**: staged text files stay under ~5,000 tokens so no file grows past reviewable size

## Steps

### 1. Detect package manager

Check for `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (yarn), `bun.lockb` (bun). Use whichever is present. Default to npm if unclear.

### 2. Install dependencies

Install as devDependencies:

```
husky lint-staged prettier
```

### 3. Initialize Husky

```bash
npx husky init
```

This creates `.husky/` dir and adds `prepare: "husky"` to package.json.

### 4. Create `.husky/pre-commit`

Write this file (no shebang needed for Husky v9+):

```
npx lint-staged
npm run typecheck
npm run test
```

**Adapt**: Replace `npm` with detected package manager. If repo has no `typecheck` or `test` script in package.json, omit those lines and tell the user.

### 5. Create `.lintstagedrc`

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

- [ ] `.husky/pre-commit` exists and is executable
- [ ] `.lintstagedrc` exists
- [ ] `prepare` script in package.json is `"husky"`
- [ ] `prettier` config exists
- [ ] token gate rejects a staged text file over 20k bytes (test once with a scratch file, then unstage it)
- [ ] Run `npx lint-staged` to verify it works

### 9. Commit

Stage all changed/created files and commit with message: `Add pre-commit hooks (husky + lint-staged + prettier)`

This will run through the new pre-commit hooks: a good smoke test that everything works.

## Notes

- Husky v9+ doesn't need shebangs in hook files
- `prettier --ignore-unknown` skips files Prettier can't parse (images, etc.)
- The pre-commit runs lint-staged first (fast, staged-only), then full typecheck and tests
