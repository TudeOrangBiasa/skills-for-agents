# Upstream map

Local skill names use the stage-prefix scheme (`setup-`, `plan-`, `craft-`, `ship-`, `review-`, `learn-`, `verify-`). Upstream repos keep their own names. This table maps local to upstream so sync diffs stay mechanical: find the local skill, read its upstream row, diff against that source. Per-skill detail lives in each skill's `CREDITS.md`.

## Upstream policy: pstack owns automation, Matt owns planning

Two upstreams, two jobs. **pstack (poteto)** owns automation and shipping: PRs, commits, the verifier, workflow loops, swarm, orchestration, and landing. That covers `whips`, `ship-runner`, `ship-pr` behavior, `craft-swarm`, the `verify-*` skills where pstack is the source, and the related playbooks. **Matt Pocock** owns ideas and planning only: `plan-grill`, `plan-grill-docs`, `plan-interview`, `plan-spec`, `plan-tickets`, and `plan-map` (the wayfinder for foggy work).

When a skill's behavior and its credited upstream disagree, keep the credit row as the historical record and point the behavior at the owning side. The Audit section below tracks each case with a proposed fix per row: keep credit, change behavior pointer, or replace upstream.

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

## Audit (2026-10-31): rows reviewed against the policy

Each row below names the mismatch against the policy above and the proposed fix. Follow-up behavior migrations are separate tickets; this PR changes docs pointers only. Seed list from #191.

### Matt-sourced but shipping or automation-shaped

| Local | Credit today | Proposed fix |
|---|---|---|
| `setup-repo` | mattpocock/skills | Change behavior pointer to pstack-style setup (keep credit): setup configures tracker, labels, docs, autonomy, and jobs. |
| `setup-hooks` | mattpocock/skills | Change behavior pointer to verifier loop ownership (keep credit): hooks gate commits in the shipping loop. |
| `ship-triage` | mattpocock/skills | Replace upstream with pstack-side triage behavior (keep credit note): triage feeds the runner queue. |
| `ship-merge-fix` | mattpocock/skills | Change behavior pointer to pstack landing behavior (keep credit): conflict resolution lands PRs. |
| `review-code` | mattpocock/skills | Change behavior pointer to whips review flow (keep credit): two-axis review runs inside the shipping loop. |
| `verify-tdd` (parts) | mattpocock/skills + pstack | Keep credit, confirm pstack hardening owns the red-green loop pointer. |

### Matt-sourced craft and learn skills outside the planning five

| Local | Credit today | Proposed fix |
|---|---|---|
| `craft-deepen` | mattpocock/skills | Keep credit; behavior already local (deep-module maintenance cadence). |
| `craft-diagnose` | mattpocock/skills | Keep credit; behavior already local (tight feedback loop for hard bugs). |
| `craft-domain` | mattpocock/skills | Keep credit; behavior already local (glossary vocabulary). |
| `craft-proto` | mattpocock/skills | Keep credit; behavior already local (throwaway prototype answers one question). |
| `craft-research` | mattpocock/skills | Keep credit; behavior already local (research before editing). |
| `craft-vocab` | mattpocock/skills | Keep credit; behavior already local (seam vocabulary design). |
| `craft-wizard` | mattpocock/skills | Keep credit; behavior already local (human-gated deploy walkthrough). |
| `craft-agent-docs` | mattpocock/skills | Keep credit; behavior already local (skill authoring mechanics). |
| `guide` | mattpocock/skills | Replace upstream with original router (keep credit note): the router serves the whole skill set, not one planning source. |
| `learn-handoff` | mattpocock/skills | Keep credit; behavior already local (portable notes at phase boundaries). |
| `learn-retro` | mattpocock/skills | Keep credit; behavior already local (blame-free retro). |
| `learn-teach` | mattpocock/skills | Keep credit; behavior already local (teach-back directory builds). |

### pstack-sourced planning-adjacent

| Local | Credit today | Proposed fix |
|---|---|---|
| `plan-sharpen` | pstack | Keep as pstack unless the audit says otherwise: sharpening a brief is execution-adjacent, and no Matt planning row claims it. |


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
