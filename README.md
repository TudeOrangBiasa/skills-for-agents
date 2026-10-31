# Skills for Agents

![Skills for Agents Banner](./assets/banner.jpg)
Agent skills for real engineering: small, composable, human-in-the-loop. Forked from [mattpocock/skills](https://github.com/mattpocock/skills) and reworked around a HIT flow (Have a Map, Install Guardrails, Take a Walk), a UI sub-flow for interface tickets, memorable skill names, and per-skill credits. MIT licensed; every skill carries its own `CREDITS.md`.

## Credits

Idea path (grill, spec, tickets) comes from [Matt Pocock skills](https://github.com/mattpocock/skills): relentless interviews that sharpen foggy ideas, specs synthesized without re-interviewing, tickets split with blocking edges. Execute path (one entry routing each unit through playbooks, principles as reasoning, leaf rigor for fan-out skills like swarm, ketchup, unslop) comes from [pstack](https://github.com/cursor/plugins) (`poteto-mode` and leaf skills) by [Lauren Tan ([@poteto](https://x.com/poteto))](https://github.com/poteto), MIT licensed. Both upstreams are copied in, not depended on; per-skill files stay in each skill's `CREDITS.md`.

## TL;DR

- 59 skills (28 user-invoked, 31 model-invoked, including the principles index with 24 principle files) plus 30 `/whips` playbooks: one entry routes any task, the rest fire on triggers.
- Start with `/guide` (router) or [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) (recipes with diagrams); build with `/whips`; configure a repo once with `/setup-repo`.
- Landing is mode-aware: solo repos merge after the local verifier passes, team repos after required checks pass. Risk tiers scale verification (low verifier, medium fresh-context run, high verify-blast plus adversarial review). Humans decide at triage and on irreversible actions outside the repo.
- Proof is mandatory (screenshots, video, timeline pages), prose passes `review-unslop`, changes ship with changesets.
- Big picture: [FACTORY.md](./skills/user-invoked/guide/FACTORY.md) maps how the skills work as a layered factory.

## Installation (30-second setup)

One install story. **[skills.sh](https://skills.sh/TudeOrangBiasa/skills-for-agents)** copies editable skill files into your project, so you can hack on them and make them your own. They work the same in any universal agent (Codex, pi, oh-my-pi, agy, and the rest).

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

### 2. Run `/setup-repo`

In your agent, run it once per repo. It will:

- Ask you which issue tracker you want to use (GitHub, Linear, or local files)
- Ask you what labels you apply to tickets when you triage them (`/ship-triage` uses labels)
- Ask you where you want to save any docs we create

### 3. Bam - you're ready to go.

## How work flows here

Three phases, one rule per phase: Map before Guardrails, Guardrails before Walk.

- **H (Have a Map):** `/plan-grill-docs`, `/plan-map`, `/craft-proto`, `/plan-spec`. Know the components, the data flow, and the expensive decisions first.
- **I (Install Guardrails):** `/verify-tdd` behavior tests plus negative cases. What must happen and what must never happen, implementation left free.
- **T (Take a Walk):** `/plan-tickets` splits the work small, `/whips` runs Plan then Coding then Review per ticket, `/review-code` checks behavior before style.

UI tickets run a sub-flow inside Walk: diverge (`/craft-proto` variants), guard (a11y plus content floors), stress (`/craft-break` page), review with evidence, promote one and delete the rest. Start with `/whips` and it drives this flow for you; use `/guide` when you want to pick the skill by hand.

Full grill-to-execute order with the learn-handoff contract: [stage-pipeline playbook](./skills/user-invoked/whips/playbooks/stage-pipeline.md).

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them; their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### User-invoked

Skills for daily work, fired by hand. Full list in [skills/user-invoked/](skills/user-invoked/).

- **[craft-deepen](./skills/user-invoked/craft-deepen/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then discuss through whichever one you pick.
- **[plan-grill](./skills/user-invoked/plan-grill/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[verify-new](./skills/user-invoked/verify-new/SKILL.md)**: Generate a project-local skill that drives the app like a user, with feature map, proven once.
- **[create-formal-verification](./skills/user-invoked/create-formal-verification/SKILL.md)**: Generate a project-local skill that proves a property where tests rarely reach, with coverage record and sync commit.
- **[maintain-formal-verification](./skills/user-invoked/maintain-formal-verification/SKILL.md)**: Bring property checks back in line after code changes: drift or bug verdict per check.
- **[verify-statechart](./skills/user-invoked/verify-statechart/SKILL.md)**: Check a TLA+ model and draw it as a Mermaid statechart with shortest bug paths.
- **[plan-grill-docs](./skills/user-invoked/plan-grill-docs/SKILL.md)**: Interview session that also builds your project's domain model, sharpening terminology and updating `GLOSSARY.md` and ADRs inline.
- **[learn-diff-gate](./skills/user-invoked/learn-diff-gate/SKILL.md)**: Learning gate (deprecated from the merge path 2026-10-31; execute path is `/whips` only).
- **[guide](./skills/user-invoked/guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo. Prefer reading: [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) shows every common flow as a recipe with diagrams.
- **[learn-handoff](./skills/user-invoked/learn-handoff/SKILL.md)**: Compact the conversation into a handoff doc for another session to continue.
- **[learn-catchup](./skills/user-invoked/learn-catchup/SKILL.md)**: Catch up on everything in this chat since your last message, with an executive summary for each action item.
- **[learn-catchup-video](./skills/user-invoked/learn-catchup-video/SKILL.md)**: Catch up like `/learn-catchup`, but show what happened in a short subtitled video, with action items as text under it (text fallback when the harness cannot render video).
- **[learn-recall](./skills/user-invoked/learn-recall/SKILL.md)**: Rebuild recent working context across chats into a tight capsule brief.
- **[verify-upkeep](./skills/user-invoked/verify-upkeep/SKILL.md)**: Periodic upkeep for a project's verification skill: source wave plus live pass, at most one PR.
- **[learn-retro](./skills/user-invoked/learn-retro/SKILL.md)**: Conduct a retrospective on a coding session: refresh meta docs, kill rot, surface patterns.
- **[learn-reflect](./skills/user-invoked/learn-reflect/SKILL.md)**: Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete skill edit.
- **[ship-runner](./skills/user-invoked/ship-runner/SKILL.md)**: Run `ready-for-agent` issue queues on any schedule through `/whips` intake, landing per risk tier, with the agent and model you pick at setup.
- **[setup-repo](./skills/user-invoked/setup-repo/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[setup-ts-modules](./skills/user-invoked/setup-ts-modules/SKILL.md)**: Wire dependency-cruiser into a TypeScript repo so each package is a deep module.
- **[plan-sharpen](./skills/user-invoked/plan-sharpen/SKILL.md)**: Sharpen a task, issue, or prompt before work starts: deeper, not bigger, then a rewritten prompt ready to run.
- **[learn-teach](./skills/user-invoked/learn-teach/SKILL.md)**: Teach the user a new skill or concept, within this workspace.
- **[plan-spec](./skills/user-invoked/plan-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker. No interview, just synthesizes what you've already discussed.
- **[plan-tickets](./skills/user-invoked/plan-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges.
- **[ship-triage](./skills/user-invoked/ship-triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[learn-restate](./skills/user-invoked/learn-restate/SKILL.md)**: Fire this the moment an agent message doesn't land. The agent re-pitches it visually, in plain English, using your `GLOSSARY.md` vocabulary.
- **[plan-map](./skills/user-invoked/plan-map/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way is clear.
- **[whips](./skills/user-invoked/whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed ready PR with ship-pr-shaped evidence. Also picks up `ready-for-agent` issues and sorts review comments.
- **[plan-worklog](./skills/user-invoked/plan-worklog/SKILL.md)**: Interview yourself into implementable workflow specs over multiple sessions, using the current directory as a stateful workspace.

### Model-invoked

Reusable discipline the agent reaches for on its own. Full list in [skills/model-invoked/](skills/model-invoked/).

- **[craft-architect](./skills/model-invoked/craft-architect/SKILL.md)**: Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong.
- **[craft-arena](./skills/model-invoked/craft-arena/SKILL.md)**: Parallel design bakeoff: N candidates on one brief, cross-judge, pick a base, graft the best parts.
- **[verify-bench](./skills/model-invoked/verify-bench/SKILL.md)**: Vet a perf measurement before reporting or acting on it.
- **[verify-blast](./skills/model-invoked/verify-blast/SKILL.md)**: Find what a change could break outside itself and prove the one safety fact.
- **[craft-break](./skills/model-invoked/craft-break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page, then report what visibly broke.
- **[craft-correct](./skills/model-invoked/craft-correct/SKILL.md)**: Eliminate repeated agent mistakes at the highest level that works.
- **[craft-vocab](./skills/model-invoked/craft-vocab/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[review-code](./skills/model-invoked/review-code/SKILL.md)**: Two-axis review of the diff since a fixed point: Standards and Spec.
- **[craft-diagnose](./skills/model-invoked/craft-diagnose/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions.
- **[craft-domain](./skills/model-invoked/craft-domain/SKILL.md)**: Build and sharpen a project's domain model.
- **[craft-how](./skills/model-invoked/craft-how/SKILL.md)**: Explain how a subsystem works with complexity triage and fixed output sections.
- **[review-adversary](./skills/model-invoked/review-adversary/SKILL.md)**: Adversarial multi-model review with rubric and bucketed verdict.
- **[plan-interview](./skills/model-invoked/plan-interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable plan-interview primitive behind `plan-grill`, `plan-grill-docs`, `ship-triage`, `plan-map` and `craft-deepen`.
- **[ship-merge-fix](./skills/model-invoked/ship-merge-fix/SKILL.md)**: Resolve an in-progress git merge or rebase conflict hunk by hunk, by intent.
- **[review-nocomment](./skills/model-invoked/review-nocomment/SKILL.md)**: Kill needless comments plus the dead code they protect, fix root causes, encode constraints.
- **[ship-pr](./skills/model-invoked/ship-pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence, merge danger.
- **[principles](./skills/model-invoked/principles/SKILL.md)**: Index of 24 engineering principles behind `/whips` triggers; read the file that fits before the first design decision.
- **[craft-proto](./skills/model-invoked/craft-proto/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[craft-research](./skills/model-invoked/craft-research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo.
- **[setup-hooks](./skills/model-invoked/setup-hooks/SKILL.md)**: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate.
- **[craft-trail](./skills/model-invoked/craft-trail/SKILL.md)**: Keep a reviewable TSV decision trail for long or unattended work.
- **[craft-swarm](./skills/model-invoked/craft-swarm/SKILL.md)**: Parallel worker fan-out for coverage, races, and gauntlets with one report.
- **[verify-tdd](./skills/model-invoked/verify-tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[review-prose](./skills/model-invoked/review-prose/SKILL.md)**: Write docs, RFCs, readmes, and commit messages to a layered standard.
- **[craft-ts](./skills/model-invoked/craft-ts/SKILL.md)**: TypeScript type discipline for agents editing `.ts`/`.tsx`.
- **[craft-ui-timeline](./skills/model-invoked/craft-ui-timeline/SKILL.md)**: Turn a UI screen recording into an interactive paint timeline page for motion proof.
- **[review-unslop](./skills/model-invoked/review-unslop/SKILL.md)**: Cut AI tells from prose before it ships: replies, PR bodies, commit messages, docs, skills.
- **[craft-manual](./skills/model-invoked/craft-manual/SKILL.md)**: Generate a user manual from a running web app: content-cropped screenshots, selector annotations, HTML plus PDF build with QA gates.
- **[craft-wizard](./skills/model-invoked/craft-wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
- **[craft-agent-docs](./skills/model-invoked/craft-agent-docs/SKILL.md)**: Writing documents for agents: skills, AGENTS.md, and any doc an agent reaches by a pointer.
- **[craft-why](./skills/model-invoked/craft-why/SKILL.md)**: Find why code is shaped this way with fan-out investigators and confidence tiers.

**Principles** (one rule each behind `/whips`; full list in [skills/model-invoked/](skills/model-invoked/)): [subtract](./skills/model-invoked/principles/principles/subtract-before-you-add.md), [root causes](./skills/model-invoked/principles/principles/fix-root-causes.md), [prove it](./skills/model-invoked/principles/principles/prove-it-works.md), [small units](./skills/model-invoked/principles/principles/sequence-verifiable-units.md), [domain model](./skills/model-invoked/principles/principles/model-the-domain.md), [idempotent](./skills/model-invoked/principles/principles/make-operations-idempotent.md), [behavior tests](./skills/model-invoked/principles/principles/test-behavior-not-implementation.md), [no blocking](./skills/model-invoked/principles/principles/never-block-on-the-human.md), [premise](./skills/model-invoked/principles/principles/attack-the-premise.md), [boundaries](./skills/model-invoked/principles/principles/boundary-discipline.md), [types](./skills/model-invoked/principles/principles/type-system-discipline.md), [lever](./skills/model-invoked/principles/principles/build-the-lever.md), [structure](./skills/model-invoked/principles/principles/encode-lessons-in-structure.md), [migrate](./skills/model-invoked/principles/principles/migrate-callers-then-delete-legacy-apis.md), [separate](./skills/model-invoked/principles/principles/separate-before-serializing-shared-state.md), [outcome](./skills/model-invoked/principles/principles/outcome-oriented-execution.md), [first principles](./skills/model-invoked/principles/principles/redesign-from-first-principles.md), [experience](./skills/model-invoked/principles/principles/experience-first.md), [numbers](./skills/model-invoked/principles/principles/explain-the-number.md), [context](./skills/model-invoked/principles/principles/guard-the-context-window.md), [design space](./skills/model-invoked/principles/principles/exhaust-the-design-space.md), [foundations](./skills/model-invoked/principles/principles/foundational-thinking.md), [laziness](./skills/model-invoked/principles/principles/laziness-protocol.md), [reader load](./skills/model-invoked/principles/principles/minimize-reader-load.md).

## License

MIT. Original work copyright Matt Pocock; fork copyright TudeOrangBiasa, see [LICENSE](./LICENSE). Per-skill attributions live in each skill's `CREDITS.md`.
