# Playbook: feature

New or changed behavior, built from a named data shape. The director owns design, plan, review, and verify. Delegates implement.

1. Ground in the affected subsystem. Spanning files means parallel read-only explorer subagents plus one synthesizer that merges their reports into a working mental model. A narrow question means one pass. Grounding is a traced model, not a file name.
2. Name the data shape first per the `codebase-design` vocabulary before any logic sketch: the organizing structure (state machine, typed model, table or registry) chosen before delegates write logic.
3. Design it twice when code crosses a function boundary: call the Skill tool with "codebase-design" and use its design-it-twice method. At least two structurally distinct candidates, picked on interface depth (more behavior behind a smaller surface). Record the synthesis decision and what was rejected.
4. Write the throughput checkpoint as todo items: blocking first steps, independent workstreams, shared mutable state (default split, serialize only for real invariants), smallest safe decomposition (if one worker is best, name why).
5. Delegate implementation to a fresh subagent with the section 4 brief (file paths, named data shape, success criteria). Review separation is mandatory: no standing by on a nested agent. A subagent forbidden to spawn satisfies this by owning the diff directly with the same separation.
6. Verify on the matching surface. Inconclusive or wrong-surface is not a pass. Flag it.
7. Rebase into small ordered commits, one verifiable unit per commit. Verify each before the next.
8. Contested design means a second opinion before shipping: call the Skill tool with "code-review" (Standards plus Spec), and send the same review prompt to a second model when the harness offers one. Agreement is the signal.
9. Unslop gate, then PR body with before/after evidence, then `playbooks/opening-a-pr.md`.
