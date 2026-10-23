# skills-for-agents

## 0.5.3

### Patch Changes

- [#45](https://github.com/TudeOrangBiasa/skills-for-agents/pull/45) [`8bae19a`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/8bae19a948526b051736090a0c0cf29483ccb958) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Turn the repo AGENTS.md into an index of pointers into .agents/ (invocation, writing, install, releasing, ADR, merge delegation), add the releasing guide, fix two dead links in writing-docs, move the README, docs-tree, and guide-upkeep rules plus install details into their meta-doc homes, delete legacy upstream ADR 0002, retitle ADR 0001 to setup-meta, and mark the FACTORY AGENTS box ada. No rule meaning changes.

- [#43](https://github.com/TudeOrangBiasa/skills-for-agents/pull/43) [`c6e5ce3`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/c6e5ce32137fe01a8f994e5b30073512eea96934) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - State the blame-free rule in retro: every finding names a gap in the environment, never a person or agent to blame. FACTORY.md marks Maintenance without blame as ada and drops it from the gap list. Wording only, no behavior change.

- [#44](https://github.com/TudeOrangBiasa/skills-for-agents/pull/44) [`a788f3c`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/a788f3c30b63de38ee78d5dfb440c225d3bd613b) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Fix stale wording from the docs audit: canonical ready-for-agent label in the glossary, setup-pre-commit blurbs matching its frontmatter, upstream mattpocock/skills#106 attribution, Canonical role header in triage-labels, no personal names in the shipped RISK skill, and one shared merge-rule sentence across RISK, opening-a-pr, and triage-labels. No rule meaning changes.

## 0.5.2

### Patch Changes

- [#38](https://github.com/TudeOrangBiasa/skills-for-agents/pull/38) [`20a8c1c`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/20a8c1cade97bc4e937ca3a77db219b1d8ef3586) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Add guide FACTORY.md: a layered TL;DR of how this repo works as a software factory, with Mermaid diagrams and each of the 16 boxes linked to the skill or playbook that runs it, plus an honest gap list. Pointer lines in the guide router, the cookbook intro, the README TL;DR, and a credit entry for the Matt Pocock post.

## 0.5.1

### Patch Changes

- [#37](https://github.com/TudeOrangBiasa/skills-for-agents/pull/37) [`5012c01`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/5012c0142056156af098d01aac3e95bfafcef105) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Cleanup pass over the review batch: legacy-draft wording follows upstream (marking ready flips the flag, the verdict gates the merge), ready-check merges each PR with its own squash and counts four report lists, `/sharpen` centers the four upstream questions with the rewrite as the only output, authoring-a-skill points at the Eval playbook, the dead `lint:pr` script entry is gone, and RISK rule 5 names the docs gate plus `.husky/` as examples.

- [#35](https://github.com/TudeOrangBiasa/skills-for-agents/pull/35) [`b55f92b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/b55f92b0aad5470583c77929166a6f156f9f93df) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Fix `user-manual` against a real browser review: viewport presets use Playwright `width`/`height`, images resolve under `shots/`, built HTML fails the build when an image does not load, annotation boxes subtract the target origin (measured before the screenshot on one scroll position), the blank-band gate measures leading/trailing edges inside the content box so deliberate padding never fails the build, PDFs get an empty header template plus timestamp normalization for byte-identical rebuilds, and `manual verify` re-checks every box against live selectors with the same visibility treatment. New `user-manual-e2e` CI job builds the fixture twice and asserts determinism, image loading, gate, overlap (including a 40px shift), missing-selector failure, and freshness.

## 0.5.0

### Minor Changes

- [#29](https://github.com/TudeOrangBiasa/skills-for-agents/pull/29) [`592a292`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/592a2924720151fe3f24b7486aba0e8493027541) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `/ketchup` synced with upstream refinements: briefing-length replies built from the visual, every waiting item listed, no item ever cut to fit the length. Goal mode and `/runner` close runs with a catch-up in the ketchup shape (referenced by path, never invoked as a skill), and silent ticks stay silent.

- [#11](https://github.com/TudeOrangBiasa/skills-for-agents/pull/11) [`78f1122`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/78f11221c3881fe3bd56555c06580cef28357399) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - README gains a TL;DR (skill counts, entry points, tiered landing, proof discipline) and AGENTS.md requires changesets plus generated changelogs for user-facing changes.

- [#31](https://github.com/TudeOrangBiasa/skills-for-agents/pull/31) [`c96c18e`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/c96c18ee6d2b362faceb15416c6538ff9cfffd68) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `ready-check` landing hardened per upstream shipping: verdicts seal the patch (`git patch-id`), not the SHA; every merge is read back before it counts; children retarget to the trunk with pinned force-push after a parent lands; the stack stays untouched during landing; auto-merge stays disarmed with the reason written down. The Section G wake reference is now explicit.

- [#32](https://github.com/TudeOrangBiasa/skills-for-agents/pull/32) [`6f01be7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/6f01be7870c107440c7d6533409eeee7fed57378) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - New model-invoked `/user-manual` skill: generate a user manual (guide book, panduan pengguna) from a running web app with one deterministic command. Shots clip to content targets with sticky and fixed element handling, edges auto-trim with a fixed margin, selector-based annotations resolve to sidecar coordinates, and the build fails on blank-band screenshots, orphan captions, stale captures, or budget overruns. Ships a working CLI (dependency-free trim and QA plus Playwright capture and PDF), print assets, and a fixture.

- [#27](https://github.com/TudeOrangBiasa/skills-for-agents/pull/27) [`c45a2d4`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/c45a2d4f07a6564a881e71ccf6b33d22d6d31ed5) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Subagent model choice now includes optional effort and speed: `models.md` gains Effort and Speed columns (blank means the role's model as-is), `setup-meta` asks about them only when the harness names effort levels, and `whips` shifts effort up for the hardest work and down for routine work with fast mode reserved for urgent runs. Verifier roles are never shifted down. Also fixes the VIBE-MAPPING brief reference to point at `/whips` section 6.

- [#13](https://github.com/TudeOrangBiasa/skills-for-agents/pull/13) [`01a17ac`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/01a17aced67677569f7ee90d718f7eae58474a29) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `setup-pre-commit` detects toolchain (oxlint/oxfmt first, then Biome, then Prettier) with fast pre-commit and pre-push split plus token-size gate. `setup-meta` timing split for hooks.

- [#28](https://github.com/TudeOrangBiasa/skills-for-agents/pull/28) [`6a353c9`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/6a353c96aa670c196d8e694cb954f0d478d8c4f3) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `/create-verification` now builds the lever when no harness exists: a small agent-friendly CLI with six verified properties (composable API, `--dry-run` on destructive commands, gradual subcommands including `dev-env`, guiding errors, complete `--help`, JSON output) with one example of each output shape. `/maintain-verification` checks the CLI for drift against the same six properties.

- [#30](https://github.com/TudeOrangBiasa/skills-for-agents/pull/30) [`697e15b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/697e15b6e28b96d89e35a5f128f8785d1db29173) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - New `/whips` playbook `authoring-a-skill`: skill work routes to it instead of `feature`, with runnable validation (frontmatter name and description, referenced files, link resolution, `openai.yaml` shape), metadata shipping, and `eval.md` for behavior changes. The docs gate now fails when a skill frontmatter `name` differs from its folder.

- [#24](https://github.com/TudeOrangBiasa/skills-for-agents/pull/24) [`f4c3658`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f4c36581c88ca62129241daa9ba9eb69869f26ae) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `whips` principles 2, 6, 7, and 9 resynced with upstream pstack ([#633](https://github.com/TudeOrangBiasa/skills-for-agents/issues/633) wording as reasoning, [#604](https://github.com/TudeOrangBiasa/skills-for-agents/issues/604) cheap always-on signal): fix at the first place the system went wrong, idempotency without a mandated mechanism, assert observable behavior, and test the premise directly. `correct` step 3 follows the new test wording. The `tdd` undefined check stays as operational hardening; no `returns nothing` or per-actor census wording remains under `skills/`.

- [#23](https://github.com/TudeOrangBiasa/skills-for-agents/pull/23) [`594a3e7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/594a3e7130165341f4cd24f69343e5bfcf867c09) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `whips` now opens every PR ready instead of as a draft, following upstream pstack: landing follows the risk tier with the verdict (not draft status) gating the merge, `risk:high` requires an independent PASS or PASS+NOTES verdict comment plus a human merge, and the docs gate fails on `gh pr create --draft` or an `always a draft` instruction under `skills/`.

- [#26](https://github.com/TudeOrangBiasa/skills-for-agents/pull/26) [`683a3d3`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/683a3d3e4fb86b25c080b86ff44ece2f0b21480c) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - `/whips` now restates the goal and problem in its own words before matching a playbook (triage intake does the same), with candor over sycophancy in Autonomy and anti-fabricated-link plus consumer/maintainer impact framing in the reply rules. New user-invoked `/sharpen`: make a task deeper, not bigger, then rewrite the prompt, wired into the guide and cookbook.

### Patch Changes

- [#33](https://github.com/TudeOrangBiasa/skills-for-agents/pull/33) [`513321a`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/513321a065e1b410a372eb56d3744ef7cc114ad9) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Pre-commit hook now compares the worktree against the branch point instead of HEAD, so a stacked second commit no longer fails checks its branch already satisfies (changeset committed earlier on the same branch). Genuine violations with no changeset anywhere on the branch still fail. Verified both directions on probe branches.

- [#25](https://github.com/TudeOrangBiasa/skills-for-agents/pull/25) [`18f3b63`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/18f3b63ac79d3daa3fc6de0902d0d32cfd606b1a) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Paraphrase `whips` principle 7 and `correct` step 3 in the repo's own words (same observable-behavior meaning, no upstream wording mirrored).

## 0.4.0

### Minor Changes

- Move COOKBOOK.md into the guide skill so it ships on install, with README pointers updated. AGENTS.md gains the changelog discipline and the mandatory public-release rule.
- Docs hygiene gate `check-docs.sh` (README sync, dead internal links, changeset presence, em-dash rule) with pre-commit hook and CI workflow. `setup-meta` timing split and `wait-what` text-first rule. Retro recipe gains multi-session navigability mining and main-flow placement.
- `setup-pre-commit` detects toolchain (oxlint/oxfmt first, then Biome, then Prettier), splits fast pre-commit from pre-push checks, and adds a token-size gate.
- AGENTS.md gains changelog discipline, mandatory public releases, and semver versioning rules.

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
