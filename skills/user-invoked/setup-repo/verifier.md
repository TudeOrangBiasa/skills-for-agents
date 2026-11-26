# Verifier

The one command that decides whether this repo is green. PASS means exit 0.

- **Command:** `<the verify command, e.g. npm run verify>`
- **PASS:** exit 0. Anything else is red. `pending: wire a verifier` means no verifier exists yet; `whips` waits on it for runnable surfaces.
- **Solo:** runs in pre-push and again by the agent before `gh pr create`. Merge trusts pre-push; never wait on GitHub checks.
- **Team:** CI runs the same command plus a PR-title Conventional Commits check.

Report the verifier as a `Gates:` block: one row per command with its output or artifact (`flutter analyze`: 0 issues; `flutter test`: 12/12; UI: `docs/bukti-ui/<shot>.png`). A command with no output shown did not run.

Missing file means setup never ran: stop and tell the user to run `/setup-repo`.
