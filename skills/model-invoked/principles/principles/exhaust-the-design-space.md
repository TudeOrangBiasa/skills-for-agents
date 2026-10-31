# Exhaust the Design Space

Your first idea is unlikely to be the best. When no precedent in the codebase settles the choice, build two or three competing prototypes and compare them side by side before committing. This applies to product design too: when user experience depends on feel, only running variants side by side show which one feels right.

## Why

Reasoning about a single design hides its tradeoffs; comparison surfaces them. Prototypes answer feel questions that argument cannot: layout, flow, naming, seam placement. The cost of two throwaway sketches is smaller than the cost of carrying the wrong shape through implementation and review.

## When it applies

A fork that running code can settle: which layout, flow, query, or approach. Novel UI interactions, new module shapes, architectural decisions with no local precedent. Skip it when the codebase already shows the pattern: follow the precedent instead of re-proving it.

In practice:

- Sketch at least two structurally distinct candidates, not two tunings of one idea.
- Compare on the same inputs and the same surface the user will hit.
- Record what won and what lost, with one line on why, so the next reader does not re-run the bakeoff.

## Where it lives in this repo

Embedded, not a numbered rule: the PRINCIPLES.md header names it as design-it-twice. The carrier is the `craft-vocab` method in `skills/model-invoked/craft-vocab/DESIGN-IT-TWICE.md`: parallel subagents design radically different interfaces, then compare on depth, locality, and seam placement. It fires through the `whips` trigger "Code crosses a function boundary" (`craft-architect` on `craft-vocab` vocabulary), through `playbooks/prototype.md` for forks running code can settle, and through the `craft-arena` skill for bakeoffs.

## Example in this repo

A new skill playbook with an unsettled shape, for example a loop over the issue queue, gets two or three interface sketches via the design-it-twice pattern before any implementation: one minimizing entry points, one optimizing the common caller, one maximizing flexibility. The comparison picks on interface depth, and the rejected sketches stay in the session record as the reason the shape is what it is.
