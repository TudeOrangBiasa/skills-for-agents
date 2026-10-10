---
name: nightshift
description: "Work ready-for-agent issues unattended through /whips intake, one fresh worktree each, draft PRs only, with the agent and model you pick at setup."
disable-model-invocation: true
---

# Nightshift

Hand the agent-ready queue to an agent while nobody is watching. One script, [scripts/nightshift.sh](scripts/nightshift.sh), claims each `ready-for-agent` issue, runs `/whips` triage intake on it in a fresh worktree, and keeps only draft PRs. The human reviews in the morning, marks ready, and merges.

The agent command and the model are the user's choice, made once at setup and saved to a config file. Nothing is defaulted. [CONTRACT.md](CONTRACT.md) holds the config keys, commands, exit codes, and outcomes. Any scheduler can call `nightshift.sh run`; wiring one is out of scope here.

## 1. Check the repos

Each target repo needs the `/setup-meta` output: `docs/agents/issue-tracker.md` for the tracker and its commands, `docs/agents/triage-labels.md` for the label strings. The script reads both from the default branch on every run, so a rename in those docs takes effect without re-running setup.

A missing file falls back the way `/whips` `playbooks/opening-a-pr.md` does: `gh` and the canonical role names. Tell the user to run `/setup-meta` in that repo. A tracker with no CLI mapping (local markdown, or a freeform "other") is skipped and reported.

`/whips` must be reachable by the agent in each repo, installed per repo or globally.

## 2. Set up: detect, then ask

Run `scripts/nightshift.sh detect` and show the user what it found: agent CLIs on PATH, models read from harness configs, provider key env var names (never values), and per repo the tracker and label strings it resolved.

Then ask, one question at a time, leading with what detection found:

- Which agent command. Presets exist only for CLIs with a documented non-interactive mode; anything else, the user types.
- Which model. Never pick one for them.
- Which local clones to work on.
- An optional model allowlist. When set, a model outside it makes every command refuse.
- How many issues per run.

Save with `scripts/nightshift.sh setup --agent-cmd ... --model ... --repos ... [--allowlist ...] [--max-issues ...]`. In a terminal, the user can run `scripts/nightshift.sh setup` bare and answer the same questions there.

## 3. Prove one run

Run `scripts/nightshift.sh check`, then one `scripts/nightshift.sh run` while the user watches. Read the log it names and `scripts/nightshift.sh status` back to them: the outcome, the PR link, and anything kept for inspection.

## What a run guarantees

- One run per machine at a time (`flock`). Each issue is claimed with the tracker's own claim, assigning it to the authenticated user, and released when the run ends. Assigned issues are never picked.
- An issue with an open PR that says `Closes #N` is skipped. Failures count, and an issue stops being picked after the attempt cap until `reset`.
- A claim left by a run that died is released at the next start, so a missed or interrupted night is picked up by the next run.
- Draft only. A linked PR found ready is converted back to draft and the log says so.
- Every issue appends one line to `runs.jsonl`; every run prints a one-line summary.

Never prompt during `run` or `check`; a missing config fails with a pointer to setup. Never mark a PR ready, merge, enable auto-merge, or close an issue.
