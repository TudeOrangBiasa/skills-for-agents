# Unattended Runs

How agent runs proceed without the user watching in this repo. Read by the `runner` skill and single unattended `/whips` runs.

- **Landing:** `auto-merge | direct (team-only; solo N/A)`. Team only; solo repos leave this line out. `auto-merge` arms `gh pr merge --auto --squash` on open and lands when required checks pass; `direct` merges with `gh pr merge --squash` after CI is green plus a MERGED read-back. Auto-merge with empty required checks is refused (`needs-human reason=no-required-checks`).
- **Wake:** `<systemd timer unit, cron line, or harness headless command; empty when unattended is not opted in>`
- **Fix cap:** `3` attempts per PR, then `needs-human` (team fix-ci only).
- **Claim TTL:** release a stale `agent:fixing` claim after `RUNNER_TIMEOUT_MIN + 30min` (team fix-ci only).
- **Kill switch:** `runner.sh pause` (stop file), `install-timers pause`, or `install-timers uninstall`; resume with `resume`.
- **Wake mechanism:** see the `Wake:` line above (systemd timer unit, cron line, or harness headless command).
- **Run log:** `.scratch/whips/<run>/log.md`, one row per iteration (what changed, check run, predicate movement). The morning report's source.
- **Budget habit:** predicate first, then a stated cap (iterations, hours, PR count). Hitting the cap is a stop, reported as such.
- **Queues vs single runs:** issue queues run through `/runner`; a single long task runs through `/whips` with a checkable predicate plus budget. Landing follows the `Landing:` line above.
- **Autonomy tier (whips mode):** `<tiered auto-land (default) | strict HIT>`. Strict means every landing waits for a human regardless of tier.
- **Scheduled maintenance:** one block per job: `<skill and arguments> | <cadence> | <wake: cron line, systemd timer, or harness headless invocation> | <output sink>`. Default jobs, daily: `/retro` stale-docs sweep plus `/maintain-verification` upkeep, proposals filed, never auto-applied. When the `runner` skill serves this repo, add one intake job: `runner.sh triage | each timer tick, cap 3 per repo | same wake as the run job | tracker labels plus AI-disclaimer comments`. After merges, prune stale worktrees: `whips/scripts/worktree-prune --apply --all | each timer tick after the run job | same wake | local worktree removal (safe-to-prune only), dirty reported`.
