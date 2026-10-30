---
description: 'Apply to multi-step work and to how you stack commits and PRs: break work into small units that each end in a check that passes on its own, and order them so the sequence proves itself.'
name: principle-sequence-verifiable-units
disable-model-invocation: true
---
# Sequence Verifiable Units

Each commit and each PR ends in a check that passes on its own. Verify one unit before starting the next, and order them so the sequence proves itself. Order work as a sequence of small units, each ending in a state you can check, and do not advance until the current one is green.

## Why

A break caught at the unit that caused it is cheap to localize. A break caught after a batch is buried, and you have already built further on a broken base. Sequencing those same units into a delivery a reviewer can replay turns "trust me" into "watch it go red, then green."

## When it applies

Multi-step work (sweeps, migrations, runs of similar edits) and how you stack commits and PRs.

**Execution.** In a sweep, migration, or any run of similar edits, verify each change before starting the next. Each unit is a before/after bracket: known-good state, one change, run the check, then proceed. Rebase onto clean trunk first so every check measures against the real baseline. When a lever does the edits, the per-unit check is nearly free. Run it anyway.

**Delivery.** Stack commits and PRs in the order that proves the work. The canonical shape is the failing test first, then the fix on top. Other story orders are a subtraction before the reshape, a baseline capture before the treatment, the scaffold before the feature. Each commit lands on its own and the sequence reads as an argument.

The sequencing complement to the prove-it-works leaf, which keeps each check real, and the build-the-lever leaf, which makes the per-unit check cheap.

## Example in this repo

Splitting one skill into several leaf skills lands as a stack, not a blob: first the leaf directories with their SKILL.md files, each checkable on its own, then the index updates that point at them, then the monolith trim that depends on the index. A reviewer replays the stack commit by commit and every step is green; a single commit mixing new leaves, index edits, and monolith deletions can only be trusted whole.
