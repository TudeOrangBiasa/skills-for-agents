# Playbook: stage pipeline (grill to execute)

One pipeline from foggy idea to merged PR. Matt skills grill the idea; `/whips` executes it. No stage builds ahead of its handoff; each stage hands written artifacts to the next so the builder never guesses.

Philosophy: sharpening is a conversation, shipping is a run. Grill skills (`discuss`, `discuss-with-docs`, `interview`, `sharpen`, `deepen`, `wayfinder`, `to-spec`, `to-tickets`) fight fog: they interview, map, and slice until the work is sayable. Then `/whips` runs it: one entry matches a playbook, drives skills plus subagents, and lands a reviewed ready PR. Execute is `/whips` only; the Matt execute path is deprecated (see #96). Whips itself is pstack pure (see [CREDITS.md](../CREDITS.md)).

## Stages: when to move

| Stage | You type | Start when | Move on when |
| --- | --- | --- | --- |
| 1. Grill | `/discuss-with-docs` (or `/discuss` stateless), `/sharpen` on a brief, `/deepen` on a seam, `/prototype` when running code can answer | Idea has fog: branches undecided, terms loose | Map (components, data flow, expensive decisions) agreed; guardrails listed (must happen, must never happen, key failures) |
| 2. Map (foggy efforts only) | `/wayfinder`, then `/to-spec` collapse, then `/to-tickets` | Way not visible in one session | Map cleared: destination visible, decisions recorded |
| 3. Spec | `/to-spec` | Decisions agreed | Spec published on the tracker: problem, solution, stories, decisions, testing, out of scope |
| 4. Tickets | `/to-tickets` | Spec exists | Tracer-bullet tickets with blocking edges published and user-approved |
| 5. Execute | `/whips` per ticket, blockers-first, fresh context between tickets | A ticket brief is sufficient (type, `Kompleksitas`, testable acceptance, still matches code) | Ready PR with proof per `opening-a-pr.md` |
| 6. Review and merge | ready-check, then landing per RISK | PR green | Verdict plus risk label; land per tier |

Shortcuts: thin fog skips stage 2 and the session hops (drive-through inside `/whips`: interview, spec sketch, tickets inline). Small obvious work skips to stage 5 or answers directly. Never shortcut the collapse: map straight to code throws the linked detail away.

## Stop conditions (every stage)

- Human gate: a step naming a user-invoked skill never fires from inside `/whips`. Tell the user to run it and wait at that step.
- Insufficient brief: missing type, missing `Kompleksitas`, no testable acceptance, or drifted from code. Post needs-info notes and stop; never implement from a guess.
- Fog thicker than the stage: step back one stage. A spec over fog freezes the fog; tickets over dispute ship the dispute.
- Pause list: merge above risk authority, force-push on shared branches, deploy, delete data, secrets or production config, closing issues, messaging outside the repo, `ask` threads, product calls no experiment can settle. Keep building everything else meanwhile.

## Handoff contract

Paths honor [docs-layout](../../setup-meta/docs-layout.md). Tracker means the tracker `/setup-meta` configured; local repos use the file shapes in parentheses.

| Artifact | Created by | Read by | Canonical path | Minimal format |
| --- | --- | --- | --- | --- |
| Map | `/wayfinder` | `/to-spec`, humans | Tracker issue labeled `wayfinder:map` | Destination, Notes, Decisions-so-far index, Not-yet-specified, Out-of-scope |
| Spec | `/to-spec` | `/to-tickets`, whips, triage | Tracker issue (or `.scratch/<feature>/spec.md` local) | Problem, solution, user stories, implementation decisions, testing decisions, out of scope |
| Ticket list | `/to-tickets` | whips, runner | Tracker issues with blocking edges (or `.scratch/<feature-slug>/issues/NN-slug.md` files) | Type, `Kompleksitas`, what to build, blocked-by, acceptance checkboxes, `ready-for-agent` |
| ADR | `discuss-with-docs`, `domain-modeling` | `to-spec`, `deepen`, `retro` | `docs/adr/NNNN-slug.md` | Decision, context, options, consequences |
| Glossary terms | `discuss-with-docs`, `domain-modeling`, `deepen` | Many skills | `GLOSSARY.md` | Term, definition, usage |
| Research findings | `/research` | Humans, `/discuss-with-docs` | `docs/research/<slug>.md` | Question, sources, cited findings |
| Decision trail | `show-me-your-work` | `orchestrate`, morning audit | `.scratch/whips/<run>/decisions.tsv` | Timestamped decisions plus evidence |
| Acceptance proof | whips playbooks | `code-review`, ready-check, merger | PR body per `pr` skill plus `opening-a-pr.md` | Summary visual, before/after evidence, merge danger, risk label |

Acceptance criteria live inside the spec and each ticket as testable checkboxes; whips verifies them on the matching surface and reports VERIFIED, NOT VERIFIED, or INCONCLUSIVE.

## Cross-links

- Credits (#97): idea path from [Matt Pocock skills](https://github.com/mattpocock/skills), execute path from [pstack](https://github.com/cursor/plugins) `poteto-mode` by Lauren Tan; root README Credits plus [whips CREDITS](../CREDITS.md) carry the split.
- Deprecated (#96): `/explain-diff-before-merge` is off the merge path (see [guide](../../guide/SKILL.md)) and Matt execute skills stay unshipped; when the work needs building, the answer is `/whips`.
