# Playbook: feature

New or changed behavior, built from a named data shape. The director owns design, plan, review, and verify. Delegates implement.

1. Ground in the affected subsystem. Spanning files means parallel read-only explorer subagents plus one synthesizer that merges their reports into a working mental model. A narrow question means one pass. Grounding is a traced model, not a file name. Code-coupled work (one feature, one migration) goes to a single owner with the throughput checkpoint inline; that owner fans out internally after the blocking phase. Parent-level fan-out is for slices that produce independent artifacts (audits, cross-subsystem investigations, competing experiments).
2. Name the data shape first per the `craft-vocab` vocabulary before any logic sketch: the organizing structure (state machine, typed model, table or registry) chosen before delegates write logic.
3. Design it twice when code crosses a function boundary: call the Skill tool with "craft-vocab" and use its design-it-twice method. At least two structurally distinct candidates, picked on interface depth (more behavior behind a smaller surface). Record the synthesis decision and what was rejected.
4. Write the throughput checkpoint as todo items: blocking first steps (gates run before fan-out), independent workstreams (disjoint files, services, or layers parallelize; shared writes serialize), shared mutable state (default split, serialize only for real invariants), smallest safe decomposition (if one worker is best, name why). A dimension that genuinely does not apply keeps its item with `n/a: <reason>` rather than being dropped. Rewrite the checkpoint at phase boundaries; spawn a fresh owner rather than chaining interrupts.
5. Delegate implementation to a fresh subagent with the section 4 brief (file paths, named data shape, success criteria). When the implementation admits multiple valid shapes (error handling, abstraction layer, test structure), delegate via the "craft-arena" skill instead so the runners surface the alternatives and the cross-judge guards the pick. Review separation is mandatory: no standing by on a nested agent. A subagent forbidden to spawn satisfies this by owning the diff directly with the same separation.
6. Verify on the matching surface. Inconclusive or wrong-surface is not a pass. Flag it.
7. Rebase into small ordered commits, one verifiable unit per commit. Verify each before the next. Stack follow-ups.
8. Contested design means a second opinion before shipping: call the Skill tool with "review-code" (Standards plus Spec), and send the same review prompt to a second model when the harness offers one, else the same prompt in a fresh context with the adversarial brief. Agreement is the signal.
9. Unslop gate, then PR body with before/after evidence, then `playbooks/opening-a-pr.md`.

**Reply:** what you built, what you chose and why, the throughput checkpoint, open decisions. Tables for design alternatives.
