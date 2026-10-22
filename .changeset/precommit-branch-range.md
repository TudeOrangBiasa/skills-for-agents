---
"skills-for-agents": patch
---

Pre-commit hook now compares the worktree against the branch point instead of HEAD, so a stacked second commit no longer fails checks its branch already satisfies (changeset committed earlier on the same branch). Genuine violations with no changeset anywhere on the branch still fail. Verified both directions on probe branches.
