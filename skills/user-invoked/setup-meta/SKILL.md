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

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Plus three risk rows for agent PRs: `risk-low`, `risk-medium`, `risk-high` (mapped to `risk:low`, `risk:medium`, `risk:high` unless the tracker names them otherwise). Overrides work the same way: collect the tracker's names so `whips` applies existing labels instead of creating duplicates. On **yes**, write them as-is. Only if the user says no, usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`), collect the overrides so `triage` applies existing labels instead of creating duplicates.

**Section C: Domain docs.** Default to **single-context** (one `GLOSSARY.md` + `docs/adr/` at the repo root). This fits almost every repo; write it without asking.

Offer **multi-context** (a root `GLOSSARY-MAP.md` pointing to per-context `GLOSSARY.md` files) only when exploration found monorepo signals. Then confirm which layout they want. A repo that already carries `CONTEXT.md` / `CONTEXT-MAP.md` keeps those names (legacy); do not create `GLOSSARY.md` beside them.

**Section D: Meta docs.** Ask which repo-level meta docs to scaffold. Default posture is all yes; skip any the repo genuinely does not need (a repo with no UI skips `DESIGN.md`).

- **`DESIGN.md`** (Stitch format): machine-readable design tokens as YAML frontmatter (`colors`, `typography`, `rounded`, `spacing`, `components`) plus human-readable rationale in `##` sections in canonical order (Overview, Colors, Typography, Layout, Elevation & Depth, Shapes, Components, Do's and Don'ts). Full format reference: https://github.com/google-labs-code/design.md. Scaffold tokens from the existing UI (or the user's brand notes), then validate with `npx @google/design.md lint DESIGN.md` and fix errors before writing.
- **Coding standards file**: one file, agreed name. Default `CODING_STANDARDS.md`; accept `CONTRIBUTION.md` or `GUIDELINES.md` when the repo already leans that way. Draft it from the codebase (naming, module shape, test seams, what review checks) plus the user's stated rules.
- **Commit message format**: agree one format (default: conventional commits) and record it in the standards file.
- **PR body format**: no new file. Confirm the repo uses the `pr` skill shape (Summary visual, before/after Evidence, Merge Danger).

**Section E: Tooling.** Husky pre-commit hooks: call the Skill tool with "setup-pre-commit" (it detects the package manager, installs Husky + lint-staged + Prettier, and wires typecheck and tests). Only when the repo is a JS/TS project; skip otherwise.

**Section F: Models (optional).** Skip unless `whips` is installed. Ask one question:

> Do you want to pin a model per subagent role? (recommended: **no**, every subagent runs on whatever model you run the parent on)

On **no**, write nothing. On **yes**, read the harness config and environment for the model ids already available (config files, CLI `--help` or model list, provider env var names, never their values), show what you found, and ask which id goes on each role in [models.md](./models.md). Never suggest a model the user did not already have configured.

**Section G: Unattended runs.** Ask one question:

> How should unattended runs wake up? (recommended: the harness loop or wait command you already use)

Record the mechanism in `docs/agents/unattended.md`: the command or scheduler entry that re-invokes `/whips` (or the `runner` skill for queues), the run log convention (`.scratch/whips/<run>/log.md`, one row per iteration), and the budget habit (predicate first, stated iteration, hour, or PR cap). Point at `/runner` for issue-queue runs and the `goal` playbook for single-goal runs; both read this file.

Then ask two more, one at a time. Autonomy tier for this repo (the whips mode): strict HIT with every landing human-approved, or tiered auto-land with low-risk PASS PRs merging untouched (recommended: tiered, human time reserved for high-risk). Record it in `docs/agents/unattended.md`; it overrides the default where the repo chooses strictness. Scheduled maintenance: which jobs run on a schedule and how they wake (cron line, systemd timer, or the harness non-interactive/headless mode invoking a skill). Default proposal: `/retro` stale-docs sweep plus `/maintain-verification` upkeep daily via scheduled automation, proposals filed, never auto-applied. Record each job's command, cadence, and output sink in the same file.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to the repo's `AGENTS.md`
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/triage-labels.md` (the last only when `triage` is installed), and `docs/agents/unattended.md`
- The contents of `docs/agents/models.md`, only when Section F ran with **yes**

Let them edit before writing.

### 4. Write

Edit the repo's `AGENTS.md`, creating it if it does not exist.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

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

### Meta docs

[one-line summary of what was scaffolded: DESIGN.md, standards file name, commit format]. PR body needs no line: the `pr` skill is the format.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted. Include the `### Models` sub-block, and write `docs/agents/models.md`, only when Section F ran with **yes**. Always include the `### Unattended runs` sub-block, and always write `docs/agents/unattended.md`.

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md): GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md): local-markdown issue tracker
- [triage-labels.md](./triage-labels.md): label mapping (only if `triage` is installed)
- [domain.md](./domain.md): domain doc consumer rules + layout
- [models.md](./models.md): model per subagent role (only if Section F ran with **yes**)
- [unattended.md](./unattended.md): wake mechanism, run log convention, budget habit

Then write the repo-level meta docs agreed in Section D, at the repo root:

- `DESIGN.md`: tokens frontmatter plus rationale sections in canonical order. Lint it with `npx @google/design.md lint DESIGN.md` and fix errors before finishing.
- The coding standards file under its agreed name: naming, module shape, test seams, review checks, commit message format.

Then run Section E: call the Skill tool with "setup-pre-commit" when the repo qualifies.
For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete: which skills will now read from these files, which meta docs were scaffolded (`DESIGN.md`, standards file, commit format), whether pre-commit tooling was installed, and which wake mechanism unattended runs use. Mention they can edit `docs/agents/*.md` and the meta docs directly later; re-running this skill is only necessary if they want to switch trackers, restyle, or restart from scratch.
