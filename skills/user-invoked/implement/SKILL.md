---
name: implement
description: "Implement a piece of work from a spec or set of tickets, test-first with before/after proof, closing with review and a PR body."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

## 1. Pick the work

Read the spec and its tickets. Read enough to see the shape: a single slice to build directly, or a task graph with blocking edges and a frontier of tickets ready to grab. Tickets from `to-tickets` are agent-ready by construction; work them blockers-first.


Plan gate: before coding, restate the ticket plus its Map (components, data flow, decisions) and Guardrails (must happen, must never happen). Ask clarifying questions, then wait for user approval. One ticket per context; if the ticket is too big, split it before starting.
## 2. Build test-first

Drive `/tdd` at the pre-agreed seams, one vertical slice at a time. Every slice is a before/after pair, no exceptions:

- **Before:** write the failing test first and show it failing. A slice with no red proof does not exist yet.
- **After:** write only enough code to turn it green.

Do not anticipate future slices or add speculative behaviour. Agree the seams up front; a seam nobody agreed to shows up as a review finding later.

## 3. Verify continuously

Run typechecking regularly, single test files regularly, and the full test suite once at the end.


For UI tickets, run `/break` before calling the work done: render the touched components against worst-case content plus the a11y floor, and note what visibly broke. Foundation breaks are fixed directly; the rest is reported for confirmation.
## 4. Scale with the graph

A single slice fits one session: build it here. A ticket graph gets worked along its frontier: finish blockers first so new tickets unlock. Where the harness supports background subagents, fan implementers out across the ready frontier and merge each finished slice back before kicking off more.

## 5. Review, mandatory

Once the work is complete, call the Skill tool with "code-review" and fix what it finds. No slice lands unreviewed.
Run the guardrails first: failing tests mean wrong behavior, fix that before reviewing style. Review the code as if a human wrote it; do not lower the bar because it came from an agent.

## 6. Write the PR body

Shape the closing PR with the `pr` skill (Summary visual, before/after Evidence, Merge Danger). The before/after pairs from step 2 are the evidence section almost verbatim.

## 7. Commit

Commit the reviewed work to the current branch.
