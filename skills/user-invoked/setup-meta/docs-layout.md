# Docs layout

One door into where skills write and read. Scaffolded by `/setup-meta` Section J; content stays lazy (only created when a skill needs it).

| Artifact | Created by | Read by | Canonical path | Lazy or scaffolded |
| --- | --- | --- | --- | --- |
| Issue tracker config | `/setup-meta` Section A | `to-tickets`, `triage`, whips playbooks | `docs/agents/issue-tracker.md` | scaffolded |
| Domain rules | `/setup-meta` Section C | skills needing glossary/ADR layout | `docs/agents/domain.md` | scaffolded |
| Triage labels | `/setup-meta` Section B | `triage`, whips playbooks | `docs/agents/triage-labels.md` | scaffolded when `triage` installed |
| Model map | `/setup-meta` Section F | whips subagent roles | `docs/agents/models.md` | scaffolded on yes |
| Unattended config | `/setup-meta` Section G | `runner`, unattended runs | `docs/agents/unattended.md` | scaffolded |
| Repo mode | `/setup-meta` Section H | playbooks needing solo vs team | `docs/agents/repo-mode.md` | scaffolded |
| Verifier | `/setup-meta` Section I | pre-push hook, agent before PR | `docs/agents/verifier.md` | scaffolded for solo repos |
| This map | `/setup-meta` Section J | humans and agents | `docs/agents/docs-layout.md` | scaffolded |
| Glossary | `domain-modeling`, `discuss-with-docs`, `deepen` | many skills | `GLOSSARY.md` (legacy `CONTEXT.md`) | lazy |
| ADR | `domain-modeling` | `deepen`, `retro`, `to-spec` | `docs/adr/NNNN-slug.md` | dir scaffolded, bodies lazy |
| Research findings | `/research` | humans | `docs/research/<slug>.md` | dir scaffolded, files lazy |
| Spec | `to-spec` | whips, triage | issue tracker (or `.scratch/<feature>/spec.md` local) | lazy |
| Run log, pause note | whips playbooks | `pickup`, `ketchup` | `.scratch/whips/<run>/log.md`, `pause.md` | dir scaffolded, files lazy |
| Decision trail | `show-me-your-work` | `orchestrate`, morning audit | `.scratch/whips/<run>/decisions.tsv`, or `.audit/<slug>.tsv` parallel | lazy |
| Hillclimb log | `hillclimb` | `hillclimb` | `.scratch/whips/<run>/decisions.tsv` (hillclimb per-attempt schema) | lazy |
| Feature map | `create-verification` | `maintain-verification`, `swarm` | `skills/verify-<app>/features/` | lazy |
| Workflows | `worklog` | `worklog` | `workflows/*.md` | lazy |
| Compounding log | `learn-while-delegating` | `teach` | root `LEARNED.md` | lazy |
| Handoff | `handoff` | next session | `$TMPDIR` (outside the repo on purpose) | lazy |
| Design tokens, standards | `/setup-meta` Section D | `retro`, `guide` | root `DESIGN.md`, standards file | scaffolded on yes |

Naming rule: one convention for decision trails. Whips runs (including hillclimb) use `.scratch/whips/<run>/decisions.tsv` (plural); hillclimb keeps its own per-attempt schema inside that filename, documented in its playbook. Parallel non-whips efforts use `.audit/<slug>.tsv`. No two trails share a filename with different schemas without a note saying why.
