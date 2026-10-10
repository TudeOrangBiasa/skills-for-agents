---
"skills-for-agents": patch
---

`/whips` gains two playbooks. `opening-a-pr` closes every code-changing playbook: worktree per unit, small ordered commits, Conventional Commits titles, `pr` skill body with `Closes #N`, base-branch stacks, and readiness flipped from pstack to always draft. Agents never mark ready or merge, and the linked issue moves to `ready-for-human`. `triage` adds an intake mode that picks one `ready-for-agent` issue, checks its agent brief, and routes it to bug or feature (a thin brief goes back to `needs-info`), plus a review mode that classifies each review or bot comment as fix, dismiss, or ask. Both reuse the `/triage` label vocabulary without invoking `/triage`. Guide and README now mention the intake route.
