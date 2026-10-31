# Docs layout

One door into where skills write and read. Scaffolded by `/setup-repo` Section J; content stays lazy (only created when a skill needs it).

| Artifact | Created by | Read by | Canonical path | Lazy or scaffolded |
| --- | --- | --- | --- | --- |
| Issue tracker config | `/setup-repo` Section A | `plan-tickets`, `ship-triage`, whips playbooks | `docs/agents/issue-tracker.md` | scaffolded |
| Domain rules | `/setup-repo` Section C | skills needing glossary/ADR layout | `docs/agents/domain.md` | scaffolded |
| Triage labels | `/setup-repo` Section B | `ship-triage`, whips playbooks | `docs/agents/triage-labels.md` | scaffolded when `ship-triage` installed |
| Model map | `/setup-repo` Section F | whips subagent roles | `docs/agents/models.md` | scaffolded on yes |
| Unattended config | `/setup-repo` Section G | `ship-runner`, unattended runs | `docs/agents/unattended.md` | scaffolded |
| Repo mode | `/setup-repo` Section H | playbooks needing solo vs team | `docs/agents/repo-mode.md` | scaffolded |
| Verifier | `/setup-repo` Section I | pre-push hook, agent before PR | `docs/agents/verifier.md` | scaffolded for solo repos |
| This map | `/setup-repo` Section J | humans and agents | `docs/agents/docs-layout.md` | scaffolded |
| Glossary | `craft-domain`, `plan-grill-docs`, `craft-deepen` | many skills | `GLOSSARY.md` (legacy `CONTEXT.md`) | lazy |
| ADR | `craft-domain` | `craft-deepen`, `learn-retro`, `plan-spec` | `docs/adr/NNNN-slug.md` | dir scaffolded, bodies lazy |
| Research findings | `/craft-research` | humans | `docs/research/<slug>.md` | dir scaffolded, files lazy |
| Spec | `plan-spec` | whips, ship-triage | issue tracker (or `.scratch/<feature>/spec.md` local) | lazy |
| Run log, pause note | whips playbooks | `pickup`, `learn-catchup` | `.scratch/whips/<run>/log.md`, `pause.md` | dir scaffolded, files lazy |
| Decision trail | `craft-trail` | `orchestrate`, morning audit | `.scratch/whips/<run>/decisions.tsv`, or `.audit/<slug>.tsv` parallel | lazy |
| Hillclimb log | `hillclimb` | `hillclimb` | `.scratch/whips/<run>/decisions.tsv` (hillclimb per-attempt schema) | lazy |
| Feature map | `verify-new` | `verify-upkeep`, `craft-swarm` | `skills/verify-<app>/features/` | lazy |
| Workflows | `plan-worklog` | `plan-worklog` | `workflows/*.md` | lazy |
| Handoff | `learn-handoff` | next session | `$TMPDIR` (outside the repo on purpose) | lazy |
| Design tokens, standards | `/setup-repo` Section D | `learn-retro`, `guide` | root `DESIGN.md`, standards file | scaffolded on yes |

Naming rule: one convention for decision trails. Whips runs (including hillclimb) use `.scratch/whips/<run>/decisions.tsv` (plural); hillclimb keeps its own per-attempt schema inside that filename, documented in its playbook. Parallel non-whips efforts use `.audit/<slug>.tsv`. No two trails share a filename with different schemas without a note saying why.
