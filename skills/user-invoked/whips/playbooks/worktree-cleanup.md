# Playbook: worktree cleanup

Disk full of stale worktrees and caches. This is the one playbook that deletes user state with no code review to catch a slip, so the gates below are the review.

1. Snapshot and audit: record `df -h` on the volume, then `git worktree list`. Classify each worktree by size, age, merge state, uncommitted work, and which recent work touched it. Read paths from `git worktree list`, never hand-typed. The classification is advice, not permission.
2. Confirm the pinned set with the user (active chats, pinned work). Pinned and in-use always wins over any classification.
3. Verify before deleting: clean, merged, and not-in-use proceeds. Anything with uncommitted work means showing the diff and getting a decision first (a clean worktree rebuilds from its branch; uncommitted work is gone forever). Name every untracked file you would drop.
4. Prune the confirmed set per path (`git worktree remove --force`, then `git worktree prune`; `rm -rf` only a dir surviving on ignored build artifacts). Branch refs survive, so no commits are lost.
5. Other reclaimers only with confirmation: package caches, build dirs, old runtimes. Clear only what the user has not said to keep.
6. Confirm with `df -h` and a fresh `git worktree list`.

**Reply:** `df -h` before and after with space reclaimed, the worktrees pruned, and a one-line reason for each held back (in use by what, or uncommitted work).
