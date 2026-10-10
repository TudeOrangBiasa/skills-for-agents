---
"skills-for-agents": minor
---

Add `nightshift` (user-invoked): run `ready-for-agent` issues unattended on a schedule through `/whips` triage intake, draft PRs only. One runner-agnostic script (`scripts/nightshift.sh`) with a documented contract: interactive `setup` detects installed agent CLIs and models and saves your choice, with no default agent, model, or provider; `run` holds a per-machine lock, claims each issue with a label, works in a fresh worktree, converts a non-draft PR back to draft, catches up missed nights, and logs every outcome to `runs.jsonl`; `check` gates schedulers. Adapters for manual runs, a systemd user timer, cron, and Orca automations (verified features only, cited). Wired into both READMEs and the `guide` router.
