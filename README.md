# Skills for Agents

![Skills for Agents Banner](./assets/banner.jpg)

Agent skills for real engineering: small, composable, human-in-the-loop. Forked from [mattpocock/skills](https://github.com/mattpocock/skills) and reworked around a HIT flow (Have a Map, Install Guardrails, Take a Walk), a UI sub-flow for interface tickets, memorable skill names, and per-skill credits. MIT licensed; every skill carries its own `CREDITS.md`.

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
- **T (Take a Walk):** `/to-tickets` splits the work small, `/implement` runs Plan then Coding then Review per ticket, `/code-review` checks behavior before style.

UI tickets run a sub-flow inside Walk: diverge (`/prototype` variants), guard (a11y plus content floors), stress (`/break` page), review with evidence, promote one and delete the rest. Start at `/guide` whenever you don't know which skill fits.

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them; their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### User-invoked

Skills for daily work, fired by hand. Full list in [skills/user-invoked/](skills/user-invoked/).

- **[break](./skills/user-invoked/break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page, then report what visibly broke.
- **[deepen](./skills/user-invoked/deepen/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then discuss through whichever one you pick.
- **[discuss](./skills/user-invoked/discuss/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[discuss-with-docs](./skills/user-invoked/discuss-with-docs/SKILL.md)**: Interview session that also builds your project's domain model, sharpening terminology and updating `GLOSSARY.md` and ADRs inline.
- **[guide](./skills/user-invoked/guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo.
- **[implement](./skills/user-invoked/implement/SKILL.md)**: Implement from a spec or tickets, test-first with before/after proof per slice, closing with mandatory review and a `pr`-shaped PR body.
- **[retro](./skills/user-invoked/retro/SKILL.md)**: Conduct a retrospective on a coding session: refresh meta docs, kill rot, surface patterns.
- **[setup-meta](./skills/user-invoked/setup-meta/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[setup-ts-deep-modules](./skills/user-invoked/setup-ts-deep-modules/SKILL.md)**: Wire dependency-cruiser into a TypeScript repo so each package is a deep module.
- **[teach](./skills/user-invoked/teach/SKILL.md)**: Teach the user a new skill or concept, within this workspace.
- **[to-spec](./skills/user-invoked/to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker. No interview, just synthesizes what you've already discussed.
- **[to-tickets](./skills/user-invoked/to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges.
- **[triage](./skills/user-invoked/triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[wait-what](./skills/user-invoked/wait-what/SKILL.md)**: Fire this the moment an agent message doesn't land. The agent re-pitches it visually, in plain English, using your `GLOSSARY.md` vocabulary.
- **[wayfinder](./skills/user-invoked/wayfinder/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way is clear.
- **[whips](./skills/user-invoked/whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, land a reviewed diff with pr-shaped evidence.
- **[worklog](./skills/user-invoked/worklog/SKILL.md)**: Interview yourself into implementable workflow specs over multiple sessions, using the current directory as a stateful workspace.

### Model-invoked

Reusable discipline the agent reaches for on its own. Full list in [skills/model-invoked/](skills/model-invoked/).

- **[codebase-design](./skills/model-invoked/codebase-design/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[code-review](./skills/model-invoked/code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: Standards and Spec.
- **[diagnose](./skills/model-invoked/diagnose/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./skills/model-invoked/domain-modeling/SKILL.md)**: Build and sharpen a project's domain model.
- **[interview](./skills/model-invoked/interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable interview primitive behind `discuss`, `discuss-with-docs`, `triage`, `wayfinder` and `deepen`.
- **[merge-fix](./skills/model-invoked/merge-fix/SKILL.md)**: Resolve an in-progress git merge or rebase conflict hunk by hunk, by intent.
- **[pr](./skills/model-invoked/pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence, merge danger.
- **[prototype](./skills/model-invoked/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[research](./skills/model-invoked/research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo.
- **[setup-pre-commit](./skills/model-invoked/setup-pre-commit/SKILL.md)**: Set up Husky pre-commit hooks with lint-staged, type checking, and tests.
- **[tdd](./skills/model-invoked/tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[wizard](./skills/model-invoked/wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
- **[writing-for-agents](./skills/model-invoked/writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md, and any doc an agent reaches by a pointer.

## License

MIT. Original work copyright Matt Pocock; fork copyright TudeOrangBiasa, see [LICENSE](./LICENSE). Per-skill attributions live in each skill's `CREDITS.md`.
