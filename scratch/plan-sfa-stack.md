# Plan: SFA stack playbook router (poteto style, vibe compatible)

Goal: one user invoked entry that routes our HIT skills without micromanagement, patterned on Poteto `poteto-mode`, runnable under OMP vibe mode and plain pi/Codex/agy.

## Context (researched)

- OMP vibe mode: director plus keep alive worker subagents. Director shrinks to `read` plus `vibe_spawn`, `vibe_send`, `vibe_wait`, `vibe_kill`, `vibe_list`. Workers are blank slate, briefs must be self contained. Director verifies with `read` and owns the summary. No autonomous continuation without Goal mode. Sources: `docs/vibe-mode.md`, `packages/coding-agent/src/vibe/runtime.ts`, `packages/coding-agent/src/prompts/system/vibe-mode-active.md`, issues 5674, 5630, 6487, 11005, 9654, 5317, 8171, 11123, 10121, 7963.
- Poteto pstack: `cursor/plugins`, folder `pstack`. Entry `/poteto-mode` matches task to 1 of 23 playbooks, opens todo with steps verbatim, routes to skills as steps fire, delegates implementation to fresh subagents with consolidated scope, director reviews diff and writes own summary. Key files: `pstack/skills/poteto-mode/SKILL.md`, `pstack/skills/swarm/SKILL.md`, `pstack/skills/poteto-mode/playbooks/feature.md`, `pstack/skills/poteto-mode/playbooks/orchestrate.md`.

## Design

New user invoked skill, working name `/playbook` (alternates: `/vibe`, `/route`). Decision needed from user before scaffold.

Behavior:
1. Match task to one playbook (small set, reuse existing skills):
   - investigation: `/research` then `/discuss-with-docs`
   - bug: `/diagnose` then `/tdd` then `/code-review`
   - feature: `/discuss-with-docs`, optional `/prototype` on empirical fork, `/to-spec`, `/to-tickets`, `/implement` per ticket (implement already drives `/tdd` plus `/code-review`)
   - UI ticket: feature path plus diverge (`/prototype` variants), guard (a11y plus content), stress (`/break`), evidence review
   - foggy multi session: `/wayfinder`, merge at `/to-spec`, never straight to `/implement`
   - upkeep: `/deepen` survey, design on `/codebase-design` bench
2. Open todo with playbook steps verbatim. Skipped step stays with `skip: <reason>`.
3. Drive model invoked skills plus subagents itself. Human decides only at forks (approach, guardrail approval, ticket boundaries). This keeps HIT gates (Map before Guardrails, Guardrails before Walk) while removing per skill typing.
4. Subagent brief rule (vibe safe): every delegate gets GOAL, SCOPE paths, CONTEXT pointers, ACCEPTANCE, VERIFY command, REPORT shape. Fresh agent per round with consolidated scope. No resume chains. Director verifies with `read`, reviews diff, writes own summary.
5. Harness mapping: on OMP use `vibe_spawn`/`vibe_send`/`vibe_wait`; elsewhere use background Agent. Open question: inline mapping in SKILL.md or separate `VIBE-MAPPING.md` reference.

## Files to change

- New: `skills/user-invoked/playbook/SKILL.md` (frontmatter `disable-model-invocation: true`, plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`)
- New: `skills/user-invoked/playbook/playbooks/*.md` (6 to 8 files, one per playbook above)
- New: `skills/user-invoked/playbook/CREDITS.md` (credit Poteto pstack, OMP vibe docs)
- New: `skills/user-invoked/playbook/agents/openai.yaml`
- Edit: `skills/user-invoked/guide/SKILL.md` (router must mention new skill, per repo router rule)
- Edit: top `README.md` (add skill row with link, per repo rule)
- Edit: `skills/user-invoked/README.md` (add one line row)
- Maybe: `.changeset/<name>.md` if repo convention wants one per user invoked skill change

## Conventions to respect

- No em dashes anywhere in prose, code comments, changesets. Rewrite with comma, colon, period, parentheses.
- Install block wording copied verbatim from `.agents/install-block.md` where install is mentioned.
- `guide` stays accurate: new skill mentioned, flows updated.
- `agents/openai.yaml` per skill carries invocation flags.

## Steps

1. Confirm skill name and vibe mapping placement (inline vs reference). DONE when user answers.
2. Scaffold `skills/user-invoked/playbook/` with SKILL.md plus 2 starter playbooks (feature, bug). DONE when files exist and READMEs plus guide updated.
3. Add remaining playbooks (investigation, UI variant, wayfinder handoff, upkeep). DONE when each playbook has steps plus owning skills.
4. Dry run on a real task in this repo. DONE when director plus worker flow produces verified diff with evidence.
5. OMP vibe pass. DONE when same playbook runs under `/vibe` with `vibe_*` tools and read only verification.

## Open questions

- Name: `/playbook` vs `/vibe` vs other.
- Vibe mapping: inline section vs `VIBE-MAPPING.md`.
- Scope cut: scaffold with 2 playbooks first, or all 6 at once.

## Report back

After scaffold, report: files created, guide diff, dry run evidence, what is still TODO.
