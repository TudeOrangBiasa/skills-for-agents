# Verifier

The one command that decides whether this repo is green. PASS means exit 0.

- **Command:** `<the verify command, e.g. npm run verify>`
- **PASS:** exit 0. Anything else is red.
- **Solo:** runs in pre-push and again by the agent before `gh pr create`. Merge trusts pre-push; never wait on GitHub checks.
- **Team:** CI runs the same command plus a PR-title Conventional Commits check.

Missing file means setup never ran: stop and tell the user to run `/setup-repo`.
