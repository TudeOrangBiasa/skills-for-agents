---
description: 'Apply before building on existing code: delete dead code, one-caller wrappers, and redundant checks first, then make the smallest change on the simpler base.'
name: principle-subtract-before-you-add
disable-model-invocation: true
---
# Subtract Before You Add

Delete first, then build. Before adding anything, remove the dead code, one-caller wrappers, and redundant checks around the change, and make the smallest change that solves the problem on the simpler base. A speculative "might help" change gets reverted.

## Why

Every line you keep is a line the next reader must understand and every future change must carry. Adding onto cruft compounds it: the new code wraps the old, the old stays because the new depends on it, and the design can only grow. Subtraction done first keeps the surface the same size or smaller while the capability grows.

## When it applies

Any addition, refactor, or rewrite that touches existing code or prose. Sequence removal before construction in the same change, not as a follow-up that never lands.

In practice:

- Cut before you polish. Get to the minimum that solves the problem before investing in quality on top.
- Design for observed usage, not speculative edge cases. No speculative validators, parsers, or guards beyond what the spec demands.
- Simplify prompts and docs the same way: remove redundant instructions and excessive templates instead of adding clarifications on top.
- When a reference has no novel content, delete it rather than leaving a stub behind.

## Example in this repo

The `whips` skill entry point carries a token budget enforced by `scripts/check-docs.sh`: it must stay small because it loads on every run. Adding a trigger row there means first asking what can go: a redundant sentence, a restated rule, a row that another skill already carries. The budget is the forcing function, but the habit applies everywhere: a new check in `check-docs.sh` should shrink or subsume an older one, not sit beside it.
