# Unattended Runs

How agent runs proceed without the user watching in this repo. Read by the `autonomous-run` playbook and the `nightshift` skill.

- **Wake mechanism:** `<the command or scheduler entry that re-invokes /whips: harness loop or wait command, watch on CI or refs, outside scheduler>`
- **Run log:** `.scratch/whips/<run>/log.md`, one row per iteration (what changed, check run, predicate movement). The morning report's source.
- **Budget habit:** predicate first, then a stated cap (iterations, hours, PR count). Hitting the cap is a stop, reported as such.
- **Queues vs predicates:** issue queues run through `/nightshift`; single long tasks run through the `autonomous-run` playbook. Landing follows the risk tier (low lands on PASS with no human touch, high waits for the human).
- **Autonomy tier (whips mode):** `<tiered auto-land (default) | strict HIT>`. Strict means every landing waits for a human regardless of tier.
- **Scheduled maintenance:** one block per job: `<skill and arguments> | <cadence> | <wake: cron line, systemd timer, or harness headless invocation> | <output sink>`. Default job: `/retro` stale-docs sweep every few days, proposals filed, never auto-applied.
