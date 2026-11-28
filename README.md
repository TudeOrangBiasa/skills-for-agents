# Skills for Agents

Agent skills vendored from [pstack-claude](https://github.com/michael-denyer/pstack-claude) at pin `1ab6b82` (2026-11-26), MIT licensed. 68 skills plus 4 agents, flat under [skills/](skills/) and [agents/](agents/). Upstream-verbatim except this README, repo tests, and release plumbing. Local behavior deltas from earlier ports are gone; file issues against upstream or carry them as project playbooks.

## Credits

Routing, principles, playbooks, and verification come from [pstack](https://github.com/cursor/plugins) (`poteto-mode` and leaf skills) by [Lauren Tan](https://github.com/poteto), via the [pstack-claude](https://github.com/michael-denyer/pstack-claude) port (multi-harness mappings, SessionStart routing, installer), MIT licensed. Earlier local ports (triage labels, Gates proof blocks, consumer repo setup) were removed in the full vendor; their lessons live in git history.

## TL;DR

- Tell `poteto-mode` your goal; it invokes the workflow: concise responses, deliberate subagents, unslopped prose, simple verified code.
- 24 `principle-*` leaves trigger by name (read the leaf in full before applying it); playbooks live next to their skill; project repos extend them via `.agents/playbooks/` (`extends` plus `when`, checked by `skills/poteto-mode/scripts/check-playbooks.mjs`).
- Verification is layered: prove-against-the-artifact, verifiable units, behavior tests, number explanations, plus per-area verification skills.
- This repo adds no behavior: changesets, `npm test`, and the install story are the shell.

## Installation (30-second setup)

One install story. **[skills.sh](https://skills.sh/TudeOrangBiasa/skills-for-agents)** copies editable skill files into your project, so you can hack on them and make them your own. They work the same in any agent that loads SKILL.md folders.

### 1. Get the skills

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents
```

Pick the skills you want, and which coding agents to install them on.

For a single skill:

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents --skill=<name>
```

It writes the skills into your repo as ordinary files you own and can edit. Nothing updates behind your back; pull the latest changes when you want them with `npx skills update`.

### 2. Run `/setup-pstack`

In your agent, run it once to pick the models each role uses, then tell `poteto-mode` your goal.

### 3. Bam - you are ready to go.

## Skills (68)

Entry: poteto-mode, poteto-help, setup-pstack, bro, automate-me, what-did-i-get-done, in-your-own-words, reframe, sharpen.

Orchestration: swarm, arena, figure-it-out, interrogate, babysit, fix-ci, fix-merge-conflicts, get-pr-comments, make-pr-easy-to-review, statechart, thermos.

Verification: create-formal-verification-skill, maintain-formal-verification-skill, create-verification-skill, maintain-verification-skill, benchmark-checklist, blast-radius, tdd, how, why, ketchup, ketchup-video, recall, reflect, teach, show-me-your-work.

Prose: technical-writing, unslop, deslop, no-comments, correct, thermo-nuclear-review, thermo-nuclear-code-quality-review.

Code: architect, typescript-best-practices, correct.

Principles (24, each triggers by name): principle-attack-the-premise, principle-boundary-discipline, principle-build-the-lever, principle-encode-lessons-in-structure, principle-exhaust-the-design-space, principle-experience-first, principle-explain-the-number, principle-fix-root-causes, principle-foundational-thinking, principle-guard-the-context-window, principle-laziness-protocol, principle-make-operations-idempotent, principle-migrate-callers-then-delete-legacy-apis, principle-minimize-reader-load, principle-model-the-domain, principle-never-block-on-the-human, principle-outcome-oriented-execution, principle-prove-it-works, principle-redesign-from-first-principles, principle-separate-before-serializing-shared-state, principle-sequence-verifiable-units, principle-subtract-before-you-add, principle-test-behavior-not-implementation, principle-type-system-discipline.

## License

MIT. Vendored work copyright its authors; repo shell copyright TudeOrangBiasa, see [LICENSE](./LICENSE).
