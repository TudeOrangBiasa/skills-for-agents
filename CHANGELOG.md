# skills-for-agents

## 0.7.0

### Minor Changes

- [#205](https://github.com/TudeOrangBiasa/skills-for-agents/pull/205) [`3b32a58`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/3b32a58e22486ac158e527298c4c116fc4c1e20f) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Thin guide router plus a smaller pack: SKILL.md drops to a 400-token router with an explicit on-demand contract (COOKBOOK, FACTORY, and PHASE-BOUNDARIES open only when asked), COOKBOOK keeps the master map plus four recipes with the FAQ reduced to one-line pointers at the owning skills, FACTORY keeps its TL;DR and overview diagram with layer detail replaced by links to the README, stage-pipeline, and upstream-map, and check-docs now enforces both the router and pack budgets.

- [#206](https://github.com/TudeOrangBiasa/skills-for-agents/pull/206) [`f19f6f5`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f19f6f5077c5849a37943440c02dd79fa76620d2) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat: sweep named harnesses from setup-repo and gate generic wording. The unattended section and install-timers now detect any documented non-interactive agent CLI (the recorded agent command or opaque probe binaries) instead of a named install, and a new check-docs gate fails on denylisted harness names under skills, README, and docs unless scripts/harness-name-allowlist.txt exempts the path. Closes [#190](https://github.com/TudeOrangBiasa/skills-for-agents/issues/190).

- [#199](https://github.com/TudeOrangBiasa/skills-for-agents/pull/199) [`ef91e23`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/ef91e230edc43c0d48d9705400f18e19ffd63df3) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Wayfinder handoff without extra human gates: whips now drives the plan-map, collapse, and tickets pipeline inline for huge foggy efforts using model-invoked primitives plus tracker writes, reusing the map Destination and Decisions-so-far verbatim instead of re-asking them, with cleared maps collapsing into one-type tickets carrying Kompleksitas, acceptance, ready-for-agent, and a risk label, while plan-map stays user-invokable and thin fog stays on the drive-through path.

- [#200](https://github.com/TudeOrangBiasa/skills-for-agents/pull/200) [`f8d6f00`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f8d6f00dc069427bb733f7e0c21864622a01efee) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat: ship-runner setup is harness-agnostic and claims survive races. Setup drops the preset table and harness-named detection paths: it reads the agent command and model from flags, from the consumer repo's docs/agents/harness.md (new setup-repo template), or by asking the user, then persists them to the consumer repos with a thin host override. Issue claims now re-read assignees and claim markers after the assign write and back off with claim_lost when another runner holds or beat the claim, so a cross-machine race launches at most one agent. Closes [#188](https://github.com/TudeOrangBiasa/skills-for-agents/issues/188), closes [#194](https://github.com/TudeOrangBiasa/skills-for-agents/issues/194).

- [#198](https://github.com/TudeOrangBiasa/skills-for-agents/pull/198) [`842889c`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/842889cc29e47c2ba28d6057651b0a26a5325849) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - ship-triage repeat ticks stay incremental: a last-tick cursor in the runner state dir narrows each tick to issues updated since the cursor (full rescan only on a missing or corrupt cursor, cursor written only after success), and near-duplicate titles match by normalized fingerprint in a one-pass map instead of exact strings. Closes [#195](https://github.com/TudeOrangBiasa/skills-for-agents/issues/195), closes [#196](https://github.com/TudeOrangBiasa/skills-for-agents/issues/196).

- [#204](https://github.com/TudeOrangBiasa/skills-for-agents/pull/204) [`975ae50`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/975ae50b1dde00826821d28a4df1c3dd7dff1ec5) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: lock the pstack versus Matt upstream split as policy in docs/upstream-map.md (pstack owns automation and shipping, Matt owns ideas and planning only), add the audit of mismatched rows with a proposed fix per row, and surface the same rule as a one-sentence pointer on the guide main flow. Closes [#191](https://github.com/TudeOrangBiasa/skills-for-agents/issues/191).

### Patch Changes

- [#207](https://github.com/TudeOrangBiasa/skills-for-agents/pull/207) [`a337530`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/a33753096c8987a836cfe3338fd231eaba7d3081) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - Audit the twelve Matt-sourced craft and learn rows: confirm each behaves locally per its proposed fix and correct the pointers that lie. The guide row becomes an original router with a credit note to Matt ask-matt (map row and guide CREDITS.md); the other eleven rows keep credit with local behavior, docs pointers only.

- [#208](https://github.com/TudeOrangBiasa/skills-for-agents/pull/208) [`9379ce3`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/9379ce3029d0c5f08251733a36c558b2e21cc6a3) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: resolve the upstream-map audit rows (record each of the six shipping or automation-shaped rows as pstack-side behavior with credit kept as the historical record, and keep plan-sharpen on pstack as execution-adjacent brief sharpening). Closes [#201](https://github.com/TudeOrangBiasa/skills-for-agents/issues/201), closes [#203](https://github.com/TudeOrangBiasa/skills-for-agents/issues/203).

- [#197](https://github.com/TudeOrangBiasa/skills-for-agents/pull/197) [`faf9d18`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/faf9d189a961c9c9a898993f75a0509a28f06218) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix: learn-reflect transcript discovery is harness-agnostic (consumer-repo config under docs/agents, then ask the user once, then generic user-set signals such as an env var, then tight digest fallback); drops the hardcoded store path. Closes [#189](https://github.com/TudeOrangBiasa/skills-for-agents/issues/189).

## 0.6.1

### Patch Changes

- [`132d813`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/132d8138d3d75ac5cd8292ded15369f5bde0b53d) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: use renamed skill names in README credits line

## 0.6.0

### Minor Changes

- [#182](https://github.com/TudeOrangBiasa/skills-for-agents/pull/182) [`a3a61b8`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/a3a61b8a4b8a59898bf824e83956d087e9407bda) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fold(deprecate): absorb learn-while-delegating into explain-diff-before-merge and showcase into pr, delete both skills. Part of [#173](https://github.com/TudeOrangBiasa/skills-for-agents/issues/173).

- [#184](https://github.com/TudeOrangBiasa/skills-for-agents/pull/184) [`d89ff79`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/d89ff7931a53c6920c7c82a19e54068dbe4df4b4) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips,setup-meta): fail-closed forge gate for team auto-merge landing. `shipping.md` refuses to arm and writes `needs-human reason=no-required-checks` when `repo-settings check` fails; `ready-check.md` treats the forge gap as a fail axis; setup-meta Section K records the check outcome and points at both gates by path (still ask-first, never silent apply). `repo-settings` gains a `REPO_SETTINGS_FIXTURE` stub mode with gap and green fixtures plus `repo-settings-test` proving nonzero exit with `refused` and zero forge calls. Closes [#171](https://github.com/TudeOrangBiasa/skills-for-agents/issues/171).

- [#159](https://github.com/TudeOrangBiasa/skills-for-agents/pull/159) [`f7d912b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f7d912bb8f7c8aaa83589607aa54ac77a1a77b4a) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(fv): port pstack formal verification trio as harness-agnostic user-invoked skills: create-formal-verification, maintain-formal-verification, statechart (TLC dependency docs plus Toggle install-proof fixture; runner itself not ported); guide router offers formal verification only after create-verification where tests cannot reach. Closes [#100](https://github.com/TudeOrangBiasa/skills-for-agents/issues/100).

- [#143](https://github.com/TudeOrangBiasa/skills-for-agents/pull/143) [`44a7bae`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/44a7bae9f241d492ce5758ea9ca3e8bcac6bab81) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: guide and README use mode-aware landing (solo verifier, team checks; tiers scale verification); consumer migration note in setup-meta/migration-landing.md (8 steps). Upgrading to mode-aware landing: delete draft/never-merge text, write the Landing block from setup-meta, protected paths become automated checks, open drafts go ready plus reclassify, repo settings via repo-settings ([#76](https://github.com/TudeOrangBiasa/skills-for-agents/issues/76)) or UI once. Closes [#52](https://github.com/TudeOrangBiasa/skills-for-agents/issues/52).

- [#124](https://github.com/TudeOrangBiasa/skills-for-agents/pull/124) [`499f81b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/499f81b76845dd1ef5b4c8fef106ec4903bc81e7) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat: issue templates (bug, feature/enhancement, deprecation) requiring one type plus a ## Kompleksitas line; to-tickets, triage skill, and whips triage playbook route briefs missing either to needs-info; setup-meta Section B creates feature-request and deprecation labels idempotently. Informational audit: open issues [#53](https://github.com/TudeOrangBiasa/skills-for-agents/issues/53), [#54](https://github.com/TudeOrangBiasa/skills-for-agents/issues/54), [#62](https://github.com/TudeOrangBiasa/skills-for-agents/issues/62) (epics, pre-template) and [#93](https://github.com/TudeOrangBiasa/skills-for-agents/issues/93) (needs-info, on hold) predate the template. Closes [#84](https://github.com/TudeOrangBiasa/skills-for-agents/issues/84).

- [#183](https://github.com/TudeOrangBiasa/skills-for-agents/pull/183) [`4aecad4`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/4aecad4952ee0574ded58f2d81254b22bd2c9f52) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(ketchup-video): port subtitled slide-video catch-up from pstack with text fallback

- [#153](https://github.com/TudeOrangBiasa/skills-for-agents/pull/153) [`52269c8`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/52269c8fe805854e2ec40d17bc393bec57dbd68f) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(skills): sync leaf depth with pstack for how, why, swarm, arena, interrogate, blast-radius, show-me-your-work, ketchup

  Closes [#102](https://github.com/TudeOrangBiasa/skills-for-agents/issues/102)

- [#155](https://github.com/TudeOrangBiasa/skills-for-agents/pull/155) [`ab3098b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/ab3098b311859ba9f237e818a51e0a9ac5990447) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(no-comments): port Comment Sicko spawn persona from pstack

  Closes [#98](https://github.com/TudeOrangBiasa/skills-for-agents/issues/98)

- [#185](https://github.com/TudeOrangBiasa/skills-for-agents/pull/185) [`7f242e0`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/7f242e0a4ed010a7419185e51555651ba6aa9965) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta,whips): enforce the pre-push hook plus the no-verify ban by script (ensure-worktree-hooks installs the hook into every new worktree and fails closed while absent; no-verify-guard refuses bypass argv and hookless pushes; setup-meta Sections E and I plus opening-a-pr steps 2-3 point at both scripts by path; stub test proves nonzero-without-hook and no-verify rejection with no GitHub writes). Closes [#167](https://github.com/TudeOrangBiasa/skills-for-agents/issues/167).

- [#156](https://github.com/TudeOrangBiasa/skills-for-agents/pull/156) [`af1a3eb`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/af1a3eb9f28957020bfb1ff0163b2fe7e0ce2c40) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(principles): per-principle leaf skills with an index (group A: core)

  Part of [#80](https://github.com/TudeOrangBiasa/skills-for-agents/issues/80)

- [#186](https://github.com/TudeOrangBiasa/skills-for-agents/pull/186) [`689f0b9`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/689f0b996ae0d44344eb4f0d3179c7adc5851123) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(principles): replace 24 principle-\* leaf skills with one principles index skill. Part of [#174](https://github.com/TudeOrangBiasa/skills-for-agents/issues/174).

- [#158](https://github.com/TudeOrangBiasa/skills-for-agents/pull/158) [`7054699`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/705469973d056a2338ecb528270c58612769d7ec) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(reflect): port session-to-skill learning loop from pstack, no ketchup-video yet

  Adds `/reflect`: three parallel reviewers (judgment, tooling, divergent) mine the session transcript and a synthesizer routes each accepted learning to a small skill PR. Transcript lookup stays in this workspace's harness store with a digest fallback, reviewers follow the repo model map (`reflect-reviewer`, `reflect-synthesizer`) with a two-pass fallback on single-model harnesses, and the guide routes reflect vs retro vs ketchup. `ketchup-video` is skipped in this PR: OMP has no reliable authored-slide video render path (see the PR description note); text `/ketchup` stays the catch-up path.

  Part of [#99](https://github.com/TudeOrangBiasa/skills-for-agents/issues/99)

- [#150](https://github.com/TudeOrangBiasa/skills-for-agents/pull/150) [`5b534d9`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/5b534d91fce0646df12c8070fdf339c38fc15c5b) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(runner): durable claim and attempt state on GitHub with WIP resume. Attempt counts and claims come from issue comment markers, so a reboot or wiped state dir changes nothing; orphan claims are reaped after a TTL, timeout work pushes to wip/runner-issue-N and resumes through pickup. Closes [#57](https://github.com/TudeOrangBiasa/skills-for-agents/issues/57).

- [#164](https://github.com/TudeOrangBiasa/skills-for-agents/pull/164) [`f40d8ad`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f40d8ad1fce3acc07839d7f23143d45fc2ff8b46) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(runner): fix-ci pass that claims red or conflicted PRs on team repos through labels, with attempt caps and a dry run. Closes [#56](https://github.com/TudeOrangBiasa/skills-for-agents/issues/56).

- [#151](https://github.com/TudeOrangBiasa/skills-for-agents/pull/151) [`51474f7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/51474f7459d7764b8756a3485719024158463b85) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(runner): on-loop issue triage for consumer repos. New `runner.sh triage` tick labels up to 3 intake issues per repo per tick (unlabeled, needs-triage, replied needs-info), oldest first, with the repo vocab from docs/agents/triage-labels.md: complete briefs get ready-for-agent plus an honest risk label, thin briefs get needs-info with one concrete question, product calls get needs-human with the triage-decision marker, clear duplicates get duplicate and stay open. Never closes, never merges, never writes code. Bound: 1 list call plus at most 4 calls per triaged issue, zero agent spawns unless opted in, stop-file kill switch, --dry-run prints decisions. New whips playbook issue-triage-loop.md plus bot-triage.md reference folded in from [#72](https://github.com/TudeOrangBiasa/skills-for-agents/issues/72), and a triage job in the setup-meta timer template. Closes [#81](https://github.com/TudeOrangBiasa/skills-for-agents/issues/81).

- [#147](https://github.com/TudeOrangBiasa/skills-for-agents/pull/147) [`047c4ee`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/047c4ee5c5a9c93abb3e4aabc13c91379839e94d) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): opt-in harness timers for the runner plus headless omp preset. Section G offers unattended wake only on request: detect omp from its documented flags, never hardcode a harness, and keep Orca an optional note. New install-timers script renders four systemd user units with verify plus manual probe before enable, supports dry-run, pause, resume, idempotent uninstall, and a cron fallback. Runner gains pause and resume plus an omp preset from omp help. Closes [#78](https://github.com/TudeOrangBiasa/skills-for-agents/issues/78).

- [#144](https://github.com/TudeOrangBiasa/skills-for-agents/pull/144) [`a907532`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/a90753236bf457ff79cb7386b9b688019d927d32) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): four-layer local gates including non-JS repos (JS/TS via setup-pre-commit; Dart/PHP/Python shell presets under .githooks only when tools already exist; commit-msg Conventional Commits with merge/revert exempt; pre-push wired to the verifier; no mandatory CI template; agents never use --no-verify). Closes [#79](https://github.com/TudeOrangBiasa/skills-for-agents/issues/79).

- [#142](https://github.com/TudeOrangBiasa/skills-for-agents/pull/142) [`0b7f829`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/0b7f829adf0638c6c3e8a93bf03c01f4b3c0f60e) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): landing policy template reading repo-mode plus verifier (protected paths are extra automated checks); AGENTS block gains Landing; re-run detects legacy draft/never-merge text and offers replacement. Closes [#51](https://github.com/TudeOrangBiasa/skills-for-agents/issues/51).

- [#144](https://github.com/TudeOrangBiasa/skills-for-agents/pull/144) [`a907532`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/a90753236bf457ff79cb7386b9b688019d927d32) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): generic per-role model map plus reasoning budget, no harness defaults. Section F runs detect, budget, map, validate, write, confirm with one question per step; models.md gains panel roles, a budget line, and a one-model example where review never drops below code. Re-runs rewrite the file in full. Closes [#77](https://github.com/TudeOrangBiasa/skills-for-agents/issues/77).

- [#147](https://github.com/TudeOrangBiasa/skills-for-agents/pull/147) [`047c4ee`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/047c4ee5c5a9c93abb3e4aabc13c91379839e94d) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): repo settings check and apply for team landing (solo N/A). `whips/scripts/repo-settings check|apply` reads allow_auto_merge, delete_branch_on_merge, branch protection, required checks vs latest workflow jobs and check runs, plus the [#65](https://github.com/TudeOrangBiasa/skills-for-agents/issues/65) label vocab; apply is idempotent with --dry-run, --yes, and UI steps without admin. Setup gains a team-only section, the unattended template gains a Landing line, and Landing auto-merge is refused with empty required checks. Closes [#76](https://github.com/TudeOrangBiasa/skills-for-agents/issues/76).

- [#129](https://github.com/TudeOrangBiasa/skills-for-agents/pull/129) [`5ca4b12`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/5ca4b1261bb64886be6e12d7fb3e41e8a6da97dd) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-meta): Section H repo-mode (solo|team) with template, Section I solo verifier (create-verification plus pre-push plus worktree hooks, never --no-verify) with template, Section J canonical docs layout scaffold (dirs, gitignore, docs-layout.md, AGENTS pointer) with templates; opening-a-pr runs the verifier before push and refuses missing config. Closes [#105](https://github.com/TudeOrangBiasa/skills-for-agents/issues/105), closes [#115](https://github.com/TudeOrangBiasa/skills-for-agents/issues/115), closes [#116](https://github.com/TudeOrangBiasa/skills-for-agents/issues/116).

- [#128](https://github.com/TudeOrangBiasa/skills-for-agents/pull/128) [`caf53d7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/caf53d7b7e5fc4b7107ee7589794f933ddc171e9) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(setup-pre-commit): commit-msg template enforcing Conventional Commits (commitlint when present, dependency-free shell otherwise, merge/revert exempt) plus the four-layers paragraph (pre-commit fast, pre-push slow, commit-msg format, verifier in docs/agents/verifier.md decides; agents never use --no-verify). Tested in scratch: rejects fixed stuff and trailing periods, accepts feat/runner and Merge/Revert. No changes to .husky/ or .github/ in this repo. Closes [#60](https://github.com/TudeOrangBiasa/skills-for-agents/issues/60).

- [#127](https://github.com/TudeOrangBiasa/skills-for-agents/pull/127) [`730708c`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/730708c6b21b98840412962db38caf02d4205b8c) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs(setup-meta): single label vocabulary with one meaning per label; needs-human means agent stopped and a human must decide (marker reason required); ready-for-human is issues-only, never on PRs. Created missing needs-triage and ready-for-human labels in this repo. Closes [#65](https://github.com/TudeOrangBiasa/skills-for-agents/issues/65).

- [#187](https://github.com/TudeOrangBiasa/skills-for-agents/pull/187) [`fe32d77`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/fe32d7797545d5e9ee618376dd49416fe8e42a95) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - rename(skills): 53 skills move to the stage-prefix scheme ([#175](https://github.com/TudeOrangBiasa/skills-for-agents/issues/175)), plus `ketchup-video` riding along as `learn-catchup-video`. Keeps: `create-formal-verification`, `guide`, `maintain-formal-verification`, `whips`. Old names resolve for one release via `docs/aliases.md` (tested by `scripts/test-aliases.sh`), then the aliases are deleted. `docs/upstream-map.md` maps every local name to its upstream source (pstack/Matt/other) so sync diffs stay mechanical. Consumer repos migrate by renaming installed folders per the alias table or re-running `npx skills add` and picking the new names.

- [#157](https://github.com/TudeOrangBiasa/skills-for-agents/pull/157) [`33105f2`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/33105f24115ee65be03e2f9b7aa6a6ef5aefbecf) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(typescript-best-practices): new leaf paired with type-system-discipline

  Closes [#101](https://github.com/TudeOrangBiasa/skills-for-agents/issues/101)

- [#161](https://github.com/TudeOrangBiasa/skills-for-agents/pull/161) [`b0b5c9f`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/b0b5c9fe62e90790c9868a87fae7a9f78457ac77) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): autopilot-full and autopilot-stack playbooks adapted from pstack (one owner per PR in its own worktree, operators gates first, parallel off trunk, pushed trail plus stuck replacement, merge-prep rebase rule, ketchup close, stack opt-out that holds landing); deliberate deviation: no independent swarm-verify, the mode verifier plus owner self-proof decides per RISK.md. Router rows in SKILL.md plus trim to hold the pack budget, guide COOKBOOK and FACTORY refs. Closes [#69](https://github.com/TudeOrangBiasa/skills-for-agents/issues/69).

- [#141](https://github.com/TudeOrangBiasa/skills-for-agents/pull/141) [`aac2fdb`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/aac2fdba3082f318161da9e95193d8f117f90710) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): babysit drive ends at MERGED read-back via pr-status with a budgeted fix-until-green loop (never weaken a gate), needs-human exit, background mode, and no stack-topology mutation; ask threads route to needs-human. Closes [#48](https://github.com/TudeOrangBiasa/skills-for-agents/issues/48).

- [#136](https://github.com/TudeOrangBiasa/skills-for-agents/pull/136) [`72e30c6`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/72e30c67024570a773c9e4d67c42ae520e7a0e62) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): independent review means fresh context plus adversarial brief, not a different model; new VERIFIER-BRIEF.md referenced from SKILL, ready-check, and RISK; models.md documents single-model setup; remaining multi-model wordings made conditional. Closes [#67](https://github.com/TudeOrangBiasa/skills-for-agents/issues/67).

- [#163](https://github.com/TudeOrangBiasa/skills-for-agents/pull/163) [`0825291`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/0825291f61f9bd8457a33888707d688c13f7d7ba) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): sync landing playbook depth from pstack (shipping, babysit, ready-check)

  Part of [#103](https://github.com/TudeOrangBiasa/skills-for-agents/issues/103)

- [#131](https://github.com/TudeOrangBiasa/skills-for-agents/pull/131) [`72a8e69`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/72a8e695242bc707288422f7cf6770628f401854) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix(whips): landing follows pstack with a mode-aware verifier (solo trusts local verifier and pre-push, team reads CI); new shipping.md playbook (merge, read-back MERGED, stack retarget, topology freeze); ready-check and babysit no longer wait on gh pr checks in solo mode; Green CI wording replaced in RISK, SKILL, ready-check, orchestrate. Closes [#117](https://github.com/TudeOrangBiasa/skills-for-agents/issues/117).

- [#160](https://github.com/TudeOrangBiasa/skills-for-agents/pull/160) [`b1f2971`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/b1f2971b793a1ff5b4ad59e2e9896e9b46faba89) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): multi-phase-plan playbook plus check-plan.mjs linter with node fixtures (adapted from pstack poteto-mode with local worktree owners, CI plus self-proof verdicts, agent landing per risk tier, optional needs-human review gate, and scheduled wakes); router row plus pointers in figure-it-out and wayfinder-handoff. Closes [#70](https://github.com/TudeOrangBiasa/skills-for-agents/issues/70).

- [#162](https://github.com/TudeOrangBiasa/skills-for-agents/pull/162) [`464e627`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/464e627959ad0441e4ea3669b5ae5ec2e9a5156d) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): fuller orchestrate playbook with ledger, liveness, and escalation

  Closes [#71](https://github.com/TudeOrangBiasa/skills-for-agents/issues/71)

- [#149](https://github.com/TudeOrangBiasa/skills-for-agents/pull/149) [`4f4dcbd`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/4f4dcbdeabad5d7292a2465a54a7abe5dc2cd93c) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): pause note and run log mirrored to PR/issue comments. Closes [#58](https://github.com/TudeOrangBiasa/skills-for-agents/issues/58).

- [#154](https://github.com/TudeOrangBiasa/skills-for-agents/pull/154) [`9a48737`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/9a48737a0862fb2dacd2cc7e0a664692d9dc4461) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): sync core playbook depth from pstack poteto-mode for investigation, bug, feature, refactor, perf-issue, hillclimb, eval, prototype, and figure-it-out (repro-first, measurement contracts, blind eval, predicate framing, Reply contracts). Part of [#103](https://github.com/TudeOrangBiasa/skills-for-agents/issues/103).

- [#126](https://github.com/TudeOrangBiasa/skills-for-agents/pull/126) [`d5a9dda`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/d5a9dda14db2f5a17e57f931e35944caea77a7eb) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): pr-status classifier emitting structured PR state (merged, closed, conflict, blocked, red, pending, armed, ready) from forge fields only, with --wait and exit codes; solo repos treat pending with noRequiredChecks as waiting on the local verifier. Closes [#63](https://github.com/TudeOrangBiasa/skills-for-agents/issues/63).

- [#152](https://github.com/TudeOrangBiasa/skills-for-agents/pull/152) [`47a4652`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/47a4652acb578dfdb944c47241311e320bc0c673) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): prune merged worktrees safely on a timer

  Closes [#83](https://github.com/TudeOrangBiasa/skills-for-agents/issues/83)

- [#122](https://github.com/TudeOrangBiasa/skills-for-agents/pull/122) [`1309480`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/1309480a912ae8905f983d1578344e4345363254) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - deprecate(whips): remove goals mode and VIBE-MAPPING entirely; whips is harness-agnostic with an outside scheduler tick for unattended runs. Closes [#114](https://github.com/TudeOrangBiasa/skills-for-agents/issues/114).

- [#140](https://github.com/TudeOrangBiasa/skills-for-agents/pull/140) [`2f57d7e`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/2f57d7e47170d6dd076d0cede704b532ac48546e) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): risk rubric from diff blast radius with verification per tier (low verifier, medium fresh-context surface run, high blast-radius plus adversarial reviewer); anti-default rule; large-diff carve-out; generic stack examples. Closes [#49](https://github.com/TudeOrangBiasa/skills-for-agents/issues/49).

- [#145](https://github.com/TudeOrangBiasa/skills-for-agents/pull/145) [`d5f8585`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/d5f8585badfe49db6994696880700696aa55a11c) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): stage pipeline grill to execute with handoff contract; Matt skills grill, /whips executes, stop conditions plus artifact create/read table honoring docs-layout; pointers from whips SKILL, wayfinder handoff, and README. Closes [#94](https://github.com/TudeOrangBiasa/skills-for-agents/issues/94).

- [#135](https://github.com/TudeOrangBiasa/skills-for-agents/pull/135) [`f83fe69`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/f83fe6926161ce3921b051ecde55d82cfd6fc344) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): trigger parity with pstack (how, why, swarm, arena, interrogate, show-me-your-work, technical-writing, control skill) plus comments rule, broken-skill rule, and full-autonomy grant clause; investigation and bug playbooks point at how/why and the verification surface. Pack plafond 3000 to 3200 for the added rows. Closes [#68](https://github.com/TudeOrangBiasa/skills-for-agents/issues/68).

- [#146](https://github.com/TudeOrangBiasa/skills-for-agents/pull/146) [`b0ddb30`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/b0ddb3020f214f19c8a5329ef9a2a2669e8934eb) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - feat(whips): machine-readable verdict marker and verdict-check for the optional high lane. Closes [#75](https://github.com/TudeOrangBiasa/skills-for-agents/issues/75).

### Patch Changes

- [#130](https://github.com/TudeOrangBiasa/skills-for-agents/pull/130) [`d38d240`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/d38d240f7a3257900ce244787d89ea664599643a) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: full artifact location contract in docs-layout.md template (create/read/path/lazy per artifact, verifier and repo-mode included); hillclimb log renamed to decisions.tsv with schema note; research defaults to docs/research/<slug>.md; show-me-your-work and create-verification point at the contract; COOKBOOK points readers at docs-layout.md after setup-meta. Closes [#106](https://github.com/TudeOrangBiasa/skills-for-agents/issues/106).

- [#133](https://github.com/TudeOrangBiasa/skills-for-agents/pull/133) [`6188266`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/6188266a1e751a5fb0ccdca8adbe775631a64eeb) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix: CI wording becomes configured verifier (pre-push plus CI, CI green batch, One root CI replaced); setup-pre-commit asks the user on empty toolchain instead of proposing oxlint; Section E points verify commands at verifier.md. Closes [#119](https://github.com/TudeOrangBiasa/skills-for-agents/issues/119).

- [#180](https://github.com/TudeOrangBiasa/skills-for-agents/pull/180) [`33af20e`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/33af20ef184efce5febad2a7803d7e9eb6c75f00) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs(cookbook): generic multi-domain examples, playbook-via-/whips wording for babysit and ready-check, wizard as model-invoked via Skill tool; README playbook count 25 to 30. Closes [#166](https://github.com/TudeOrangBiasa/skills-for-agents/issues/166).

- [#123](https://github.com/TudeOrangBiasa/skills-for-agents/pull/123) [`8f9ed7b`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/8f9ed7b0837d2272312f946da373a5cc1887b044) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - docs: add Credits section naming pstack/poteto-mode (Lauren Tan) for the execute path and Matt Pocock for the idea path, plus the pstack copyright line in LICENSE. Audit: skills crediting only Matt are genuinely Matt-forked (grill/spec/tickets path) or original; pstack-derived skills already credit poteto. Closes [#97](https://github.com/TudeOrangBiasa/skills-for-agents/issues/97).

- [#139](https://github.com/TudeOrangBiasa/skills-for-agents/pull/139) [`c1321d6`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/c1321d694c862647fa7a5e7260ac16f1cf38d319) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - deprecate: Matt execute path removed; no implement/implement-spec skills exist in tree; explain-diff-before-merge bannered deprecated from merge/ready-check/shipping/opening-a-pr with learning value folded to teach/interview; guide, FACTORY, and READMEs point execute at /whips only. Closes [#96](https://github.com/TudeOrangBiasa/skills-for-agents/issues/96).

- [#137](https://github.com/TudeOrangBiasa/skills-for-agents/pull/137) [`3c01024`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/3c01024c312a9e75f3d7fa21c1241cb7c7097ee6) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - enhancement(guide,ui-recording-timeline): progressive disclosure; guide SKILL.md becomes a thin index (4551 to 711 tokens) with read-only-what-fits pointers; ui-recording-timeline is disable-model-invocation with an explicit path from the whips ui playbook. Closes [#92](https://github.com/TudeOrangBiasa/skills-for-agents/issues/92).

- [#181](https://github.com/TudeOrangBiasa/skills-for-agents/pull/181) [`6528c76`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/6528c76361510b1b920306c9dda0398b11f0e307) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - removal: `/judgment-drill` deleted per [#93](https://github.com/TudeOrangBiasa/skills-for-agents/issues/93); A/B taste-drill covered by `/teach` interactive lessons and `/interview` decision stress-testing, no unique behavior folded over. Removes skill folder plus pointers in README, user-invoked README, guide router, and FACTORY ownership table. Closes [#93](https://github.com/TudeOrangBiasa/skills-for-agents/issues/93).

- [#125](https://github.com/TudeOrangBiasa/skills-for-agents/pull/125) [`d7cb7aa`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/d7cb7aa6adeddcda8f1e7ab1085716fb6bf785ca) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix: restore four lines dropped as collateral in [#124](https://github.com/TudeOrangBiasa/skills-for-agents/issues/124)/[#123](https://github.com/TudeOrangBiasa/skills-for-agents/issues/123): to-tickets real-tracker publish bullet, triage one-category-plus-state invariant, setup-meta Section B defaults definition, LICENSE TudeOrangBiasa fork holder.

- [#121](https://github.com/TudeOrangBiasa/skills-for-agents/pull/121) [`8ed999c`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/8ed999cfd2082980b91f3d3341e1357a8c83cb17) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix(runner): batch open PR list to one fetch per repo per run and filter candidates locally, with one refresh after each processed issue so its new PR is still seen. Closes [#87](https://github.com/TudeOrangBiasa/skills-for-agents/issues/87).

- [#148](https://github.com/TudeOrangBiasa/skills-for-agents/pull/148) [`910b767`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/910b767fd4d514cb0618831a09892b0cb6fe4ff2) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - chore(setup-meta): complete [#78](https://github.com/TudeOrangBiasa/skills-for-agents/issues/78) remainder (Section G opt-in, runner preset plus pause/resume, unattended Wake fields); templates landed in [#147](https://github.com/TudeOrangBiasa/skills-for-agents/issues/147). Closes [#78](https://github.com/TudeOrangBiasa/skills-for-agents/issues/78).

- [#177](https://github.com/TudeOrangBiasa/skills-for-agents/pull/177) [`c71eb3d`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/c71eb3d1cf1b6d8998c205eba22dddc65249522f) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix(setup-pre-commit): route slow gates to configured verifier instead of hardcoded here-and-in-CI. Closes [#168](https://github.com/TudeOrangBiasa/skills-for-agents/issues/168).

- [#178](https://github.com/TudeOrangBiasa/skills-for-agents/pull/178) [`b408eb7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/b408eb7056bfbc5fb964cf4271edecd1bfc3faeb) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix(credits): correct attribution for setup-pre-commit, retro, setup-ts-deep-modules to Matt Pocock upstream. Closes [#169](https://github.com/TudeOrangBiasa/skills-for-agents/issues/169).

- [#138](https://github.com/TudeOrangBiasa/skills-for-agents/pull/138) [`4dfaab6`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/4dfaab6fc561f179c538bd78a79d404ce15feff4) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - enhancement(user-manual): hygiene acceptance runs on the shipped local fixture (selftest plus demo-page preview), never a live consumer repo; [#14](https://github.com/TudeOrangBiasa/skills-for-agents/issues/14) already closed NOT_PLANNED via PR [#32](https://github.com/TudeOrangBiasa/skills-for-agents/issues/32), no action needed. Closes [#112](https://github.com/TudeOrangBiasa/skills-for-agents/issues/112).

- [#179](https://github.com/TudeOrangBiasa/skills-for-agents/pull/179) [`2fcad45`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/2fcad45c3eb6c072cf43859c849e2471bd987cc9) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - chore(whips): harness-agnostic autopilot wording, dedupe orchestrate router row, OMP as optional harness in credits. Closes [#165](https://github.com/TudeOrangBiasa/skills-for-agents/issues/165).

- [#134](https://github.com/TudeOrangBiasa/skills-for-agents/pull/134) [`36b901f`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/36b901fe72480a0002d990690d93dbe038643101) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - enhancement(scripts): whips always-on pack budget enforced locally in check-docs.sh (plafond 3000 tokens, current 2775); over-budget PRs fail in pre-commit with no Actions. Closes [#120](https://github.com/TudeOrangBiasa/skills-for-agents/issues/120).

- [#132](https://github.com/TudeOrangBiasa/skills-for-agents/pull/132) [`6124de7`](https://github.com/TudeOrangBiasa/skills-for-agents/commit/6124de7d599720b5d0e522bdaf1a0c9243da5793) Thanks [@TudeOrangBiasa](https://github.com/TudeOrangBiasa)! - fix(whips,runner): portability; RISK uses generic categories with stack examples in docs/agents/domain.md and the label-create command from issue-tracker.md; opening-a-pr, babysit, and runner stop fail-closed on missing docs/agents instead of silently falling back to gh. Closes [#118](https://github.com/TudeOrangBiasa/skills-for-agents/issues/118).

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
