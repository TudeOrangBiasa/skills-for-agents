# Playbook: autonomous run

A long task driven to done without the user watching: "run until the tests are green", "work through these five issues", "keep going while I sleep". You own the exit condition. Every unit still ends as a draft PR, and the pause list in `SKILL.md` section 5 still holds.

1. State the exit condition as a checkable predicate before the first iteration: the suite is green, the repro passes, all N issues have draft PRs. Add a budget the user gave or one you state (iterations, hours, PR count). Hitting the budget is a stop, reported as such.
2. Pick the wake mechanism the harness offers: its loop or wait command, a watch on CI or a ref, or an outside scheduler calling `/whips` again. Event-driven beats fixed intervals. One watcher at a time.
3. Each iteration makes the smallest change the evidence supports, verifies it against the predicate, and commits if it moved. A change that did not help gets reverted, not left in.
4. Route each unit through its own playbook (bug, feature, refactor) and close it with `playbooks/opening-a-pr.md`. One branch per unit, so the human reviews small drafts in the morning instead of one large diff.
5. Discoveries on the way are yours: a flaky test, a broken skill, a small related bug. Fix each in its own PR and return to the predicate. Do not park reversible work for the human.
6. Keep a run log in the worktree (`.scratch/whips/<run>/log.md`): one row per iteration with what changed, the check run, and whether the predicate moved. It is the morning report's source.
7. Stop when the predicate holds, the budget runs out, or every remaining path needs the pause list. A plateau is not a stop: change approach. Never relax the predicate to declare victory.

**Reply:** the predicate and whether it holds, iterations run, PRs opened with their risk labels (high-risk first), what was reverted, and what is waiting on the human.
