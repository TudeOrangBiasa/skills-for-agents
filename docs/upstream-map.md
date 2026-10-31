# Upstream map

Local skill names use the stage-prefix scheme (`setup-`, `plan-`, `craft-`, `ship-`, `review-`, `learn-`, `verify-`). Upstream repos keep their own names. This table maps local to upstream so sync diffs stay mechanical: find the local skill, read its upstream row, diff against that source. Per-skill detail lives in each skill's `CREDITS.md`.

| Local | Upstream (pstack / Matt) | Source |
|---|---|---|
| `craft-agent-docs` | `writing-great-skills` | mattpocock/skills |
| `craft-architect` | `architect` | pstack |
| `craft-arena` | `arena` | pstack |
| `craft-break` | `break` | jakubkrehel/skills |
| `craft-correct` | `correct` | pstack |
| `craft-deepen` | `improve-codebase-architecture` | mattpocock/skills |
| `craft-diagnose` | `diagnosing-bugs` | mattpocock/skills |
| `craft-domain` | `domain-modeling` | mattpocock/skills |
| `craft-how` | `how` | pstack |
| `craft-manual` | - (original: Linkbook case study) | - |
| `craft-proto` | `prototype` | mattpocock/skills |
| `craft-research` | `research` | mattpocock/skills |
| `craft-swarm` | `swarm` | pstack |
| `craft-trail` | `show-me-your-work` | pstack |
| `craft-ts` | `typescript-best-practices` | pstack |
| `craft-ui-timeline` | `ui-recording-timeline` | rauchg/skills |
| `craft-vocab` | `codebase-design` | mattpocock/skills |
| `craft-why` | `why` | pstack |
| `craft-wizard` | `wizard` | mattpocock/skills |
| `create-formal-verification` | `create-formal-verification-skill` | pstack |
| `guide` | `ask-matt` | mattpocock/skills |
| `learn-catchup` | `ketchup` | pstack |
| `learn-catchup-video` | `ketchup` (video shape) | pstack |
| `learn-diff-gate` | - (original) | - |
| `learn-handoff` | `handoff` | mattpocock/skills |
| `learn-recall` | `recall` | pstack |
| `learn-reflect` | `reflect` | pstack |
| `learn-restate` | `show-me` (visual catalog) | humanlayer/skills (Dex Horthy) |
| `learn-retro` | `retro` | mattpocock/skills |
| `learn-teach` | `teach` | mattpocock/skills |
| `maintain-formal-verification` | `maintain-formal-verification-skill` | pstack |
| `plan-grill` | `grill-me` | mattpocock/skills |
| `plan-grill-docs` | `grill-with-docs` | mattpocock/skills |
| `plan-interview` | `grilling` | mattpocock/skills |
| `plan-map` | `wayfinder` | mattpocock/skills |
| `plan-sharpen` | `sharpen` | pstack |
| `plan-spec` | `to-spec` | mattpocock/skills |
| `plan-tickets` | `to-tickets` | mattpocock/skills |
| `plan-worklog` | - (original) | - |
| `principles` | 24 `principle-*` leaves (folded into one index, #174) | pstack |
| `review-adversary` | `interrogate` | pstack |
| `review-code` | `code-review` | mattpocock/skills |
| `review-nocomment` | `no-comments` | pstack |
| `review-prose` | `technical-writing` | pstack |
| `review-unslop` | `unslop` | pstack |
| `setup-hooks` | `setup-pre-commit` | mattpocock/skills |
| `setup-repo` | `setup-matt-pocock-skills` | mattpocock/skills |
| `setup-ts-modules` | `setup-ts-deep-modules` | mattpocock/skills |
| `ship-merge-fix` | `resolving-merge-conflicts` | mattpocock/skills |
| `ship-pr` | `show-me` (shape) + `pr-screenshots` (attachments) | humanlayer (Dex Horthy) + github/awesome-copilot |
| `ship-runner` | - (original) | - |
| `ship-triage` | `triage` | mattpocock/skills |
| `verify-bench` | `benchmark-checklist` | pstack |
| `verify-blast` | `blast-radius` | pstack |
| `verify-new` | `create-verification-skill` | pstack |
| `verify-statechart` | `statechart` | pstack |
| `verify-tdd` | `tdd` + pstack hardening | mattpocock/skills + pstack |
| `verify-upkeep` | `maintain-verification-skill` | pstack |
| `whips` | `poteto-mode` router + playbooks | pstack |

## Rename history (#175)

Old local names redirect for one release, then the stubs are deleted. See [aliases.md](./aliases.md).

| Old | New |
|---|---|
| `architect` | `craft-architect` |
| `arena` | `craft-arena` |
| `benchmark-checklist` | `verify-bench` |
| `blast-radius` | `verify-blast` |
| `break` | `craft-break` |
| `code-review` | `review-code` |
| `codebase-design` | `craft-vocab` |
| `correct` | `craft-correct` |
| `create-verification` | `verify-new` |
| `deepen` | `craft-deepen` |
| `diagnose` | `craft-diagnose` |
| `discuss` | `plan-grill` |
| `discuss-with-docs` | `plan-grill-docs` |
| `domain-modeling` | `craft-domain` |
| `explain-diff-before-merge` | `learn-diff-gate` |
| `handoff` | `learn-handoff` |
| `how` | `craft-how` |
| `interrogate` | `review-adversary` |
| `interview` | `plan-interview` |
| `ketchup` | `learn-catchup` |
| `ketchup-video` | `learn-catchup-video` |
| `maintain-verification` | `verify-upkeep` |
| `merge-fix` | `ship-merge-fix` |
| `no-comments` | `review-nocomment` |
| `pr` | `ship-pr` |
| `prototype` | `craft-proto` |
| `recall` | `learn-recall` |
| `reflect` | `learn-reflect` |
| `research` | `craft-research` |
| `retro` | `learn-retro` |
| `runner` | `ship-runner` |
| `setup-meta` | `setup-repo` |
| `setup-pre-commit` | `setup-hooks` |
| `setup-ts-deep-modules` | `setup-ts-modules` |
| `sharpen` | `plan-sharpen` |
| `show-me-your-work` | `craft-trail` |
| `statechart` | `verify-statechart` |
| `swarm` | `craft-swarm` |
| `tdd` | `verify-tdd` |
| `teach` | `learn-teach` |
| `technical-writing` | `review-prose` |
| `to-spec` | `plan-spec` |
| `to-tickets` | `plan-tickets` |
| `triage` | `ship-triage` |
| `typescript-best-practices` | `craft-ts` |
| `ui-recording-timeline` | `craft-ui-timeline` |
| `unslop` | `review-unslop` |
| `user-manual` | `craft-manual` |
| `wait-what` | `learn-restate` |
| `wayfinder` | `plan-map` |
| `why` | `craft-why` |
| `wizard` | `craft-wizard` |
| `worklog` | `plan-worklog` |
| `writing-for-agents` | `craft-agent-docs` |
