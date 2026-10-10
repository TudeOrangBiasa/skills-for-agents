---
"skills-for-agents": minor
---

Add `nightshift` (user-invoked): work `ready-for-agent` issues unattended through `/whips` triage intake, one fresh worktree each, draft PRs only. `scripts/nightshift.sh` reads the tracker and label strings from each repo's `docs/agents/` (the `/setup-meta` output), falling back to `gh` and the canonical role names like `opening-a-pr`. Setup detects agent CLIs and models and asks; nothing is defaulted. Runs hold a per-machine lock, claim by assignment, release stale claims, convert a non-draft PR back to draft, and log every outcome. `CONTRACT.md` documents it for any scheduler. Wired into both READMEs and the `guide` router.
