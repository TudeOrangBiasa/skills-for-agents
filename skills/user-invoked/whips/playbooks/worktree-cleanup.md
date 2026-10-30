# Playbook: worktree cleanup

Disk full of stale worktrees and caches. This is the one playbook that deletes user state with no code review to catch a slip, so the gates below are the review.

Naming convention (so the scripts can match a worktree to its PR): runner issue N lives at `$RUNNER_WORK_DIR/worktrees/<repo>-issue-<N>-<ts>` on branch `wip/issue-<N>` (or the PR head branch); whips unit or PR work lives at `<repo>-worktrees/pr-<N>` (or `.whips/worktrees/<repo>/pr-<N>`). Legacy runner paths `<repo>-<n>-<ts>` (no `issue-`) still parse for the active-claim guard (regex `-<digits>-<digits>` on the basename) for one release, then deprecate per the changelog. `worktree-prune` drops the local branch ref only for MERGED PRs with no remote ref left; CLOSED-unmerged PRs keep their branch ref (commits survive there).

## Auto mode (on-loop, no human confirm)

After a PR reads back MERGED (or CLOSED), run `../scripts/worktree-prune --pr <N>` for that PR; the timer tick runs `worktree-prune` with no args. Removal applies ONLY to bucket `safe-to-prune` from `../scripts/worktree-audit` (PR merged or closed AND working tree clean AND not main AND no runner lock file). Default is `--dry-run`. Dirty worktrees are reported, never removed.

## Reclaim mode (manual, human confirms)

1. Snapshot and audit: record `df -h` on the volume, then run `../scripts/worktree-audit` and read paths from `git worktree list`, never hand-typed. The classification is advice, not permission.
2. Confirm the pinned set with the user (active chats, pinned work). Pinned and in-use always wins over any classification.
3. Verify before deleting: clean, merged, and not-in-use proceeds. Anything with uncommitted work means showing the diff and getting a decision first (a clean worktree rebuilds from its branch; uncommitted work is gone forever). Name every untracked file you would drop.
4. Prune the confirmed set per path (`git worktree remove --force`, then `git worktree prune`; `rm -rf` only a dir surviving on ignored build artifacts). Branch refs survive, so no commits are lost.
5. Other reclaimers only with confirmation: package caches, build dirs, old runtimes. Clear only what the user has not said to keep.
6. Confirm with `df -h` and a fresh `git worktree list`.

**Reply:** `df -h` before and after with space reclaimed, the worktrees pruned, and a one-line reason for each held back (in use by what, or uncommitted work).
