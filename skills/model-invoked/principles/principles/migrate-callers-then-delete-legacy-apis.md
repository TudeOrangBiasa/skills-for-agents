# Migrate Callers, Then Delete Legacy APIs

A new internal API means inventorying callers, migrating them, and deleting the old one in the same wave.

No compatibility layers kept only because internal callers still exist; adapters are exceptional and time-boxed. Update tests to the new contract and delete tests that only guard pre-refactor details. Applies only when no external user needs backward compatibility: when external users exist, deprecate on a schedule instead.

## Why

A compatibility layer kept for internal callers is code nobody owns and everybody routes around. It doubles the surface every later change must consider, it teaches new readers two ways to do one thing, and "temporary" shims outlive every plan that created them. Migrating in the same wave keeps one contract, one set of tests, and one story in the diff.

## When it applies

- The API is internal: no external user depends on backward compatibility and the project can absorb coordinated breaking changes.
- The new API is part of a simplification or refactor, not a parallel offering.
- Tests move with the code: assert the new contract, delete tests that only protect pre-refactor implementation details.

## Example in this repo

Skill renames move in one wave: the bucket README, the top-level README, and every cross-link update in the same change, with no alias stub left behind. `scripts/check-docs.sh` enforces the same-wave rule structurally by failing on dead internal links in added lines, so moved files get their pointers updated in the same PR.
