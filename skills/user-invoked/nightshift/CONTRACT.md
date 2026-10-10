# Nightshift contract

The script any scheduler calls. Everything a runner needs is here; adapters in `ADAPTERS.md` only decide when to call it.

## Commands

| Command | Interactive | What it does | Exit |
| --- | --- | --- | --- |
| `nightshift.sh setup [flags]` | yes, unless every value comes in by flag | Detects agents and models, asks, writes the config, validates it | 0 saved, 2 refused |
| `nightshift.sh detect` | no | Prints agents on PATH, models from harness configs, provider env var names | 0 |
| `nightshift.sh check` | no | Is at least one issue eligible? For scheduler prechecks | 0 yes, 1 no, 2 config error |
| `nightshift.sh run` | no | Releases stale claims, runs up to `NIGHTSHIFT_MAX_ISSUES` issues, prints a summary | 0 done or lock busy, 2 config error |
| `nightshift.sh status [N]` | no | Last start and finish, config, active claims, last N outcomes | 0 |
| `nightshift.sh reset owner/repo#N` | no | Forgets failed attempts so the issue is eligible again | 0 |

Setup flags: `--agent-cmd`, `--model`, `--repos`, `--allowlist`, `--label`, `--window`, `--max-issues`. With no terminal and no `--agent-cmd` or `--model`, setup refuses rather than guessing.

## Config

One shell file, written by setup: `$NIGHTSHIFT_CONFIG`, else `${XDG_CONFIG_HOME:-~/.config}/nightshift/config.sh`. Environment variables of the same name override the file for one call.

| Key | Required | Default | Meaning |
| --- | --- | --- | --- |
| `NIGHTSHIFT_AGENT_CMD` | yes | none | Shell command that runs your agent non-interactively in the worktree |
| `NIGHTSHIFT_MODEL` | yes | none | Model id passed to the command as `$NIGHTSHIFT_MODEL` |
| `NIGHTSHIFT_REPOS` | yes | none | Space separated `owner/repo` list |
| `NIGHTSHIFT_MODEL_ALLOWLIST` | no | empty | Space separated ids. When set, a model outside it makes every command refuse |
| `NIGHTSHIFT_READY_LABEL` | no | `ready-for-agent` | Use your `triage-labels.md` string |
| `NIGHTSHIFT_CLAIM_LABEL` | no | `nightshift-claimed` | Created on first claim if missing |
| `NIGHTSHIFT_NEEDS_INFO_LABEL` | no | `needs-info` | How a thin-brief outcome is recognized |
| `NIGHTSHIFT_MAX_ISSUES` | no | `1` | Issues per run |
| `NIGHTSHIFT_MAX_ATTEMPTS` | no | `2` | Failed attempts before an issue is skipped until `reset` |
| `NIGHTSHIFT_TIMEOUT_MIN` | no | `120` | Per issue; the agent is killed after it |
| `NIGHTSHIFT_WINDOW` | no | empty | `HH:MM-HH:MM`, may wrap midnight. New issues start only inside it |
| `NIGHTSHIFT_ENFORCE_DRAFT` | no | `1` | Convert a non-draft linked PR back to draft |
| `NIGHTSHIFT_NOTIFY_CMD` | no | empty | Shell command run after each run with `$NIGHTSHIFT_SUMMARY` |
| `NIGHTSHIFT_STATE_DIR` | no | `${XDG_STATE_HOME:-~/.local/state}/nightshift` | Lock, logs, history |
| `NIGHTSHIFT_WORK_DIR` | no | `${XDG_CACHE_HOME:-~/.cache}/nightshift` | Repo clones and worktrees |

There is no default agent, model, or provider. A missing required key fails with a message that names it and points at `setup`.

### What the agent command sees

It runs through `bash -c` with the worktree as its working directory, stdin closed, and these variables exported: `NIGHTSHIFT_MODEL`, `NIGHTSHIFT_PROMPT` (the full prompt text), `NIGHTSHIFT_PROMPT_FILE`, `NIGHTSHIFT_REPO`, `NIGHTSHIFT_ISSUE`, `NIGHTSHIFT_WORKTREE`. Its stdout and stderr go to the per-issue log. Example values, not defaults:

```bash
# OpenCode (https://opencode.ai/docs/cli/)
NIGHTSHIFT_AGENT_CMD='opencode run --auto -m "$NIGHTSHIFT_MODEL" "$NIGHTSHIFT_PROMPT"'
NIGHTSHIFT_MODEL='opencode-go/muse-spark-1.3'
NIGHTSHIFT_MODEL_ALLOWLIST='opencode-go/muse-spark-1.3'
```

The allowlist stops nightshift from launching a model you did not approve. Whether the agent itself can switch models mid-run (subagents, a separate small model for titles) is the agent's setting, so pin it there too. For OpenCode that is `enabled_providers` and `small_model` in its config, which `OPENCODE_CONFIG_CONTENT` can set for nightshift runs only ([OpenCode config](https://opencode.ai/docs/config/)).

### The prompt

Each issue gets a prompt that starts with `/whips` and asks for `playbooks/triage.md` intake on exactly that issue, in that worktree, ending with `playbooks/opening-a-pr.md` (draft, `Closes #N`), never ready or merge, and no waiting for answers. Scheduling nightshift is the user's standing request to run `/whips` this way. The prompt is saved next to the log as `*.prompt.md`.

## One run, step by step

1. Load the config; refuse on a missing key or an allowlist miss.
2. Take `state/lock` with `flock -n`. Busy means another run is active: exit 0.
3. Release stale claims listed in `state/active` (a run that died, or a laptop that went to sleep mid-run). An issue with a linked PR is recorded `recovered_pr`; otherwise `interrupted` and one attempt is counted.
4. List open issues with the ready label across repos, oldest first, skipping assigned ones, claimed ones, ones at the attempt cap, and ones that already have an open PR whose body says `Closes|Fixes|Resolves #N`.
5. Per issue, while under `NIGHTSHIFT_MAX_ISSUES` and inside `NIGHTSHIFT_WINDOW`: add the claim label, fetch, add a detached worktree, run the agent under `timeout`.
6. Classify, release the claim label, record:

| Outcome | Meaning | Worktree | Attempts |
| --- | --- | --- | --- |
| `pr_opened` | An open PR links the issue | removed | cleared |
| `needs_info` | The issue now has the needs-info label | removed | cleared |
| `timeout` | The agent hit `NIGHTSHIFT_TIMEOUT_MIN` | kept | +1 |
| `no_pr` | The agent ended with no linked PR | kept | +1 |
| `setup_failed` | Clone, fetch, or worktree failed | none | +1 |
| `interrupted`, `recovered_pr` | Written by step 3 | | |

7. Print `nightshift: N issue(s): ...` and run `NIGHTSHIFT_NOTIFY_CMD` if set.

## State files

Under `NIGHTSHIFT_STATE_DIR`: `lock`, `active` (claims in flight), `attempts.json`, `runs.jsonl` (one object per issue: `ts`, `repo`, `issue`, `outcome`, `pr`, `model`, `log`, `detail`), `last-start`, `last-finish`, and `logs/` (agent output plus the prompt). Kept worktrees under `NIGHTSHIFT_WORK_DIR/worktrees` are yours to inspect and delete.

## Limits

- Locking is per machine. Two machines running nightshift on the same repos can race between listing and claiming; run it on one machine.
- A PR is linked by its body text. A PR that never says `Closes #N` reads as `no_pr`.
- Needs `bash`, `gh` (authenticated), `git`, `jq`, `flock`, and `timeout` (util-linux and coreutils on Linux).
