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
| `fix-ci [--dry-run]` | no | Team repos only: claims red or conflicted PRs, runs the agent once per claim | 0 done or lock busy, 2 config error |

Setup flags: `--agent-cmd`, `--model`, `--repos`, `--allowlist`, `--max-issues`. Without a terminal, setup refuses unless every value comes from flags or a consumer `docs/agents/harness.md`.

## Config

`$RUNNER_CONFIG`, else `~/.config/runner/config.sh`, written by setup as a thin override. An env var of the same name overrides the file for one call.

The shared record lives in each consumer repo's `docs/agents/harness.md` (same shape as the `setup-repo` harness.md template): `- **Agent command:**` and `- **Model:**` lines, written by setup, read on every run like `repo-mode.md`. Precedence for `RUNNER_AGENT_CMD` and `RUNNER_MODEL`: host env, then the override file, then the first consumer harness doc. Nothing is defaulted: no preset table ships, and setup never invents a harness name.

| Key | Default | Meaning |
| --- | --- | --- |
| `RUNNER_AGENT_CMD` | none, required | Shell command that runs the agent non-interactively |
| `RUNNER_MODEL` | none, required | Passed to the command as `$RUNNER_MODEL` |
| `RUNNER_MODEL_ALLOWLIST` | empty | Space separated; a model outside it refuses |
| `RUNNER_MAX_ISSUES` | `1` | Issues per run |
| `RUNNER_MAX_ATTEMPTS` | `2` | Failures before an issue waits for `reset` |
| `RUNNER_TIMEOUT_MIN` | `120` | Per issue |
| `RUNNER_CLAIM_TTL_MIN` | timeout + 30 | A claim older than this with no fresh branch commit is an orphan |
| `RUNNER_STATE_DIR` | `~/.local/state/runner` | Lock, logs, history |
| `RUNNER_WORK_DIR` | `~/.cache/runner` | Worktrees |
| `RUNNER_TRIAGE_PER_TICK` | `3` | Intake issues labeled per repo per `ship-triage` tick |
| `RUNNER_TRIAGE_AGENT_DECIDE` | `0` | `1` lets an ambiguous case use one agent call, else it goes to the human label |
| `RUNNER_TRIAGE_LIST_LIMIT` | `60` | Open issues fetched in the single intake list call |
| `RUNNER_FIX_MAX_ATTEMPTS` | `3` | Fix attempts per PR before the human label lands |
| `RUNNER_FIX_AUTHORS` | empty | Space separated PR authors fix-ci may touch; empty means the bot only |
| `RUNNER_FIX_PER_PASS` | `10` | Claims per fix-ci pass at most |
| `RUNNER_AGENT_PROBES` | empty | Space separated binary names `detect` echoes from PATH (opaque, never templates) |

Label strings and tracker commands are not config. They come from each repo's `docs/agents/`.

## Per repo, per run

1. `git fetch`, then read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md` from the default branch.
2. The `# Issue tracker:` heading picks the CLI: GitHub is `gh`, GitLab is `glab`. Anything else is skipped as `unsupported_tracker`. A missing file means `gh`.
3. The right-hand column of the labels table gives the strings for `ready-for-agent` and `needs-info`. A missing file or row means the canonical role name.

## The agent command

Runs through `bash -c` in the worktree, stdin closed, output to the per-issue log, killed at the timeout. Exported: `RUNNER_MODEL`, `RUNNER_PROMPT`, `RUNNER_PROMPT_FILE`, `RUNNER_ISSUE`, `RUNNER_WORKTREE`, `RUNNER_RESUME_BRANCH` (empty on a fresh start).

Setup detects or asks: it reads the agent command and model from flags, from the consumer repo's `docs/agents/harness.md`, or from the user's answers in a terminal, then persists them to the consumer repos plus a thin host override. The contract only requires `$RUNNER_AGENT_CMD` and `$RUNNER_MODEL`; no preset table ships, and detection never names a harness or reads harness-owned config paths.

The allowlist only governs what the runner launches. Pin the agent's own subagent or fallback models in the agent's config.

The prompt opens with `/whips` and asks for ship-triage intake on exactly that issue, `opening-a-pr` to finish with tiered landing, and no waiting for answers. It is saved beside the log. When prior work exists on the claim branch or `wip/runner-issue-N`, the worktree checks that branch out and the prompt routes to `pickup` instead: continue from this branch, do not create a new one.

## Outcomes

| Outcome | Meaning | Worktree | Attempts |
| --- | --- | --- | --- |
| `pr_opened` | An open PR or MR closes the issue | removed | cleared |
| `needs_info` | The issue now carries the needs-info label | removed | cleared |
| `timeout` | Killed at the timeout | removed after a `wip/runner-issue-N` push | +1 |
| `no_pr` | Ended with neither | removed after a `wip/runner-issue-N` push | +1 |
| `setup_failed` | `git worktree add` failed | none | +1 |
| `interrupted` | An orphan claim, released at the next start | | +1 |
| `claim_lost` | A lost claim race, backed off after the re-read (no agent launch) | none | unchanged |

State lives under `RUNNER_STATE_DIR`: `lock`, `active`, `attempts.json`, `runs.jsonl`, `last-start`, `last-finish`, `logs/`. `attempts.json` is a cache; the count of record lives on GitHub.

## GitHub markers (durable state)

On `gh` repos the runner writes machine-readable comments on the issue. Only comments authored by the authenticated user count. Deleting the state dir or rebooting changes nothing: the next run reads the same markers.

- `<!-- runner-attempt n=<k> outcome=<timeout|no_pr|setup_failed|interrupted> -->`: one per failed attempt, appended after the outcome is known. The count is the highest `n` from the authenticated user, or zero after a reset marker.
- `<!-- runner-attempt reset -->`: written by `reset`. Markers before it stop counting.
- `<!-- runner-claim run=<id> ts=<epoch> branch=<name> -->`: one per claim, naming the worktree branch. The run id matches the log file name.

The reaper at the start of `run` releases an orphan claim only when all of these hold: the marker age passes `RUNNER_CLAIM_TTL_MIN`, the authenticated user is the sole assignee, no open PR closes the issue, and the recorded branch has no commit newer than the TTL. A human assignee blocks the reaper. The reaper scans both the legacy `active` file and open issues assigned to the authenticated user.

After every assign write, the runner re-reads the issue before launching the agent (check-after-write). It proceeds only when it is the sole assignee with no fresher same-login marker this tick, or the earliest claimant by claim-marker timestamp (run id breaks ties). Otherwise it unassigns itself when another login holds the claim, skips the issue this tick with outcome `claim_lost`, and launches nothing. The local `flock` still serializes one machine; the re-read is the cross-machine safety net.

`timeout` and `no_pr` push their work before the worktree is removed: one `wip:` commit when the tree is dirty (per `pause.md`), then a push to `wip/runner-issue-N`. The next run checks that branch out and resumes through `pickup` instead of starting over.

## Limits

- One machine per bot account is the supported shape. Two machines running `run` together serialize only through the claim re-read: the loser backs off with `claim_lost`, so at most one agent works an issue per tick. The lock is local (`flock`); the re-read is the cross-machine net, not a queue.
- A PR counts as linked only when its body says `Closes`, `Fixes`, or `Resolves #N`.
- The open PR list is fetched once per repo per run and filtered locally, so filtering N candidates costs one API call. One refresh follows each processed issue to see its new PR. Each claim adds a re-read (assignees plus claim markers) before the agent launches.
- Needs `bash`, `git`, `jq`, `flock`, `timeout`, and the tracker CLI, authenticated.

## Triage

`ship-triage` walks the same three intake buckets `/ship-triage` shows: unlabeled issues, the needs-triage role, and the needs-info role with reporter activity. Oldest first, capped per repo at `RUNNER_TRIAGE_PER_TICK`. The tick never touches issues already carrying the ready or human role, so a re-run is a no-op on them. A `stop` file in the state dir ends the tick with exit 0, the same kill switch pause/resume writes. `--dry-run` prints each decision plus the comment file path and mutates nothing.

One tick costs one list call per repo plus at most four calls per triaged issue (view, label edit, risk label edit, comment) and zero agent spawns unless `RUNNER_TRIAGE_AGENT_DECIDE=1`, in which case at most one spawn per ambiguous issue. Exact-title duplicate matching is local against the same intake list, so it adds zero calls. Comment bodies travel via `--body-file`, never as argv. The tick never closes an issue, never merges, and never writes code. Outcomes land in `runs.jsonl` as `triaged_complete`, `triaged_incomplete`, `triaged_product-call`, or `triaged_duplicate-of`.

## Fix-ci (team repos only)

`fix-ci` runs one repair pass for team repos. A repo joins the pass only when its `docs/agents/repo-mode.md` says team. Solo repos skip with a log line, since solo landing trusts the local verifier and polls no hosted CI. A scheduler calls this every 5 to 10 minutes; each pass exits fast when nothing needs work. `--dry-run` prints each planned claim or skip with its reason and mutates nothing.

Per repo the pass lists open PRs with `gh pr list`, then classifies each PR with the whips `pr-status` script, which reads structured forge fields only. Candidates are PRs in state `red` or `conflict`. A conflicted PR qualifies even without a `ci-failed` label, because a conflicted PR often runs no workflow and gains no label. Other states need no fix and skip silently in a live pass.

Skip reasons, each logged: cross-repository (fork) PRs, PRs carrying `needs-human`, PR authors outside scope, and PRs with a fresh `agent:fixing` claim. Author scope defaults to the authenticated user only; `RUNNER_FIX_AUTHORS` widens it to a space separated login list. A claim counts as fresh until `RUNNER_CLAIM_TTL_MIN` minutes pass since the `labeled` event. A stale claim is released with a one-line comment, then the PR becomes a candidate again in the same pass.

Attempts count from `fix-attempt-N` labels, not from local files. The pass claims by adding `agent:fixing`, re-reads the labels to confirm the claim landed (check-after-write), and swaps `fix-attempt-N` to `N+1` before spawning, so a process that dies mid-flight still consumed its attempt. A stale or crashed claim keeps the attempt label and only drops `agent:fixing`. At `RUNNER_FIX_MAX_ATTEMPTS` the PR caps out: the pass sets `needs-human` with a `stuck-3x` reason marker, removes `agent:fixing`, runs `gh pr merge --disable-auto`, posts one summary comment, and never spawns again for that PR.

Each claim gets a fresh detached worktree from `origin/<headRefName>` and a recorded start SHA. The agent spawns through `RUNNER_AGENT_CMD` with the issue-run env and four more vars: `RUNNER_PR`, `RUNNER_KIND` (`ci` or `conflict`), `RUNNER_LOG_FILE`, and `RUNNER_PROMPT_FILE`. The prompt is a placeholder naming the PR and the worktree; the CI log content belongs to #74. Outcome compares the branch head after the run against the start SHA: pushed means `fix_pushed`, unchanged means `fix_nochange`, a killed run means `fix_timeout`. The claim label always comes off through a trap, one marker comment (`<!-- runner-fix attempt=N sha=... -->`, edited in place, never stacked) records the outcome, and one `runs.jsonl` row with a `ship-pr` field lands per attempt. A pushed worktree is removed; a non-push worktree stays on disk for inspection.

Fix-ci never merges, never closes, never arms auto-merge, and never force pushes. The only force form the agent contract allows is a guarded lease push on a rebase. A bare force push is refused. `runs.jsonl` rows from fix-ci carry `ship-pr` instead of `issue` so runs stay separable.

| Outcome | Meaning | Worktree | Attempts |
| --- | --- | --- | --- |
| `fix_pushed` | Branch head moved during the run | removed | label already bumped before spawn |
| `fix_nochange` | Head unchanged | kept for inspection | label already bumped before spawn |
| `fix_timeout` | Killed at the timeout | kept for inspection | label already bumped before spawn |
| `capped` | Attempt cap reached, `needs-human` set, auto-merge disabled | none | stays at the cap |
