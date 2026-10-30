---
"skills-for-agents": minor
---

feat(setup-pre-commit): commit-msg template enforcing Conventional Commits (commitlint when present, dependency-free shell otherwise, merge/revert exempt) plus the four-layers paragraph (pre-commit fast, pre-push slow, commit-msg format, verifier in docs/agents/verifier.md decides; agents never use --no-verify). Tested in scratch: rejects fixed stuff and trailing periods, accepts feat/runner and Merge/Revert. No changes to .husky/ or .github/ in this repo. Closes #60.
