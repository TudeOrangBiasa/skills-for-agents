---
description: Shape state-changing work so rerun and crash converge to the same end state. Use when writing commands, lifecycle steps, processing loops, or any unattended tick that may run twice or die halfway.
name: principle-make-operations-idempotent
disable-model-invocation: true
---
# Make operations idempotent

Shape each operation so running it twice, or crashing halfway, still reaches the same end state. No single mechanism is required; pick what fits the operation at hand.

Why: commands, lifecycle steps, and loops run where crashes, restarts, and retries are normal. When leftover state changes the next run's outcome, every restart becomes a debugging session.

## The method

Base each step on the state you find, not on the state the previous run intended. Read what is there, diff against the goal, apply only the gap. A step written this way repeats safely, because the second run finds nothing left to do.

Every residue a run can leave (locks, temp files, half-written records, claimed jobs) must be classifiable as stale by the next run. Judge staleness from evidence that holds no matter where the previous run died, not just in the common case. A marker the next run cannot read turns each crash into manual cleanup. Usual shapes: write to a temp path and rename into place, compare artifacts by content instead of creation order, edit a marker comment in place instead of appending another one.

## In this repo

Unattended whips work keeps its state readable from GitHub: the pause note and run log live in edit-in-place marker comments (`whips-pause`, `whips-run-log`) that pickup re-reads, and a tick that changed nothing writes nothing. Checks like `scripts/check-docs.sh` only read and report, so rerunning them is always safe.

## The test

1. What happens if this runs twice in a row?
2. What happens if the previous run crashed at every possible point?
3. Does re-execution converge to the same end state?

If any answer is "it depends on the state left behind", the operation needs a reconciliation step.

**Reply:** for each state-changing operation, the rerun and crash answers, or the reconciliation step you added.
