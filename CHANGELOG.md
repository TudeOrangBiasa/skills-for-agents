# skills-for-agents

## 0.3.0

### Minor Changes

- Root `COOKBOOK.md` with flow recipes, diagrams, worked examples, and a growing FAQ (English); `/implement` alias deleted; whips drive-through policy for thin fog.
- Goal mode rename (`autonomous-run` to `goal.md`); new `/showcase` demo skill; `wait-what` tightened to text-first with diagrams only for relations.
- Junior learning batch: `explain-diff-before-merge`, `judgment-drill`, `learn-while-delegating`, ported `handoff`; token-size gate in `setup-pre-commit`.
- Phase A autonomy: squashed contiguous ready-check runs, scheduled landing, multi-day program recipe, autonomy plan.
- Full pstack closure: `architect`, `blast-radius`, `correct`, `recall`, `technical-writing`, `benchmark-checklist`, `show-me-your-work` plus log script; `reflect` folded into retro Deep mode.
- Relaxed HIT (low-risk PASS auto-lands on independent verdicts), opening-a-pr gates step, setup-meta autonomy tier plus scheduled retro and verification upkeep.
- `create-verification` and `maintain-verification` skills, `orchestrate` playbook, `nightshift` renamed to `runner` with legacy fallback, guide overhaul (retro, setup-ts, method skills, fixed landing text).

## 0.2.0

### Minor Changes

- Invocation-first repo layout: skills sorted into `skills/user-invoked` and `skills/model-invoked`; nine never-fitting skills deleted; Claude Code plugin and duplicated docs tree removed; universal-agent installs via skills.sh.
- Glossary renamed to `GLOSSARY.md` (legacy `CONTEXT.md` still supported).
- Interview skills renamed `grill-me`/`grill-with-docs`/`grilling` to `discuss`/`discuss-with-docs`/`interview`; `ask-matt` router to `guide`; `setup-matt-pocock-skills` to `setup-meta`; memorable renames `merge-fix`, `deepen`, `diagnose`, `worklog`.
- `setup-meta` grows into full repo setup (`DESIGN.md` Stitch plus lint, standards file, commit format, pre-commit tooling).
- `nightshift` unattended issue-queue runner with lock claims, draft-only PRs, and `CONTRACT.md`.
- `implement-spec` merged into `implement`; new `break` stress-test skill; `unslop` prose gate with `break` model-invoked and `/implement` aliasing `/whips`.
- `pr` becomes the mandatory PR body shape with `ATTACHMENTS.md` and `agent-browser` as capture prerequisite.
- `wait-what` reworked into a visual re-pitch with the `show-me` catalog.
- `/whips` ships as table-driven router with `PRINCIPLES.md` and per-role model map, then gains autonomous-run, pause, pickup, babysit, ready-check plus `RISK.md`, refactor, prototype, and triage intake/review playbooks.
- `retro` gains meta-docs refresh and cross-session pattern mining.
- `risk:medium` tier plus tiered landing (low PASS and qualifying medium may land by agent, high stays human); still HIT.
- `PRINCIPLES.md` grows from 8 to 20 rules, ported harness-agnostic.
- Five model-invoked skills (`how`, `why`, `interrogate`, `arena`, `swarm`) plus the blast-radius ladder in `bug.md`.
- Four whips playbooks (`runtime-forensics`, `trace-forensics`, `visual-parity`, `eval`).
- `/ketchup` catch-up skill; `figure-it-out` fallback playbook with approval gate; `perf-issue`, `hillclimb`, `worktree-cleanup` rows; guide cookbook rules and worklog boundary.
- `ui-recording-timeline` motion-proof skill with `trim`/`concat`; retro tooling proposals and PR-comment mining; `pr` proof rules; `ready-check` proof verdicts; `check-proof-urls.sh`; `setup-meta` unattended section; whips strategic track.

### Patch Changes

- `implement-spec` skill (in-progress bucket): spec/ticket graph builds.
- `pr` skill reference shape for PR bodies.
- `domain-modeling` trigger rewording; YAML colon quoting fix restoring skills.sh discovery.
- Grilling round separators and em-dash removal; repo-wide em-dash removal.
- `retro` mechanical-vs-judgement classification for standards findings.
- Skill-tool invocation phrasing standard plus user-invoked invariant fixes.
- `wait-what` multi-context map support.
- `/whips` entry skill with `VIBE-MAPPING.md`; in-repo skill refs with explicit human gates; `opening-a-pr` plus triage intake/review.
- Unslop rule 14 tightening, rules 25/26, wordlist backfill; TDD deterministic-before-kept rule.

## 0.1.0

Fork fresh start. This changelog begins here; upstream history lives at [mattpocock/skills](https://github.com/mattpocock/skills).

### Fork identity

- New coordinates: `TudeOrangBiasa/skills-for-agents` across `package.json`, `package-lock.json`, `.changeset/config.json`, installer commands, and skills.sh badge.
- Fresh `README.md` in this repo's own voice: HIT flow, UI sub-flow, 29 skills.
- MIT license kept; fork copyright added alongside the original in `LICENSE`.

### Skills

- Per-skill `CREDITS.md` everywhere (29 skills): fork source and original name where renamed, pstack/poteto for `tdd`, show-me and pr-screenshots for `wait-what` and `pr`.
- Four renames for memorability: `resolving-merge-conflicts` to `merge-fix`, `improve-codebase-architecture` to `deepen`, `diagnosing-bugs` to `diagnose`, `loop-me` to `worklog`.
- New skill `break`: stress-test one component against worst-case content and states, adapted from Jakub Krehel.
- HIT gates: Map and Guardrails checklist in `to-spec`, Plan gate plus `/break` call in `implement`, behavior-first review with text status labels in `code-review`, HIT section plus UI-ticket routing in `guide`.
- `prototype` P1: named axis, recon lines, a11y plus content floors, tradeoff handoff table, `CRAFT.md` craft bar with floor and taste tiers.

### References (research bank, not shipped skills)

- HIT handout, aihero diff, Emil Kowalski and Jakub Krehel distillations, full checklist-design bank (87 foundation, 17 mixed, 25 taste).
