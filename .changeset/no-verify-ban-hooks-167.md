---
"skills-for-agents": minor
---

feat(setup-meta,whips): enforce the pre-push hook plus the no-verify ban by script (ensure-worktree-hooks installs the hook into every new worktree and fails closed while absent; no-verify-guard refuses bypass argv and hookless pushes; setup-meta Sections E and I plus opening-a-pr steps 2-3 point at both scripts by path; stub test proves nonzero-without-hook and no-verify rejection with no GitHub writes). Closes #167.
