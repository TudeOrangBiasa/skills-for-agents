# Contract

What `scripts/runner.sh` reads, does, and writes. A scheduler needs only this file. Renamed from nightshift: `RUNNER_*` names and `~/.config/runner` paths are current; a legacy nightshift config file or env is honored once with a warning, then re-run setup to migrate.

## Commands

| Command | Prompts | Does | Exit |
| --- | --- | --- | --- |
| `setup [flags]` | unless every value is a flag | Detects, asks, writes the config, validates it | 0 saved, 2 refused |
| `detect` | no | Agents on PATH, models in harness configs, provider env var names, per-repo tracker and labels | 0 |
| `check` | no | Is any issue eligible? | 0 yes, 1 no, 2 config error |
| `run` | no | Reaps orphan claims from GitHub markers, works up to the per-run cap, prints a summary | 0 done or lock busy, 2 config error |
| `pause` | no | Writes the stop file; `run` and `check` exit quietly until `resume` | 0 |
| `resume` | no | Removes the stop file | 0 |
| `status [N]` | no | Config, last start and finish, last N outcomes | 0 |
| `reset <repo-dir>#<n>` | no | Writes a reset marker on GitHub, clears the cached attempts | 0 |
| `triage [--dry-run]` | no | Labels up to the triage cap of intake issues per repo, prints a summary | 0 done or lock busy, 2 config error |

Setup flags: `--agent-cmd`, `--model`, `--repos`, `--allowlist`, `--max-issues`. Without a terminal, setup refuses unless `--agent-cmd` and `--model` are given.

## Config

`$RUNNER_CONFIG`, else `~/.config/runner/config.sh`, written by setup. An env var of the same name overrides the file for one call.

| Key | Default | Meaning |
| --- | --- | --- |
| `RUNNER_AGENT_CMD` | none, required | Shell command that runs the agent non-interactively |
| `RUNNER_MODEL` | none, required | Passed to the command as `$RUNNER_MODEL` |
| `RUNNER_REPOS` | none, required | Space separated paths to local clones |
| `RUNNER_MODEL_ALLOWLIST` | empty | Space separated; a model outside it refuses |
| `RUNNER_MAX_ISSUES` | `1` | Issues per run |
| `RUNNER_MAX_ATTEMPTS` | `2` | Failures before an issue waits for `reset` |
| `RUNNER_TIMEOUT_MIN` | `120` | Per issue |
| `RUNNER_CLAIM_TTL_MIN` | timeout + 30 | A claim older than this with no fresh branch commit is an orphan |
| `RUNNER_STATE_DIR` | `~/.local/state/runner` | Lock, logs, history |
| `RUNNER_WORK_DIR` | `~/.cache/runner` | Worktrees |
| `RUNNER_TRIAGE_PER_TICK` | `3` | Intake issues labeled per repo per `triage` tick |
| `RUNNER_TRIAGE_AGENT_DECIDE` | `0` | `1` lets an ambiguous case use one agent call, else it goes to the human label |
| `RUNNER_TRIAGE_LIST_LIMIT` | `60` | Open issues fetched in the single intake list call |

Label strings and tracker commands are not config. They come from each repo's `docs/agents/`.

## Per repo, per run

1. `git fetch`, then read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md` from the default branch.
2. The `# Issue tracker:` heading picks the CLI: GitHub is `gh`, GitLab is `glab`. Anything else is skipped as `unsupported_tracker`. A missing file means `gh`.
3. The right-hand column of the labels table gives the strings for `ready-for-agent` and `needs-info`. A missing file or row means the canonical role name.

## The agent command

Runs through `bash -c` in the worktree, stdin closed, output to the per-issue log, killed at the timeout. Exported: `RUNNER_MODEL`, `RUNNER_PROMPT`, `RUNNER_PROMPT_FILE`, `RUNNER_ISSUE`, `RUNNER_WORKTREE`, `RUNNER_RESUME_BRANCH` (empty on a fresh start). An example, not a default:

```bash
RUNNER_AGENT_CMD='opencode run --auto -m "$RUNNER_MODEL" "$RUNNER_PROMPT"'
RUNNER_MODEL='opencode-go/muse-spark-1.3'
```

The allowlist only governs what the runner launches. Pin the agent's own subagent or fallback models in the agent's config.

Documented `omp` preset (flags read from `omp --help`, not guessed): `omp -p --max-time "$RUNNER_TIMEOUT_MIN"m --mode text --auto-approve --model "$RUNNER_MODEL" "$RUNNER_PROMPT"`. Orca is never a dependency: setup-meta may note its presence, but nothing requires or installs it.

The prompt opens with `/whips` and asks for triage intake on exactly that issue, `opening-a-pr` to finish with tiered landing, and no waiting for answers. It is saved beside the log. When prior work exists on the claim branch or `wip/runner-issue-N`, the worktree checks that branch out and the prompt routes to `pickup` instead: continue from this branch, do not create a new one.

## Outcomes

| Outcome | Meaning | Worktree | Attempts |
| --- | --- | --- | --- |
| `pr_opened` | An open PR or MR closes the issue | removed | cleared |
| `needs_info` | The issue now carries the needs-info label | removed | cleared |
| `timeout` | Killed at the timeout | removed after a `wip/runner-issue-N` push | +1 |
| `no_pr` | Ended with neither | removed after a `wip/runner-issue-N` push | +1 |
| `setup_failed` | `git worktree add` failed | none | +1 |
| `interrupted` | An orphan claim, released at the next start | | +1 |
| `fetch_failed`, `unsupported_tracker` | The repo was skipped | | |

State lives under `RUNNER_STATE_DIR`: `lock`, `active`, `attempts.json`, `runs.jsonl`, `last-start`, `last-finish`, `logs/`. `attempts.json` is a cache; the count of record lives on GitHub.

## GitHub markers (durable state)

On `gh` repos the runner writes machine-readable comments on the issue. Only comments authored by the authenticated user count. Deleting the state dir or rebooting changes nothing: the next run reads the same markers.

- `<!-- runner-attempt n=<k> outcome=<timeout|no_pr|setup_failed|interrupted> -->`: one per failed attempt, appended after the outcome is known. The count is the highest `n` from the authenticated user, or zero after a reset marker.
- `<!-- runner-attempt reset -->`: written by `reset`. Markers before it stop counting.
- `<!-- runner-claim run=<id> ts=<epoch> branch=<name> -->`: one per claim, naming the worktree branch. The run id matches the log file name.

The reaper at the start of `run` releases an orphan claim only when all of these hold: the marker age passes `RUNNER_CLAIM_TTL_MIN`, the authenticated user is the sole assignee, no open PR closes the issue, and the recorded branch has no commit newer than the TTL. A human assignee blocks the reaper. The reaper scans both the legacy `active` file and open issues assigned to the authenticated user.

`timeout` and `no_pr` push their work before the worktree is removed: one `wip:` commit when the tree is dirty (per `pause.md`), then a push to `wip/runner-issue-N`. The next run checks that branch out and resumes through `pickup` instead of starting over.

## Limits

- One machine per bot account is the supported shape. Two machines running `run` together are not safe: the lock is local (`flock`), so both can claim and push at once. That is a scope decision, not a bug.
- A PR counts as linked only when its body says `Closes`, `Fixes`, or `Resolves #N`.
- The open PR list is fetched once per repo per run and filtered locally, so filtering N candidates costs one API call. One refresh follows each processed issue to see its new PR.
- Needs `bash`, `git`, `jq`, `flock`, `timeout`, and the tracker CLI, authenticated.

## Triage

`triage` walks the same three intake buckets `/triage` shows: unlabeled issues, the needs-triage role, and the needs-info role with reporter activity. Oldest first, capped per repo at `RUNNER_TRIAGE_PER_TICK`. The tick never touches issues already carrying the ready or human role, so a re-run is a no-op on them. A `stop` file in the state dir ends the tick with exit 0, the same kill switch pause/resume writes. `--dry-run` prints each decision plus the comment file path and mutates nothing.

One tick costs one list call per repo plus at most four calls per triaged issue (view, label edit, risk label edit, comment) and zero agent spawns unless `RUNNER_TRIAGE_AGENT_DECIDE=1`, in which case at most one spawn per ambiguous issue. Exact-title duplicate matching is local against the same intake list, so it adds zero calls. Comment bodies travel via `--body-file`, never as argv. The tick never closes an issue, never merges, and never writes code. Outcomes land in `runs.jsonl` as `triaged_complete`, `triaged_incomplete`, `triaged_product-call`, or `triaged_duplicate-of`.
