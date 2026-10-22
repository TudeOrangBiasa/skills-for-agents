# Playbook: figure it out

No narrower playbook fits, but the task is real work: a large migration, an ambitious multi-part change, or work the human reviews after stepping away. Design the playbook first, run it second. The human decides on the design; the agent owns everything after. Rigor scales to the task.

## A. Design (human gate, no execution yet)

1. Decompose into atomic, independently landable units, riskiest-unknown-first. Each unit states its hypothesis, its checkable predicate, and its verify step.
2. Fan out only across seams (rule 15): one worktree and branch per worker. Over-fanning is banned.
3. Small fog (two or three units, clear predicates): light design, skip to B. Large fog: the full list below.
4. Write the phase list down and stop for human review. Present the units, the order, and what each proves. Nothing executes before approval; design changes after approval come back here.

## B. Run the loop

1. Add the approved units to the todo and run each as an experiment: state the hypothesis, make the smallest change, measure against the predicate on the real artifact, keep it if it advanced, revert it if it did not. Verify each unit before starting the next (rule 4).
2. Repeated work gets a lever (rule 12): the tool is the artifact the reviewer reruns. Delegated units carry their verification contract; a worker gaming the gate means resetting and hardening the contract, never routing around it.
3. Weave the run log through execution (`.scratch/whips/<run>/log.md`, one row per landed unit), never saved for the end. It is the morning report's and `ketchup`'s source.
4. Discoveries on the way (a flaky test, a small related bug) get their own PR; return to the predicate. A plateau means changing approach, never relaxing the predicate to declare victory.

## C. Land

Close each unit via `playbooks/opening-a-pr.md`: always ready, landing per risk tier. Opening a PR does not start a babysit; review comments go through `playbooks/triage.md` review mode, and stacks waiting on CI or conflicts through `playbooks/babysit.md`, only when asked.

**Reply:** the approved design, per-unit predicate results, PRs opened with their risk labels, what was reverted, and what is waiting on the human.
