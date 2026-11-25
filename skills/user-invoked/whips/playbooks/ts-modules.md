# Playbook: ts-modules

Make every package in this repo a **deep module**: a lot of behaviour behind a small interface. A package's public surface is its **entry points** (the files at the package root); everything in its subfolders is hidden. This playbook installs [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) and the rules that make the entry points the only way in, then proves the rules bite.

Advanced, off the main flow: reach for it once per TypeScript monorepo, before agents start importing across packages. For the vocabulary (deep module, interface, seam, depth), use the depth terms (module, interface, seam, adapter, leverage, locality) throughout.

## The shape this enforces

```
src/packages/
  <name>/
    index.ts        ← an entry point (public). Import this from outside.
    client.ts       ← another entry point. Packages may expose SEVERAL.
    lib/            ← implementation: hidden from outside, free to import each other.
    tests/          ← co-located tests + fixtures (a subfolder, so private).
```

The public surface is the package's **root files**, not one designated `index.ts`. By convention implementation lives in `lib/` and tests in `tests/`, giving every package the same two-folder shape. The rule itself is general: *anything* in *any* subfolder is private, so the config never grows a folder rule. Adding an entry point is just adding a root file (no barrel).

Four rules, all `error`:

1. **Entry-point boundary**: code outside a package (app code or another package) may import only that package's entry points (its root files), never anything in its subfolders.
2. **Intra-package freedom**: a package's own files import each other freely.
3. **Tests through the entry points**: files under `<pkg>/tests/` may import any package's entry points and their own `tests/` fixtures, but never any package's subfolder internals (not even their own). Integration tests across packages are fine; deep imports are not.
4. **No cycles**: no dependency cycles.

**Entry points, not a barrel.** Because the public surface is *every* root file, a package can expose several small entry points (`index.ts`, `client.ts`, `server.ts`) instead of funnelling everything through one giant `index.ts`. Barrel files that re-export a whole subtree are discouraged; keep entry points small and hide implementation in subfolders.

Layering (which packages may depend on which) is a *different* concern and is left as a commented stub in the config for the repo to fill in.

## Steps

### 1. Detect the environment

- **Package manager**: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lockb` → bun, else npm.
- **Packages root**: if `src/` exists use `src/packages`, else `packages`. Confirm with the user if the repo already has a different obvious convention.
- **Existing config**: check for a `.dependency-cruiser.*` file. If one exists, do **not** overwrite it: merge the four rules and the options in, and say what was added.

### 2. Install dependency-cruiser

Install `dependency-cruiser` as a devDependency with the detected package manager.

### 3. Write the config

Write the root `.dependency-cruiser.cjs` with `PACKAGES_ROOT` set to the detected root and the four forbidden rules (entry-point boundary, intra-package freedom, tests through entry points, no cycles via group-match back-references so a package reaches its own internals while outsiders cannot).

### 4. Wire it into the checks

- Add a `lint:boundaries` script: `depcruise <packages-root>` (or `depcruise src`).
- Fold it into the repo's umbrella check command (the one that already runs typecheck). Do **not** touch `tsconfig` or add path aliases.
- If there is no umbrella script, add `lint:boundaries` and tell the user to include it in CI.

### 5. Scaffold the example package

Create a committed `<packages-root>/example/` as a copy-me template: `index.ts` delegates to an internal file, `lib/impl.ts` is the hidden implementation, `tests/example.test.ts` imports **only** `../index` and asserts the public function. A starter template to copy or delete.

### 6. Prove the rules bite

A config that does not fail on a violation is worthless:

1. Run `lint:boundaries`. It must **pass** on the clean example.
2. Temporarily add a deep import to `tests/example.test.ts` (e.g. `import { thing } from "../lib/impl"`). Run again; it must **fail**.
3. Revert the deep import. Run once more; it must **pass**.

If step 2 does not fail, the rules are not wired correctly: fix before finishing.

### 7. Document the convention

Write a `README.md` **in the packages folder** covering the layout, "import only through a package's entry points", and how to run `lint:boundaries`. **Discourage barrel files** explicitly. Then add a **context pointer** from the repo's `AGENTS.md` (one line, e.g. ``Packages are deep modules: see `src/packages/README.md` before adding or importing one``).
