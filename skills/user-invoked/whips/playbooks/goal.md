# Playbook: goal mode

Goal mode: one goal pursued to its predicate without the user watching. Not a queue runner (that is `/runner`): one goal, one predicate, done when it holds: "run until the tests are green", "work through these five issues", "keep going while I sleep". You own the exit condition. Every unit still ends as a ready PR, and the pause list in `SKILL.md` section 5 still holds.

1. State the exit condition as a checkable predicate before the first iteration: the suite is green, the repro passes, all N issues have ready PRs. Add a budget the user gave or one you state (iterations, hours, PR count). Hitting the budget is a stop, reported as such.
2. Pick the wake mechanism the harness offers: its loop or wait command, a watch on CI or a ref, or an outside scheduler calling `/whips` again. Event-driven beats fixed intervals. One watcher at a time.
3. Each iteration makes the smallest change the evidence supports, verifies it against the predicate, and commits if it moved. A change that did not help gets reverted, not left in.
4. Route each unit through its own playbook (bug, feature, refactor) and close it with `playbooks/opening-a-pr.md`. One branch per unit, so the human reviews small ready PRs in the morning instead of one large diff.
5. Discoveries on the way are yours: a flaky test, a broken skill, a small related bug. Fix each in its own PR and return to the predicate. Do not park reversible work for the human.
6. Keep a run log in the worktree (`.scratch/whips/<run>/log.md`): one row per iteration with what changed, the check run, and whether the predicate moved. It is the morning report's source.
7. Stop when the predicate holds, the budget runs out, or every remaining path needs the pause list. A plateau is not a stop: change approach. Never relax the predicate to declare victory.

**Reply:** close the run with a catch-up in the ketchup shape ([`../../ketchup/SKILL.md`](../../ketchup/SKILL.md)), built from the run log: open with how many action items there are, then what happened (iterations that changed nothing stay silent), then each item waiting on the human as a short executive summary. A tick that changed something gets caught up; a tick that changed nothing stays quiet.
