# Skills for Agents

![Skills for Agents Banner](./assets/banner.jpg)
Agent skills for real engineering: small, composable, human-in-the-loop. Forked from [mattpocock/skills](https://github.com/mattpocock/skills) and reworked around a HIT flow (Have a Map, Install Guardrails, Take a Walk), a UI sub-flow for interface tickets, memorable skill names, and per-skill credits. MIT licensed; every skill carries its own `CREDITS.md`.

## Credits

Idea path (grill, spec, tickets) comes from [Matt Pocock skills](https://github.com/mattpocock/skills): relentless interviews that sharpen foggy ideas, specs synthesized without re-interviewing, tickets split with blocking edges. Execute path (one entry routing each unit through playbooks, principles as reasoning, leaf rigor for fan-out skills like swarm, ketchup, unslop) comes from [pstack](https://github.com/cursor/plugins) (`poteto-mode` and leaf skills) by [Lauren Tan ([@poteto](https://x.com/poteto))](https://github.com/poteto), MIT licensed. Both upstreams are copied in, not depended on; per-skill files stay in each skill's `CREDITS.md`.

## TL;DR

- 84 skills (30 user-invoked, 54 model-invoked, including 24 principle leaves) plus 30 `/whips` playbooks: one entry routes any task, the rest fire on triggers.
- Start with `/guide` (router) or [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) (recipes with diagrams); build with `/whips`; configure a repo once with `/setup-meta`.
- Landing is mode-aware: solo repos merge after the local verifier passes, team repos after required checks pass. Risk tiers scale verification (low verifier, medium fresh-context run, high blast-radius plus adversarial review). Humans decide at triage and on irreversible actions outside the repo.
- Proof is mandatory (screenshots, video, timeline pages), prose passes `unslop`, changes ship with changesets.
- Big picture: [FACTORY.md](./skills/user-invoked/guide/FACTORY.md) maps how the skills work as a layered factory.

## Installation (30-second setup)

One install story. **[skills.sh](https://skills.sh/TudeOrangBiasa/skills-for-agents)** copies editable skill files into your project, so you can hack on them and make them your own. They work the same in any universal agent (Codex, pi, oh-my-pi, agy, and the rest).

### 1. Get the skills

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take, so make sure `setup-meta` is one of them.**

For a single skill:

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents --skill=<name>
```

It writes the skills into your repo as ordinary files you own and can edit. Nothing updates behind your back; pull the latest changes when you want them with `npx skills update`.

### 2. Run `/setup-meta`

In your agent, run it once per repo. It will:

- Ask you which issue tracker you want to use (GitHub, Linear, or local files)
- Ask you what labels you apply to tickets when you triage them (`/triage` uses labels)
- Ask you where you want to save any docs we create

### 3. Bam - you're ready to go.

## How work flows here

Three phases, one rule per phase: Map before Guardrails, Guardrails before Walk.

- **H (Have a Map):** `/discuss-with-docs`, `/wayfinder`, `/prototype`, `/to-spec`. Know the components, the data flow, and the expensive decisions first.
- **I (Install Guardrails):** `/tdd` behavior tests plus negative cases. What must happen and what must never happen, implementation left free.
- **T (Take a Walk):** `/to-tickets` splits the work small, `/whips` runs Plan then Coding then Review per ticket, `/code-review` checks behavior before style.

UI tickets run a sub-flow inside Walk: diverge (`/prototype` variants), guard (a11y plus content floors), stress (`/break` page), review with evidence, promote one and delete the rest. Start with `/whips` and it drives this flow for you; use `/guide` when you want to pick the skill by hand.

Full grill-to-execute order with the handoff contract: [stage-pipeline playbook](./skills/user-invoked/whips/playbooks/stage-pipeline.md).

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them; their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### User-invoked

Skills for daily work, fired by hand. Full list in [skills/user-invoked/](skills/user-invoked/).

- **[deepen](./skills/user-invoked/deepen/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then discuss through whichever one you pick.
- **[discuss](./skills/user-invoked/discuss/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[create-verification](./skills/user-invoked/create-verification/SKILL.md)**: Generate a project-local skill that drives the app like a user, with feature map, proven once.
- **[create-formal-verification](./skills/user-invoked/create-formal-verification/SKILL.md)**: Generate a project-local skill that proves a property where tests rarely reach, with coverage record and sync commit.
- **[maintain-formal-verification](./skills/user-invoked/maintain-formal-verification/SKILL.md)**: Bring property checks back in line after code changes: drift or bug verdict per check.
- **[statechart](./skills/user-invoked/statechart/SKILL.md)**: Check a TLA+ model and draw it as a Mermaid statechart with shortest bug paths.
- **[discuss-with-docs](./skills/user-invoked/discuss-with-docs/SKILL.md)**: Interview session that also builds your project's domain model, sharpening terminology and updating `GLOSSARY.md` and ADRs inline.
- **[explain-diff-before-merge](./skills/user-invoked/explain-diff-before-merge/SKILL.md)**: Learning gate (deprecated from the merge path 2026-10-31; execute path is `/whips` only).
- **[guide](./skills/user-invoked/guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo. Prefer reading: [COOKBOOK.md](./skills/user-invoked/guide/COOKBOOK.md) shows every common flow as a recipe with diagrams.
- **[handoff](./skills/user-invoked/handoff/SKILL.md)**: Compact the conversation into a handoff doc for another session to continue.
- **[ketchup](./skills/user-invoked/ketchup/SKILL.md)**: Catch up on everything in this chat since your last message, with an executive summary for each action item.
- **[ketchup-video](./skills/user-invoked/ketchup-video/SKILL.md)**: Catch up like `/ketchup`, but show what happened in a short subtitled video, with action items as text under it (text fallback when the harness cannot render video).
- **[recall](./skills/user-invoked/recall/SKILL.md)**: Rebuild recent working context across chats into a tight capsule brief.
- **[maintain-verification](./skills/user-invoked/maintain-verification/SKILL.md)**: Periodic upkeep for a project's verification skill: source wave plus live pass, at most one PR.
- **[retro](./skills/user-invoked/retro/SKILL.md)**: Conduct a retrospective on a coding session: refresh meta docs, kill rot, surface patterns.
- **[reflect](./skills/user-invoked/reflect/SKILL.md)**: Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete skill edit.
- **[runner](./skills/user-invoked/runner/SKILL.md)**: Run `ready-for-agent` issue queues on any schedule through `/whips` intake, landing per risk tier, with the agent and model you pick at setup.
- **[setup-meta](./skills/user-invoked/setup-meta/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[setup-ts-deep-modules](./skills/user-invoked/setup-ts-deep-modules/SKILL.md)**: Wire dependency-cruiser into a TypeScript repo so each package is a deep module.
- **[sharpen](./skills/user-invoked/sharpen/SKILL.md)**: Sharpen a task, issue, or prompt before work starts: deeper, not bigger, then a rewritten prompt ready to run.
- **[teach](./skills/user-invoked/teach/SKILL.md)**: Teach the user a new skill or concept, within this workspace.
- **[to-spec](./skills/user-invoked/to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker. No interview, just synthesizes what you've already discussed.
- **[to-tickets](./skills/user-invoked/to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges.
- **[triage](./skills/user-invoked/triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[wait-what](./skills/user-invoked/wait-what/SKILL.md)**: Fire this the moment an agent message doesn't land. The agent re-pitches it visually, in plain English, using your `GLOSSARY.md` vocabulary.
- **[wayfinder](./skills/user-invoked/wayfinder/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way is clear.
- **[whips](./skills/user-invoked/whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed ready PR with pr-shaped evidence. Also picks up `ready-for-agent` issues and sorts review comments.
- **[worklog](./skills/user-invoked/worklog/SKILL.md)**: Interview yourself into implementable workflow specs over multiple sessions, using the current directory as a stateful workspace.

### Model-invoked

Reusable discipline the agent reaches for on its own. Full list in [skills/model-invoked/](skills/model-invoked/).

- **[architect](./skills/model-invoked/architect/SKILL.md)**: Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong.
- **[arena](./skills/model-invoked/arena/SKILL.md)**: Parallel design bakeoff: N candidates on one brief, cross-judge, pick a base, graft the best parts.
- **[benchmark-checklist](./skills/model-invoked/benchmark-checklist/SKILL.md)**: Vet a perf measurement before reporting or acting on it.
- **[blast-radius](./skills/model-invoked/blast-radius/SKILL.md)**: Find what a change could break outside itself and prove the one safety fact.
- **[break](./skills/model-invoked/break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page, then report what visibly broke.
- **[correct](./skills/model-invoked/correct/SKILL.md)**: Eliminate repeated agent mistakes at the highest level that works.
- **[codebase-design](./skills/model-invoked/codebase-design/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[code-review](./skills/model-invoked/code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: Standards and Spec.
- **[diagnose](./skills/model-invoked/diagnose/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./skills/model-invoked/domain-modeling/SKILL.md)**: Build and sharpen a project's domain model.
- **[how](./skills/model-invoked/how/SKILL.md)**: Explain how a subsystem works with complexity triage and fixed output sections.
- **[interrogate](./skills/model-invoked/interrogate/SKILL.md)**: Adversarial multi-model review with rubric and bucketed verdict.
- **[interview](./skills/model-invoked/interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable interview primitive behind `discuss`, `discuss-with-docs`, `triage`, `wayfinder` and `deepen`.
- **[merge-fix](./skills/model-invoked/merge-fix/SKILL.md)**: Resolve an in-progress git merge or rebase conflict hunk by hunk, by intent.
- **[no-comments](./skills/model-invoked/no-comments/SKILL.md)**: Kill needless comments plus the dead code they protect, fix root causes, encode constraints.
- **[pr](./skills/model-invoked/pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence, merge danger.
- **[prototype](./skills/model-invoked/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[research](./skills/model-invoked/research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo.
- **[setup-pre-commit](./skills/model-invoked/setup-pre-commit/SKILL.md)**: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate.
- **[show-me-your-work](./skills/model-invoked/show-me-your-work/SKILL.md)**: Keep a reviewable TSV decision trail for long or unattended work.
- **[swarm](./skills/model-invoked/swarm/SKILL.md)**: Parallel worker fan-out for coverage, races, and gauntlets with one report.
- **[tdd](./skills/model-invoked/tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[technical-writing](./skills/model-invoked/technical-writing/SKILL.md)**: Write docs, RFCs, readmes, and commit messages to a layered standard.
- **[typescript-best-practices](./skills/model-invoked/typescript-best-practices/SKILL.md)**: TypeScript type discipline for agents editing `.ts`/`.tsx`.
- **[ui-recording-timeline](./skills/model-invoked/ui-recording-timeline/SKILL.md)**: Turn a UI screen recording into an interactive paint timeline page for motion proof.
- **[unslop](./skills/model-invoked/unslop/SKILL.md)**: Cut AI tells from prose before it ships: replies, PR bodies, commit messages, docs, skills.
- **[user-manual](./skills/model-invoked/user-manual/SKILL.md)**: Generate a user manual from a running web app: content-cropped screenshots, selector annotations, HTML plus PDF build with QA gates.
- **[wizard](./skills/model-invoked/wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
- **[writing-for-agents](./skills/model-invoked/writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md, and any doc an agent reaches by a pointer.
- **[why](./skills/model-invoked/why/SKILL.md)**: Find why code is shaped this way with fan-out investigators and confidence tiers.

**Principles** (one rule each behind `/whips`; full list in [skills/model-invoked/](skills/model-invoked/)): [subtract](./skills/model-invoked/principle-subtract-before-you-add/SKILL.md), [root causes](./skills/model-invoked/principle-fix-root-causes/SKILL.md), [prove it](./skills/model-invoked/principle-prove-it-works/SKILL.md), [small units](./skills/model-invoked/principle-sequence-verifiable-units/SKILL.md), [domain model](./skills/model-invoked/principle-model-the-domain/SKILL.md), [idempotent](./skills/model-invoked/principle-make-operations-idempotent/SKILL.md), [behavior tests](./skills/model-invoked/principle-test-behavior-not-implementation/SKILL.md), [no blocking](./skills/model-invoked/principle-never-block-on-the-human/SKILL.md), [premise](./skills/model-invoked/principle-attack-the-premise/SKILL.md), [boundaries](./skills/model-invoked/principle-boundary-discipline/SKILL.md), [types](./skills/model-invoked/principle-type-system-discipline/SKILL.md), [lever](./skills/model-invoked/principle-build-the-lever/SKILL.md), [structure](./skills/model-invoked/principle-encode-lessons-in-structure/SKILL.md), [migrate](./skills/model-invoked/principle-migrate-callers-then-delete-legacy-apis/SKILL.md), [separate](./skills/model-invoked/principle-separate-before-serializing-shared-state/SKILL.md), [outcome](./skills/model-invoked/principle-outcome-oriented-execution/SKILL.md), [first principles](./skills/model-invoked/principle-redesign-from-first-principles/SKILL.md), [experience](./skills/model-invoked/principle-experience-first/SKILL.md), [numbers](./skills/model-invoked/principle-explain-the-number/SKILL.md), [context](./skills/model-invoked/principle-guard-the-context-window/SKILL.md), [design space](./skills/model-invoked/principle-exhaust-the-design-space/SKILL.md), [foundations](./skills/model-invoked/principle-foundational-thinking/SKILL.md), [laziness](./skills/model-invoked/principle-laziness-protocol/SKILL.md), [reader load](./skills/model-invoked/principle-minimize-reader-load/SKILL.md).

## License

MIT. Original work copyright Matt Pocock; fork copyright TudeOrangBiasa, see [LICENSE](./LICENSE). Per-skill attributions live in each skill's `CREDITS.md`.
