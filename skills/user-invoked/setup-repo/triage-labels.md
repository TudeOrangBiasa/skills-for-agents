# Triage Labels

One vocabulary, one meaning per label. State roles apply to issues; `needs-human` is the only human-handoff label on PRs.

| Canonical role | Label in our tracker | One meaning |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage` | `needs-triage` | Maintainer needs to evaluate this issue |
| `needs-info` | `needs-info` | Waiting on reporter for more information |
| `ready-for-agent` | `ready-for-agent` | Fully specified, ready for an AFK agent |
| `ready-for-human` | `ready-for-human` | Issue needs human implementation. Never applied to PRs |
| `wontfix` | `wontfix` | Will not be actioned |
| `risk-low` | `risk:low` | Agent PR: low verification lane |
| `risk-medium` | `risk:medium` | Agent PR: medium verification lane, merges only when every landing condition holds |
| `risk-high` | `risk:high` | Agent PR: high verification lane, independent PASS on the current head, then a human merges |

## Automation labels

| Label | One meaning | Written by |
| --- | --- | --- |
| `ci-failed`, `agent:fixing`, `fix-attempt-N` | Poller machine state for PRs needing an agent fix | CI and poller |
| `needs-human` | Agent stopped and a human must decide. Poller skips it, auto-merge disarms. The reason always rides in one marker comment: `<!-- needs-human reason=stuck-3x|ask-thread|high-blast-lane-fail|no-required-checks -->` | agent or poller |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.
