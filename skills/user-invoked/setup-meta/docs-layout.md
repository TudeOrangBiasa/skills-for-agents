# Docs layout

One door into where skills write and read. Scaffolded by `/setup-meta`; content stays lazy (only created when a skill needs it).

| Path | Created by | Read by |
| --- | --- | --- |
| `docs/agents/issue-tracker.md` | `/setup-meta` Section A | `to-tickets`, `triage`, whips playbooks |
| `docs/agents/domain.md` | `/setup-meta` Section C | skills needing glossary/ADR layout |
| `docs/agents/triage-labels.md` | `/setup-meta` Section B (only when `triage` installed) | `triage`, whips playbooks |
| `docs/agents/models.md` | `/setup-meta` Section F (only on yes) | whips subagent roles |
| `docs/agents/unattended.md` | `/setup-meta` Section G | `runner`, unattended runs |
| `docs/agents/repo-mode.md` | `/setup-meta` Section H (`mode: solo\|team`) | playbooks needing solo vs team behavior |
| `docs/agents/verifier.md` | `/setup-meta` Section I (verify command, PASS = exit 0) | pre-push hook, agent before PR |
| `docs/agents/docs-layout.md` | `/setup-meta` (this file) | humans and agents as the map |
| `docs/adr/` | `/setup-meta` scaffold (`.gitkeep` only) | `domain-modeling` writes `NNNN-slug.md` |
| `docs/research/` | `/setup-meta` scaffold | `/research` default output `<slug>.md` |
| `.scratch/whips/` | `/setup-meta` scaffold | whips run log, pause note, decision trail |
| `.audit/` | `/setup-meta` scaffold | parallel decision trails |

Lazy (never scaffolded with content): `GLOSSARY.md` and ADR bodies (`domain-modeling`), `skills/verify-*/` (`create-verification`), `workflows/*.md` (`worklog`), handoffs in `$TMPDIR`.
