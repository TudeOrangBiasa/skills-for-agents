# Playbook: hillclimb

One measurable thing, improved iteratively against a target. You own the metric and the experiment's integrity: supervise and review, delegate the attempts. A one-off fix is `bug.md` or `perf-issue.md`; this is the loop.

Core discipline: one change, one measurement, keep or revert. Never stack untested changes, never claim a win from code inspection (rule 3).

1. Ground before choosing the metric: run `how` over the target, name the workload dimensions that move the result (data size, history, state, concurrency), and pick a case reproducing the complaint. No reproducing case means fixing the repro, not hillclimbing. Then fix one metric, the direction counting as better, and a checkable stop predicate pairing a target with a floor on attempts (so a lucky early win cannot end the run). Use the user's numbers when given, otherwise agree them.
2. Build the measurement harness, prove its sensitivity, then freeze it (rule 12): contrasting workloads reproduce the symptom on the target case and separate on easier ones; one frozen command emits the metric, sampled past the noise (median of N, never a single run). Record the baseline and a green regression gate (tests that must keep passing) before any change.
3. Open the decision log: `.scratch/whips/<run>/decision.tsv`, one row per attempt (id, hypothesis, change, before, after, delta, tests, verdict kept or reverted, note). Read it before each attempt. It stays out of the tree.
4. Ground each hypothesis in the architecture model (a specific mechanism, not "try memoizing something"). For perf metrics, order hypotheses by the mantras in `perf-issue.md` step 2; borrow only the order, not its stop rule.
5. Loop one hypothesis per iteration: hand the change to a delegate with tight scope and review the diff rather than typing it (rule 20); fan independent hypotheses to parallel workers in separate worktrees (rule 15). Measure before and after with the frozen harness plus the regression gate. Accept only past-noise moves with a green gate, else revert in full. One commit per accepted fix, staging only changed files. Log the row either way. Unattended runs use an outside scheduler tick, not a goals loop, and keep this playbook's stop rule.
6. Push past the first plateau: on repeated rejects, pivot category, combine near-misses, re-read the source, or go more radical before concluding. Correctness and simplicity outrank the number; revert a win that breaks behavior, keep a simplification holding the number (rule 1).
7. Stop on the predicate, or when remaining ideas are marginal past their cost. Never relax the predicate, never quit with cheap untried hypotheses left. Stuck means surfacing it, not spinning.
8. Close via `playbooks/opening-a-pr.md`, accepted commits stacked in landing order.

**Reply:** metric and target, baseline to final with percent delta, iterations kept vs reverted, each accepted fix on one line, the decision log path, and the best next idea if pushed further.
