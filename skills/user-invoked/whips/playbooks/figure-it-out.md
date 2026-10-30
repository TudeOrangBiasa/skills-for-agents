# Playbook: figure it out

No narrower playbook fits, but the task is real work: a large migration, an ambitious multi-part change, or work the human reviews after stepping away. Design the playbook first, run it second. The human decides on the design; the agent owns everything after. Rigor scales to the task.

## A. Design (human gate, no execution yet)

1. State the run's definition of done as one falsifiable predicate, plus scope quantified (rough units and effort) and the blockers grounding surfaced. Then decompose into atomic, independently landable units, riskiest-unknown-first, scaffold and verification before features. Each unit states its hypothesis, its checkable predicate, and its verify step.
2. Set the rigor level, biased high: one-way doors and high blast radius get gates and artifacts, reversible low-stakes steps get less. Rigor is gates and artifacts, not trying harder.
3. For one-way-door design decisions, run "architect" (it runs "arena") before executing. Skip it for mechanical work whose shape is already concrete, where a second arena is over-engineering (rule 1).
4. Build the verification harness before the work, with the baseline captured from the pre-change state, so each check reads as old value versus new value.
5. Fan out only across seams (rule 15): one worktree and branch per worker, effort and speed per worker per `SKILL.md` section 6. Over-fanning is banned.
6. Small fog (two or three units, clear predicates): light design, skip to B. Large fog: the full list above.
7. Write the phase list down and stop for human review. Present the predicate, the rigor level, the units, the order, and what each proves. Nothing executes before approval; design changes after approval come back here.

## B. Run the loop

1. Add the approved units to the todo and run each as an experiment: state the hypothesis, make the smallest change, measure against the predicate on the real artifact, keep it if it advanced, revert it if it did not. Verify each unit before starting the next (rule 4). Verify by inspecting the artifact, never a self-report; a pass that came too easily means suspecting the observation method before the system. Verdicts are VERIFIED, NOT VERIFIED, or INCONCLUSIVE per `SKILL.md` section 7, and inconclusive is not a pass.
2. Repeated work gets a lever (rule 12): the tool is the artifact the reviewer reruns. Delegated units carry their verification contract; a worker gaming the gate means resetting and hardening the contract, and a wrong gate gets fixed in its own change. Neither case ever routes around the gate.
3. Weave the run log through execution (`.scratch/whips/<run>/log.md`, one row per landed unit), never saved for the end. It is the morning report's and `ketchup`'s source. Keep the decision trail beside it per "show-me-your-work" (`.scratch/whips/<run>/decisions.tsv`, one row per landed unit); commit the trail when the run is ambitious enough that the reviewer needs it to trust the work.
4. Discoveries on the way (a flaky test, a small related bug) get their own PR; return to the predicate. A plateau means changing approach, never relaxing the predicate to declare victory.

## C. Land

Close each unit via `playbooks/opening-a-pr.md`: always ready, landing per risk tier. Opening a PR does not start a babysit; review comments go through `playbooks/triage.md` review mode, and stacks waiting on CI or conflicts through `playbooks/babysit.md`, only when asked. Before handing back, check the whole against the section A predicate on the real product, not just the harness. Encode any recurring correction as a gate, a lint rule, a check, or a script (rule 13).

**Reply:** the approved design, the rigor level and why, per-unit predicate results, the decision-trail path, PRs opened with their risk labels, what was reverted, and what is waiting on the human.
