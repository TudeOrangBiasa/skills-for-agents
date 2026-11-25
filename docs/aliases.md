# Aliases (one release)

Issue #175 renamed 53 skills to the stage-prefix scheme (`ketchup-video` rode along, making 54 moved folders). The #221 trim batch (11 old names) drops its rows with the deleted skills; the whips-first trim drops 14 more rows with its deleted skills, plus 9 model rows with the folded skills; 20 rows remain. Old names keep resolving for **one release** through this table, then the aliases are deleted with no further redirect. Removal is scheduled for the release after the one carrying #175; the changelog names the version.

Consumer repos (`npx skills add` or copied skill folders) migrate by renaming their installed folders per the table below, or by re-running the installer and picking the new names. Agent prompts and docs that name an old skill keep working until the removal release; after that an old name is an unknown skill.

| Old (this release only) | New |
|---|---|
| `architect` | `craft-architect` |
| `blast-radius` | `verify-blast` |
| `break` | `craft-break` |
| `explain-diff-before-merge` | `learn-diff-gate` |
| `interview` | `plan-interview` |
| `ketchup` | `learn-catchup` |
| `merge-fix` | `ship-merge-fix` |
| `no-comments` | `review-nocomment` |
| `pr` | `ship-pr` |
| `recall` | `learn-recall` |
| `reflect` | `learn-reflect` |
| `setup-meta` | `setup-repo` |
| `setup-pre-commit` | `setup-hooks` |
| `show-me-your-work` | `craft-trail` |
| `tdd` | `verify-tdd` |
| `technical-writing` | `review-prose` |
| `typescript-best-practices` | `craft-ts` |
| `unslop` | `review-unslop` |
| `wait-what` | `learn-restate` |
| `writing-for-agents` | `craft-agent-docs` |

Resolution test: `bash scripts/test-aliases.sh`. It reads this table, asserts every old name is gone as a folder, every new name exists with matching frontmatter, and the old-name count is exactly 20.
