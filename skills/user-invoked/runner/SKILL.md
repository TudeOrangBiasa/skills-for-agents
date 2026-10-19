---
description: Run ready-for-agent issue queues on any schedule through /whips intake, one fresh worktree each, landing per risk tier, with the agent and model you pick at setup.
disable-model-invocation: true
name: runner
---
# Runner

Loop runner for the agent-ready queue, on any schedule (cron, an interval loop, or one manual run; renamed from nightshift, which sounded nights-only). Hand the queue to an agent while nobody is watching. Distinct from `/worklog`, which designs personal workflows and never runs them, and from goal mode (`goal.md` playbook), which pursues one long goal: runner runs repo issue queues, nothing else. One script, [scripts/runner.sh](scripts/runner.sh), claims each `ready-for-agent` issue, runs `/whips` triage intake on it in a fresh worktree, and lands per the risk tier. The human reviews high-risk in the morning; low-risk already landed.

The agent command and the model are the user's choice, made once at setup and saved to a config file. Nothing is defaulted. [CONTRACT.md](CONTRACT.md) holds the config keys, commands, exit codes, and outcomes. Any scheduler can call `runner.sh run`; wiring one is out of scope here.

## 1. Check the repos

Each target repo needs the `/setup-meta` output: `docs/agents/issue-tracker.md` for the tracker and its commands, `docs/agents/triage-labels.md` for the label strings. The script reads both from the default branch on every run, so a rename in those docs takes effect without re-running setup.

A missing file falls back the way `/whips` `playbooks/opening-a-pr.md` does: `gh` and the canonical role names. Tell the user to run `/setup-meta` in that repo. A tracker with no CLI mapping (local markdown, or a freeform "other") is skipped and reported.

`/whips` must be reachable by the agent in each repo, installed per repo or globally.

## 2. Set up: detect, then ask

Run `scripts/runner.sh detect` and show the user what it found: agent CLIs on PATH, models read from harness configs, provider key env var names (never values), and per repo the tracker and label strings it resolved.

Then ask, one question at a time, leading with what detection found:

- Which agent command. Presets exist only for CLIs with a documented non-interactive mode; anything else, the user types.
- Which model. Never pick one for them.
- Which local clones to work on.
- An optional model allowlist. When set, a model outside it makes every command refuse.
- How many issues per run.

Save with `scripts/runner.sh setup --agent-cmd ... --model ... --repos ... [--allowlist ...] [--max-issues ...]`. In a terminal, the user can run `scripts/runner.sh setup` bare and answer the same questions there. A legacy nightshift config is honored once with a migration warning; re-running setup writes the new paths.

## 3. Prove one run

Run `scripts/runner.sh check`, then one `scripts/runner.sh run` while the user watches. Read the log it names and `scripts/runner.sh status` back to them: the outcome, the PR link, and anything kept for inspection.

## What a run guarantees

- One run per machine at a time (`flock`). Each issue is claimed with the tracker's own claim, assigning it to the authenticated user, and released when the run ends. Assigned issues are never picked.
- An issue with an open PR that says `Closes #N` is skipped. Failures count, and an issue stops being picked after the attempt cap until `reset`.
- A claim left by a run that died is released at the next start, so a missed run is picked up by the next one.
- Landing follows the risk tier: low-risk PASS lands in the run, the rest wait for `ready-check` or the human.
- Every issue appends one line to `runs.jsonl`; every run prints a one-line summary.

Never prompt during `run` or `check`; a missing config fails with a pointer to setup. Never enable auto-merge or close an issue.
