# Playbook: autonomous run

A run until a checkable predicate holds, overnight or unattended. Same rigor as `figure-it-out.md` section B, but the predicate is already clear, so there is no design gate: write the predicate down, wake on a schedule, iterate, stop when it holds.

Figure-it-out owns bespoke designs that need human approval first; this playbook owns already-clear predicates that run without asking.

## 1. Write the predicate

One falsifiable sentence plus how to check it (command, page, metric with a threshold). Add scope quantified (rough units and effort) and the stop budget: a stated iteration, hour, or PR cap. Never relax the predicate to declare victory; a plateau means changing approach, not the goal.

## 2. Pick the wake

One of three, harness-neutral: a cron line, an interval loop, or a ship-runner tick. Never name a product harness loop command. Point at `craft-trail` for the per-iteration record.

## 3. Run the loop

Each iteration: state the hypothesis, make the smallest change the predicate allows, verify against the predicate on the real artifact, commit when it advanced, revert when it did not. Verdicts are VERIFIED, NOT VERIFIED, or INCONCLUSIVE, and inconclusive is not a pass. Weave the run log through execution (`.scratch/whips/<run>/log.md`, one row per iteration) and keep the decision trail beside it per `craft-trail` (`.scratch/whips/<run>/decisions.tsv`, one row per landed unit); commit the trail when the run is ambitious enough that the reviewer needs it to trust the work.

Discoveries on the way (a flaky test, a small related bug) get their own PR; return to the predicate. When truly stuck with no approach left, use the escape hatch: stop the run, write what was tried and what the predicate still needs, and hand back to the human.

## 4. Land

Close each unit via `playbooks/opening-a-pr.md`: always ready, landing per risk tier. Before handing back, check the whole against the predicate on the real product, not just the harness.

**Reply:** the predicate, the wake, per-iteration results, the decision-trail path, PRs opened with their risk labels, what was reverted, and what is waiting on the human.
