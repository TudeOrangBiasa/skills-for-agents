---
"skills-for-agents": minor
---

feat(setup-meta): repo settings check and apply for team landing (solo N/A). `whips/scripts/repo-settings check|apply` reads allow_auto_merge, delete_branch_on_merge, branch protection, required checks vs latest workflow jobs and check runs, plus the #65 label vocab; apply is idempotent with --dry-run, --yes, and UI steps without admin. Setup gains a team-only section, the unattended template gains a Landing line, and Landing auto-merge is refused with empty required checks. Closes #76.
