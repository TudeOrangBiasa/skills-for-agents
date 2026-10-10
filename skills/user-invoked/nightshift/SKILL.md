---
name: nightshift
description: Run ready-for-agent issues unattended on a schedule through /whips triage intake, draft PRs only, with your own agent and model chosen once at setup. User-invoked.
disable-model-invocation: true
---
# Nightshift

Unattended issue runs while you sleep. A scheduler calls one script; the script picks `ready-for-agent` issues, hands each to `/whips` triage intake in a fresh worktree, and keeps only draft PRs. The agent CLI and the model are yours: chosen once at setup, saved to a config file, never guessed.

The script is `scripts/nightshift.sh`. Its full contract (config keys, commands, exit codes, state files, outcomes) is in [CONTRACT.md](CONTRACT.md). How to schedule it (Orca automation, systemd user timer, cron, by hand) is in [ADAPTERS.md](ADAPTERS.md).

## When the user types /nightshift

1. Check the preconditions, and stop with the fix when one fails:
   - `gh auth status` succeeds.
   - Each target repo has `/whips` and `/setup-meta` output (`docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`), or the agent CLI loads the skills globally. Missing means you tell the user to install the skills and run `/setup-meta` in that repo.
   - The ready label exists in each repo. Read the right-hand column of `docs/agents/triage-labels.md` for its real string.
2. Run `scripts/nightshift.sh detect`. Show the user what it found: agent CLIs on PATH, models read from harness configs (OpenCode, pi, OMP, Codex, Claude), and the names (never values) of provider key env vars.
3. Ask the user, one question at a time: which agent command, which model, which repos, the ready label, an optional model allowlist, an optional start window (`HH:MM-HH:MM`), and the max issues per run. Never pick for them. There is no default agent or model, and the script refuses to run without one.
4. Save the answers with `scripts/nightshift.sh setup --agent-cmd ... --model ... --repos ... [--allowlist ...] [--label ...] [--window ...] [--max-issues ...]`. In a real terminal the user can run `scripts/nightshift.sh setup` with no flags and answer the same questions interactively.
5. Prove it once: `scripts/nightshift.sh check`, then offer one manual `scripts/nightshift.sh run` while the user watches.
6. Ask which scheduler they want and set it up from [ADAPTERS.md](ADAPTERS.md). Only use features that file marks as verified.
7. Reply with the config path, the schedule, and how to read results (`scripts/nightshift.sh status`).

## What a run guarantees

- One run at a time per machine (`flock`), and one claim label per issue while it runs, so nothing is picked twice.
- Every issue gets its own worktree, detached at the default branch. The agent creates its branch per `/whips` `playbooks/opening-a-pr.md`.
- Draft PRs only, linked with `Closes #N`. A PR found open as ready is converted back to draft and the run log says so. Nightshift never marks ready and never merges.
- Missed nights are caught up: a run processes whatever is ready now, and a claim left by a crashed or interrupted run is released at the next start.
- Every run appends one JSON line per issue to `runs.jsonl` and prints a one-line summary for the scheduler to capture.

## Never

- Never prompt during `run` or `check`. Unattended runs read the saved config; a missing config fails with a message telling the user to run setup.
- Never hardcode or default an agent, model, or provider in the script, the config, or a scheduler unit. Example values in docs are examples.
- Never mark a PR ready, merge, or enable auto-merge, and never close an issue.
