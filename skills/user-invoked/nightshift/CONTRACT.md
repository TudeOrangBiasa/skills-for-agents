# Contract

What `scripts/nightshift.sh` reads, does, and writes. A scheduler needs only this file.

## Commands

| Command | Prompts | Does | Exit |
| --- | --- | --- | --- |
| `setup [flags]` | unless every value is a flag | Detects, asks, writes the config, validates it | 0 saved, 2 refused |
| `detect` | no | Agents on PATH, models in harness configs, provider env var names, per-repo tracker and labels | 0 |
| `check` | no | Is any issue eligible? | 0 yes, 1 no, 2 config error |
| `run` | no | Releases stale claims, works up to the per-run cap, prints a summary | 0 done or lock busy, 2 config error |
| `status [N]` | no | Config, last start and finish, last N outcomes | 0 |
| `reset <repo-dir>#<n>` | no | Clears an issue's failed attempts | 0 |

Setup flags: `--agent-cmd`, `--model`, `--repos`, `--allowlist`, `--max-issues`. Without a terminal, setup refuses unless `--agent-cmd` and `--model` are given.

## Config

`$NIGHTSHIFT_CONFIG`, else `~/.config/nightshift/config.sh`, written by setup. An env var of the same name overrides the file for one call.

| Key | Default | Meaning |
| --- | --- | --- |
| `NIGHTSHIFT_AGENT_CMD` | none, required | Shell command that runs the agent non-interactively |
| `NIGHTSHIFT_MODEL` | none, required | Passed to the command as `$NIGHTSHIFT_MODEL` |
| `NIGHTSHIFT_REPOS` | none, required | Space separated paths to local clones |
| `NIGHTSHIFT_MODEL_ALLOWLIST` | empty | Space separated; a model outside it refuses |
| `NIGHTSHIFT_MAX_ISSUES` | `1` | Issues per run |
| `NIGHTSHIFT_MAX_ATTEMPTS` | `2` | Failures before an issue waits for `reset` |
| `NIGHTSHIFT_TIMEOUT_MIN` | `120` | Per issue |
| `NIGHTSHIFT_STATE_DIR` | `~/.local/state/nightshift` | Lock, logs, history |
| `NIGHTSHIFT_WORK_DIR` | `~/.cache/nightshift` | Worktrees |

Label strings and tracker commands are not config. They come from each repo's `docs/agents/`.

## Per repo, per run

1. `git fetch`, then read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md` from the default branch.
2. The `# Issue tracker:` heading picks the CLI: GitHub is `gh`, GitLab is `glab`. Anything else is skipped as `unsupported_tracker`. A missing file means `gh`.
3. The right-hand column of the labels table gives the strings for `ready-for-agent` and `needs-info`. A missing file or row means the canonical role name.

## The agent command

Runs through `bash -c` in the worktree, stdin closed, output to the per-issue log, killed at the timeout. Exported: `NIGHTSHIFT_MODEL`, `NIGHTSHIFT_PROMPT`, `NIGHTSHIFT_PROMPT_FILE`, `NIGHTSHIFT_ISSUE`, `NIGHTSHIFT_WORKTREE`. An example, not a default:

```bash
NIGHTSHIFT_AGENT_CMD='opencode run --auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"'
NIGHTSHIFT_MODEL='opencode-go/muse-spark-1.3'
```

The allowlist only governs what nightshift launches. Pin the agent's own subagent or fallback models in the agent's config.

The prompt opens with `/whips` and asks for triage intake on exactly that issue, `opening-a-pr` to finish, never ready or merge, and no waiting for answers. It is saved beside the log.

## Outcomes

| Outcome | Meaning | Worktree | Attempts |
| --- | --- | --- | --- |
| `pr_opened` | An open PR or MR closes the issue | removed | cleared |
| `needs_info` | The issue now carries the needs-info label | removed | cleared |
| `timeout` | Killed at the timeout | kept | +1 |
| `no_pr` | Ended with neither | kept | +1 |
| `setup_failed` | `git worktree add` failed | none | +1 |
| `interrupted`, `recovered_pr` | A dead run's claim, released at the next start | | |
| `fetch_failed`, `unsupported_tracker` | The repo was skipped | | |

State lives under `NIGHTSHIFT_STATE_DIR`: `lock`, `active`, `attempts.json`, `runs.jsonl`, `last-start`, `last-finish`, `logs/`.

## Limits

- The lock is per machine; run nightshift from one machine.
- A PR counts as linked only when its body says `Closes`, `Fixes`, or `Resolves #N`.
- Needs `bash`, `git`, `jq`, `flock`, `timeout`, and the tracker CLI, authenticated.
