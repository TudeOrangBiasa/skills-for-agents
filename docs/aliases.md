# Aliases (one release)

Issue #175 renamed 53 skills to the stage-prefix scheme (`ketchup-video` rode along, making 54 moved folders). Old names keep resolving for **one release** through this table, then the aliases are deleted with no further redirect. Removal is scheduled for the release after the one carrying #175; the changelog names the version.

Consumer repos (`npx skills add` or copied skill folders) migrate by renaming their installed folders per the table below, or by re-running the installer and picking the new names. Agent prompts and docs that name an old skill keep working until the removal release; after that an old name is an unknown skill.

| Old (this release only) | New |
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

Resolution test: `bash scripts/test-aliases.sh`. It reads this table, asserts every old name is gone as a folder, every new name exists with matching frontmatter, and the old-name count is exactly 54.
