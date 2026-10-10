---
"skills-for-agents": minor
---

`/whips` gains `babysit` and `ready-check`, plus a shared `RISK.md`. Babysit drives an open agent PR or stack to merge-ready (modes `drive`, `check`, `threads-only`; conflicts, then threads, then CI; one rerun for flakes) and stops there, leaving the PR a draft. Ready-check verifies each PR with a fresh subagent that did not write it, records the verdict against the head SHA, and hands the human a merge plan: high-risk PRs first for a real review, low-risk PRs as a quick batch, blocked ones last. The human still marks ready and merges every PR. `RISK.md` defines `risk:high` by concrete rules (auth and security, money, data and migrations, secrets and config, CI, public contract breaks, major dependencies, diffs over 400 lines or 15 files, unproven verdicts) and `risk:low` for everything else, with a short reason paragraph. `opening-a-pr` now labels risk on every PR, and the `setup-meta` label seed carries the two risk rows.
