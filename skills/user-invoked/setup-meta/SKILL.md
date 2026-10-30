---
name: setup-meta
description: "Configure this repo for the skills: issue tracker, triage and risk labels, domain docs, design system file, coding standards, commit and PR formats, pre-commit tooling, and the unattended-run wake mechanism. Run once before first use of the other skills."
disable-model-invocation: true
---

# Setup Meta

Scaffold the per-repo configuration that the skills assume:

- **Issue tracker**: where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels**: the strings used for the five canonical triage roles
- **Domain docs**: where `GLOSSARY.md` and ADRs live, and the consumer rules for reading them
- **Models** (optional): which model each subagent role uses, for skills that spawn subagents

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config`: is this a GitHub repo? Which one?
- `AGENTS.md` at the repo root: does it exist? Is there already an `## Agent skills` section in it?
- `GLOSSARY.md` and `GLOSSARY-MAP.md` at the repo root (legacy names `CONTEXT.md` / `CONTEXT-MAP.md` mean the same files)
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/`: does this skill's prior output already exist?
- `.scratch/`: a sign that a local-markdown issue tracker convention is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals: a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. These are present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.
- Unattended wake options: what this harness offers for runs without the user watching (a loop or wait command, a watch on CI or refs, an outside scheduler). This decides Section G.
- Repo settings for team landing: `allow_auto_merge`, `delete_branch_on_merge`, branch protection, required checks (Section K; team only, solo skips as N/A).

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order. One section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section B when `triage` isn't installed, Section C when there's no monorepo).

**Section A: Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-tickets`, `triage`, and `to-spec` read from and write to it. They need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub**: issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab**: issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown**: issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.): ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

Record the choice in `docs/agents/issue-tracker.md`. The GitHub and GitLab templates carry a "PRs as a request surface" flag, defaulted **off**. Leave it off and don't raise it: a user who wants external PRs in the triage queue can flip the flag in the file later.

**Section B: Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you), since an uninstalled skill needs no labels.

If it is installed, ask exactly one question:

> Do you want to keep the default triage labels? (recommended: **yes**)

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Plus three risk rows for agent PRs: `risk-low`, `risk-medium`, `risk-high` (mapped to `risk:low`, `risk:medium`, `risk:high` unless the tracker names them otherwise). On **yes**, write them as-is and create `feature-request` and `deprecation` labels idempotently with the label-create command from `docs/agents/issue-tracker.md` (`gh label create --force` on GitHub) alongside the vocab so issue templates resolve. Only if the user says no, usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`), collect the overrides so `triage` applies existing labels instead of creating duplicates.

**Section C: Domain docs.** Default to **single-context** (one `GLOSSARY.md` + `docs/adr/` at the repo root). This fits almost every repo; write it without asking.

Offer **multi-context** (a root `GLOSSARY-MAP.md` pointing to per-context `GLOSSARY.md` files) only when exploration found monorepo signals. Then confirm which layout they want. A repo that already carries `CONTEXT.md` / `CONTEXT-MAP.md` keeps those names (legacy); do not create `GLOSSARY.md` beside them.

**Section D: Meta docs.** Ask which repo-level meta docs to scaffold. Default posture is all yes; skip any the repo genuinely does not need (a repo with no UI skips `DESIGN.md`).

- **`DESIGN.md`** (Stitch format): machine-readable design tokens as YAML frontmatter (`colors`, `typography`, `rounded`, `spacing`, `components`) plus human-readable rationale in `##` sections in canonical order (Overview, Colors, Typography, Layout, Elevation & Depth, Shapes, Components, Do's and Don'ts). Full format reference: https://github.com/google-labs-code/design.md. Scaffold tokens from the existing UI (or the user's brand notes), then validate with `npx @google/design.md lint DESIGN.md` and fix errors before writing.
- **Coding standards file**: one file, agreed name. Default `CODING_STANDARDS.md`; accept `CONTRIBUTION.md` or `GUIDELINES.md` when the repo already leans that way. Draft it from the codebase (naming, module shape, test seams, what review checks) plus the user's stated rules.
- **Commit message format**: agree one format (default: conventional commits) and record it in the standards file.
- **PR body format**: no new file. Confirm the repo uses the `pr` skill shape (Summary visual, before/after Evidence, Merge Danger).

**Section E: Tooling.** Local gates in four layers, no mandatory CI template (the verifier in `docs/agents/verifier.md` decides; Section I wires it): call the Skill tool with "setup-pre-commit" for JS/TS repos (fast pre-commit gate under 3 seconds: format, token gate, staged-file checks; commit-msg enforces Conventional Commits; typecheck and full tests move to pre-push plus the configured verifier). For non-JS repos, install shell hooks under `.githooks/` and point git at them with `git config core.hooksPath .githooks` (no new runtime, no new dependencies without confirmation): use only preset commands whose tools already exist in the repo. Dart: `dart format --set-exit-if-changed .` in pre-commit, `dart analyze` and `dart test` in pre-push. PHP/Laravel: `./vendor/bin/pint --test` (or `pint --test` when on PATH) in pre-commit, `phpstan` only when configured, `php artisan test` in pre-push. Python: project tools only when `pyproject.toml` declares them (format check in pre-commit, test command in pre-push). The `commit-msg` hook reuses the Conventional Commits shell from `setup-pre-commit` (merge and revert messages exempt). Record one line in `docs/agents/` naming the four layers and banning `--no-verify` for bypassing gates.

**Section F: Models (optional).** Skip unless `whips` is installed. Run six steps, one question per step, and never name a model id the user has not confirmed. Never hardcode a harness or model id into the skill; copy only what detection found. Answering inherit-everywhere at step 1 ends the section with nothing written.

1. **Detect.** Read the harness config and environment for model ids already available: config files, CLI `--help` or model list output, provider env var names without their values. `inherit` is always valid. Show what you found, nothing more.
> Which of these detected ids should roles use, or should every role inherit?
2. **Budget.** Offer four familiar levels plus `n/a`: `unlimited` (max), `large` (xhigh), `medium` (high), `small` (medium). Write the pick as a `# budget:` line in `docs/agents/models.md`. A harness that names no effort levels gets `n/a`, and every role runs at its plain model.
> Which budget fits the hardest work in this repo: unlimited, large, medium, small, or n/a?
3. **Map.** One model for every role is fine; effort carries the difference. Put the confirmed id (or `inherit`) on each row in [models.md](./models.md): `code`, `hard-code`, `judgment`, `review`, `how-explorer`, `how-explainer`, `why-investigator`, `why-synthesizer`, `swarm-worker`, `arena-runner`, `architect-runner`, `interrogate-reviewer`. `hard-code` sits one step above `code`; `swarm-worker` follows `review`.
> Same model everywhere, or a different id for any role?
4. **Validate.** Check every id against what detection found (`inherit` always passes), and check `review` is never effort-shifted below `code` per whips SKILL.md section 6 (shift effort one step up for the hardest work, never down for review). Fix mismatches with the user before writing.
5. **Write.** Rewrite `docs/agents/models.md` from [models.md](./models.md) in full on every run: no duplicated rows, retired roles deleted. Location is per repo (`docs/agents/models.md`); use the personal fallback only when the user explicitly asks for one config across repos, and record why.
6. **Confirm.** Show the written file and ask for corrections before moving on. Do not raise `/create-verification` here; the scaffold layout step owns that offer.

**Section G: Unattended runs (opt-in).** The skill never installs a harness by default; this section runs only when the user asks for unattended wake; otherwise write `Wake: none` in `docs/agents/unattended.md` and move on.

When asked, work in this order. Detect first: `command -v omp`, then read `omp --help` for the non-interactive flag, the session timeout, the structured output mode, and the approval flags. Copy only flags the help text documents; never guess them. Orca may be recorded as present, but it stays an optional note: never a requirement and never installed by this skill.

Configure the runner with `runner.sh setup --agent-cmd ... --model ... --repos ...` (model choice comes from Section F). Preview timers with `install-timers --dry-run`: it prints the four units rendered from the `systemd/` templates plus every command, and writes nothing. The templates use `Type=oneshot`, `EnvironmentFile`, an explicit `Environment=PATH=`, `TimeoutStartSec` from `RUNNER_TIMEOUT_MIN`, and timers use `Persistent=true`, `OnBootSec`, `OnUnitActiveSec`, `RandomizedDelaySec`.

Verify before enabling: `systemd-analyze --user verify` on each unit, one manual `systemctl --user start` probe, then read `journalctl --user -u ...`. Enable only after the user says yes (`--yes`); print `loginctl enable-linger $USER` as a step the user runs themselves when timers must survive logout. Re-runs are idempotent: an installed unit is a no-op. The kill switch is `runner.sh pause` (until `runner.sh resume`) plus `install-timers uninstall`, which removes only units carrying its managed marker. Without systemd, print the one-line `cron-line` fallback instead.

Record the wake choice, run log convention (`.scratch/whips/<run>/log.md`, one row per iteration), and budget habit (predicate first, stated iteration, hour, or PR cap) in `docs/agents/unattended.md`. Point at `/runner` for issue-queue runs; the skill reads this file.

**Section H: Repo mode (solo or team).** Ask one question:

> Is this a solo repo (you plus agents) or a team repo? (no default; skill behavior branches on it)

Write the answer to `docs/agents/repo-mode.md` from [repo-mode.md](./repo-mode.md): `mode: solo|team`. Behavior differs: solo merges after the local verifier passes without waiting on GitHub checks; team waits on CI like pstack. Playbooks read this file; a missing file means stop and tell the user to run `/setup-meta`.

**Section I: Verifier (solo) / CI (team).** First ask once (only when no `skills/verify-*` exists yet): run `/create-verification` now or later; never auto-generate without an answer. Solo: generate or wire the per-project verifier via the Skill tool with "create-verification", write its command to `docs/agents/verifier.md` from [verifier.md](./verifier.md) (PASS = exit 0), install a pre-push hook that runs that command and refuses the push on nonzero exit, and copy the hook into every new worktree at creation time (worktree setup is incomplete without it). Team: skip this section and point at CI running the same command plus a PR-title check. Never force Actions onto this repo. Agents never run `git push --no-verify`.

**Section J: Docs layout.** After Sections A through I, scaffold the canonical docs layout, idempotently. Dirs (create with `.gitkeep` where empty): `docs/adr/`, `docs/research/`, `docs/agents/`, `.scratch/whips/`, `.audit/`. `.gitignore` append (skip lines already present; re-run adds nothing): `.scratch/`, `.audit/`, `decisions.tsv`, `**/decisions.tsv`; never ignore `docs/` or `skills/verify-*/`. Write `docs/agents/docs-layout.md` from [docs-layout.md](./docs-layout.md) and add a `### Docs layout` line to the `## Agent skills` block pointing at it. Content stays lazy: ADR bodies, `GLOSSARY.md`, `skills/verify-*/`, `workflows/*.md` are not scaffolded, only their parent dirs with `.gitkeep`.

Then ask two more, one at a time. Autonomy tier for this repo (the whips mode): strict HIT with every landing human-approved, or tiered auto-land with low-risk PASS PRs merging untouched (recommended: tiered, human time reserved for high-risk). Record it in `docs/agents/unattended.md`; it overrides the default where the repo chooses strictness. Scheduled maintenance: which jobs run on a schedule and how they wake (cron line, systemd timer, or the harness non-interactive/headless mode invoking a skill). Default proposal: `/retro` stale-docs sweep plus `/maintain-verification` upkeep daily via scheduled automation, proposals filed, never auto-applied. Record each job's command, cadence, and output sink in the same file.

**Section K: Repo settings (team only, solo skips).** Skip entirely when Section H answered **solo**: say "Repo settings are N/A in solo mode, the local verifier decides landing" and move on. For **team** repos, ask one question:

> May I check the forge settings this repo needs for landing, and apply what is missing? (recommended: **yes to check**, apply only after you confirm each change)

Run `whips/scripts/repo-settings check --landing <auto-merge|direct>` (read-only). The Landing value comes from `docs/agents/unattended.md`: `auto-merge` arms `gh pr merge --auto --squash` on open and lands when required checks pass; `direct` merges with `gh pr merge --squash` after CI is green and a read-back shows `state: MERGED`. Refuse `auto-merge` when required checks are empty: write the `needs-human` marker `<!-- needs-human reason=no-required-checks -->` and tell the user to enable branch protection first. On user yes, run `repo-settings apply --dry-run` first, show the exact calls, then `apply --yes` only after the user confirms. Without admin rights the script prints UI steps instead of changing anything; never work around that. Record the outcome in `docs/agents/unattended.md` (`Landing:` line) and in the `### Landing` sub-block of the `## Agent skills` block. Re-run is a no-op when settings already match.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to the repo's `AGENTS.md`
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/triage-labels.md` (the last only when `triage` is installed), `docs/agents/unattended.md`, `docs/agents/repo-mode.md`, and `docs/agents/verifier.md` (the last only for solo repos)
- The contents of `docs/agents/models.md`, only when Section F ran with **yes**
- The `repo-settings check` output, only for team repos (Section K)

Let them edit before writing.

### 4. Write

Edit the repo's `AGENTS.md`, creating it if it does not exist.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections. On re-run, detect legacy landing text ("Open PRs as drafts", "never merge a `risk:high`", "agents must never merge"): show it to the user and offer the replacement; never silently overwrite.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Models

[one line: which roles are pinned]. See `docs/agents/models.md`.

### Unattended runs

[one line: the wake mechanism]. See `docs/agents/unattended.md`.

### Repo mode

[one line: solo or team]. See `docs/agents/repo-mode.md`.

### Verifier

[one line: the verify command]. See `docs/agents/verifier.md` (solo repos).

### Docs layout

One door into where skills write and read. See `docs/agents/docs-layout.md`.

### Landing

[one line: solo verifier or team checks plus the repo-settings outcome (Section K)]. See `docs/agents/landing-policy.md`.

### Meta docs

[one-line summary of what was scaffolded: DESIGN.md, standards file name, commit format]. PR body needs no line: the `pr` skill is the format.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted. Include the `### Models` sub-block, and write `docs/agents/models.md`, only when Section F ran with **yes**. Include the `### Verifier` sub-block, and write `docs/agents/verifier.md`, only for solo repos. Always include the `### Unattended runs`, `### Repo mode`, `### Docs layout`, and `### Landing` sub-blocks, and always write `docs/agents/unattended.md`, `docs/agents/repo-mode.md`, `docs/agents/docs-layout.md`, and `docs/agents/landing-policy.md`.

Then write the docs files using the seed templates in this skill folder as a starting point:

- [repo-mode.md](./repo-mode.md): solo or team (Section H, always)
- [verifier.md](./verifier.md): verify command (Section I, solo only)
- [docs-layout.md](./docs-layout.md): map of where skills write and read (Section J, always)
- [landing-policy.md](./landing-policy.md): landing rules reading repo-mode plus verifier (always)
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md): local-markdown issue tracker
- [triage-labels.md](./triage-labels.md): label mapping (only if `triage` is installed)
- [domain.md](./domain.md): domain doc consumer rules + layout
- [models.md](./models.md): model per subagent role (only if Section F ran with **yes**)
- [unattended.md](./unattended.md): wake mechanism, run log convention, budget habit

Then write the repo-level meta docs agreed in Section D, at the repo root:

- `DESIGN.md`: tokens frontmatter plus rationale sections in canonical order. Lint it with `npx @google/design.md lint DESIGN.md` and fix errors before finishing.
- The coding standards file under its agreed name: naming, module shape, test seams, review checks, commit message format.

Then scaffold the Section J docs layout (dirs with `.gitkeep`, `.gitignore` append, `docs-layout.md`, AGENTS pointer) and run Section I (solo verifier + pre-push + worktree hooks) or skip it for team repos.

Then run Section E: call the Skill tool with "setup-pre-commit" for JS/TS repos, or install the `.githooks/` shell presets for non-JS repos.
For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete: which skills will now read from these files, which meta docs were scaffolded (`DESIGN.md`, standards file, commit format), whether pre-commit tooling was installed, and which wake mechanism unattended runs use. Mention they can edit `docs/agents/*.md` and the meta docs directly later; re-running this skill is only necessary if they want to switch trackers, restyle, or restart from scratch.
