# Unattended Runs

How agent runs proceed without the user watching in this repo. Read by the `autonomous-run` playbook and the `nightshift` skill.

- **Wake mechanism:** `<the command or scheduler entry that re-invokes /whips: harness loop or wait command, watch on CI or refs, outside scheduler>`
- **Run log:** `.scratch/whips/<run>/log.md`, one row per iteration (what changed, check run, predicate movement). The morning report's source.
- **Budget habit:** predicate first, then a stated cap (iterations, hours, PR count). Hitting the cap is a stop, reported as such.
- **Queues vs predicates:** issue queues run through `/nightshift`; single long tasks run through the `autonomous-run` playbook. Both leave draft PRs; landing follows the risk tier (low may land on a PASS verdict, high waits for the human).
