# Skills for Agents

![Skills for Agents Banner](./assets/banner.jpg)
Agent skills for real engineering: small, composable, human-in-the-loop. Forked from [mattpocock/skills](https://github.com/mattpocock/skills) and reworked around a HIT flow (Have a Map, Install Guardrails, Take a Walk), a UI sub-flow for interface tickets, memorable skill names, and per-skill credits. MIT licensed; every skill carries its own `CREDITS.md`.

## Credits

Idea path (grill, spec, tickets) comes from [Matt Pocock skills](https://github.com/mattpocock/skills): relentless interviews that sharpen foggy ideas, specs synthesized without re-interviewing, tickets split with blocking edges. Execute path (one entry routing each unit through playbooks, principles as reasoning, leaf rigor for skills like learn-catchup, review-unslop) comes from [pstack](https://github.com/cursor/plugins) (`poteto-mode` and leaf skills) by [Lauren Tan ([@poteto](https://x.com/poteto))](https://github.com/poteto), MIT licensed. Both upstreams are copied in, not depended on; per-skill files stay in each skill's `CREDITS.md`.

## TL;DR

- 26 skills (11 user-invoked, 15 model-invoked including the principles index) plus 35 `/whips` playbooks: one entry routes any task, the rest fire on triggers.
- Start with `/guide` (router) or [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) (recipes with diagrams); build with `/whips`; configure a repo once with `/setup-repo`.
- Landing is mode-aware: solo repos merge after the local verifier passes, team repos after required checks pass. Risk tiers scale verification (low verifier, medium fresh-context run, high verify-blast plus an empirical rerun). Humans decide at triage and on irreversible actions outside the repo.
- Proof is mandatory (screenshots, video, timeline pages), prose passes `review-unslop`, changes ship with changesets.
- Big picture: [FACTORY.md](./skills/user-invoked/guide/FACTORY.md) maps how the skills work as a layered factory.

## Installation (30-second setup)

One install story. **[skills.sh](https://skills.sh/TudeOrangBiasa/skills-for-agents)** copies editable skill files into your project, so you can hack on them and make them your own. They work the same in any agent that loads SKILL.md folders (for example Codex, pi, oh-my-pi, or agy).

### 1. Get the skills

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take, so make sure `setup-repo` is one of them.**

For a single skill:

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents --skill=<name>
```

It writes the skills into your repo as ordinary files you own and can edit. Nothing updates behind your back; pull the latest changes when you want them with `npx skills update`.

Renamed skills keep working through [docs/aliases.md](./docs/aliases.md) for one release; [docs/upstream-map.md](./docs/upstream-map.md) maps every skill to its upstream source.

### 2. Run `/setup-repo`

In your agent, run it once per repo. It will:

- Ask you which issue tracker you want to use (GitHub, Linear, or local files)
- Ask you what labels you apply to tickets when you triage them (`/whips` triage uses labels)
- Ask you where you want to save any docs we create

### 3. Bam - you're ready to go.

## How work flows here

Three phases, one rule per phase: Map before Guardrails, Guardrails before Walk.

- **H (Have a Map):** `plan-interview`. Know the components, the data flow, and the expensive decisions first. Prototype inside `/whips` when running code can answer.
- **I (Install Guardrails):** `/verify-tdd` behavior tests plus negative cases. What must happen and what must never happen, implementation left free.
- **T (Take a Walk):** `/whips` splits the work small and runs Plan then Coding then proof per ticket; verifier evidence decides done, never a read-only review.

UI tickets run a sub-flow inside Walk: diverge (prototype variants), guard (a11y plus content floors), stress (`/craft-break` page), review with evidence, promote one and delete the rest. Start with `/whips` and it drives this flow for you; use `/guide` when you want to pick the skill by hand.

Full grill-to-execute order with the handoff contract: [stage-pipeline playbook](./skills/user-invoked/whips/playbooks/stage-pipeline.md).

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them; their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### User-invoked

Skills for daily work, fired by hand. Full list in [skills/user-invoked/](skills/user-invoked/).

- **[create-formal-verification](./skills/user-invoked/create-formal-verification/SKILL.md)**: Generate a project-local skill that proves a property where tests rarely reach, with coverage record and sync commit.
- **[maintain-formal-verification](./skills/user-invoked/maintain-formal-verification/SKILL.md)**: Bring property checks back in line after code changes: drift or bug verdict per check.
- **[guide](./skills/user-invoked/guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo. Prefer reading: [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) shows every common flow as a recipe with diagrams.
- **[learn-catchup](./skills/user-invoked/learn-catchup/SKILL.md)**: Catch up on everything in this chat since your last message, with an executive summary for each action item.
- **[learn-diff-gate](./skills/user-invoked/learn-diff-gate/SKILL.md)**: Prove you understand a change: explain the diff yourself, survive correction plus three why questions.
- **[learn-recall](./skills/user-invoked/learn-recall/SKILL.md)**: Rebuild recent working context across chats into a tight capsule brief.
- **[learn-reflect](./skills/user-invoked/learn-reflect/SKILL.md)**: Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete skill edit or a docs update (taste, standards, glossary).
- **[setup-repo](./skills/user-invoked/setup-repo/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[learn-restate](./skills/user-invoked/learn-restate/SKILL.md)**: Fire this the moment an agent message doesn't land. The agent re-pitches it visually, in plain English, using your `GLOSSARY.md` vocabulary.
- **[report-issue](./skills/user-invoked/report-issue/SKILL.md)**: File a bug, feature, or deprecation ticket from a quick notice, with repro and acceptance.
- **[whips](./skills/user-invoked/whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed ready PR with ship-pr-shaped evidence. Also picks up `ready-for-agent` issues and sorts review comments.

### Model-invoked

Reusable discipline the agent reaches for on its own. Full list in [skills/model-invoked/](skills/model-invoked/).

- **[craft-architect](./skills/model-invoked/craft-architect/SKILL.md)**: Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong.
- **[verify-blast](./skills/model-invoked/verify-blast/SKILL.md)**: Find what a change could break outside itself and prove the one safety fact.
- **[craft-break](./skills/model-invoked/craft-break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page, then report what visibly broke.
- **[plan-interview](./skills/model-invoked/plan-interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable primitive for sharpening foggy work and ripening tickets.
- **[ship-merge-fix](./skills/model-invoked/ship-merge-fix/SKILL.md)**: Resolve an in-progress git merge or rebase conflict hunk by hunk, by intent.
- **[review-nocomment](./skills/model-invoked/review-nocomment/SKILL.md)**: Kill needless comments plus the dead code they protect, fix root causes, encode constraints.
- **[ship-pr](./skills/model-invoked/ship-pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence, merge danger.
- **[principles](./skills/model-invoked/principles/SKILL.md)**: Index of 24 engineering principles behind `/whips` triggers; read the file that fits before the first design decision.
- **[setup-hooks](./skills/model-invoked/setup-hooks/SKILL.md)**: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate.
- **[craft-trail](./skills/model-invoked/craft-trail/SKILL.md)**: Keep a reviewable TSV decision trail for long or unattended work.
- **[verify-tdd](./skills/model-invoked/verify-tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[review-prose](./skills/model-invoked/review-prose/SKILL.md)**: Write docs, RFCs, readmes, and commit messages to a layered standard.
- **[craft-ts](./skills/model-invoked/craft-ts/SKILL.md)**: TypeScript type discipline for agents editing `.ts`/`.tsx`.
- **[review-unslop](./skills/model-invoked/review-unslop/SKILL.md)**: Cut AI tells from prose before it ships: replies, PR bodies, commit messages, docs, skills.

**Principles** (one rule each behind `/whips`; full list in [skills/model-invoked/](skills/model-invoked/)): [subtract](./skills/model-invoked/principles/principles/subtract-before-you-add.md), [root causes](./skills/model-invoked/principles/principles/fix-root-causes.md), [prove it](./skills/model-invoked/principles/principles/prove-it-works.md), [small units](./skills/model-invoked/principles/principles/sequence-verifiable-units.md), [domain model](./skills/model-invoked/principles/principles/model-the-domain.md), [idempotent](./skills/model-invoked/principles/principles/make-operations-idempotent.md), [behavior tests](./skills/model-invoked/principles/principles/test-behavior-not-implementation.md), [no blocking](./skills/model-invoked/principles/principles/never-block-on-the-human.md), [premise](./skills/model-invoked/principles/principles/attack-the-premise.md), [boundaries](./skills/model-invoked/principles/principles/boundary-discipline.md), [types](./skills/model-invoked/principles/principles/type-system-discipline.md), [lever](./skills/model-invoked/principles/principles/build-the-lever.md), [structure](./skills/model-invoked/principles/principles/encode-lessons-in-structure.md), [migrate](./skills/model-invoked/principles/principles/migrate-callers-then-delete-legacy-apis.md), [separate](./skills/model-invoked/principles/principles/separate-before-serializing-shared-state.md), [outcome](./skills/model-invoked/principles/principles/outcome-oriented-execution.md), [first principles](./skills/model-invoked/principles/principles/redesign-from-first-principles.md), [experience](./skills/model-invoked/principles/principles/experience-first.md), [numbers](./skills/model-invoked/principles/principles/explain-the-number.md), [context](./skills/model-invoked/principles/principles/guard-the-context-window.md), [design space](./skills/model-invoked/principles/principles/exhaust-the-design-space.md), [foundations](./skills/model-invoked/principles/principles/foundational-thinking.md), [laziness](./skills/model-invoked/principles/principles/laziness-protocol.md), [reader load](./skills/model-invoked/principles/principles/minimize-reader-load.md).

## License

MIT. Original work copyright Matt Pocock; fork copyright TudeOrangBiasa, see [LICENSE](./LICENSE). Per-skill attributions live in each skill's `CREDITS.md`.
