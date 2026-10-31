---
"skills-for-agents": minor
---

feat(whips,setup-meta): fail-closed forge gate for team auto-merge landing. `shipping.md` refuses to arm and writes `needs-human reason=no-required-checks` when `repo-settings check` fails; `ready-check.md` treats the forge gap as a fail axis; setup-meta Section K records the check outcome and points at both gates by path (still ask-first, never silent apply). `repo-settings` gains a `REPO_SETTINGS_FIXTURE` stub mode with gap and green fixtures plus `repo-settings-test` proving nonzero exit with `refused` and zero forge calls. Closes #171.
