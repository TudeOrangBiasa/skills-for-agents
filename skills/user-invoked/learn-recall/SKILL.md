---
description: Rebuild recent working context across chats into a tight capsule brief. Use before starting or resuming work, when pickup and learn-catchup don't cover it.
disable-model-invocation: true
name: learn-recall
---
Before starting or resuming work, rebuild recent working context and hand back a tight capsule of where things stand and what to do next. One specific run, branch, or open PR to resume is the `pickup` playbook instead; this chat since your last message is `/learn-catchup` instead. Recall covers recent work across chats.

## Scope first

Lock the window ("recent" is a real range, default the last 7 days), the topic when named, and the workspace (default the active one; never read another workspace without being asked). State the scope back. A full state capsule already given means using it and skipping the mining.

## Mine three sources

1. **Repo ground truth.** Git history and branches, the issue tracker (states, briefs, linked PRs), prior decision logs and run logs, ADRs. What shipped, what reverted, what is open.
2. **Session traces.** Whatever transcript store the harness keeps for this workspace only; read topic-matching regions, never whole dumps, and never another workspace. No store means saying so and leaning harder on source 1.
3. **Shared record.** The `craft-why` skill's posture applied to current state: what was tried and did not hold, what users keep reporting. Null results are findings.

## Verify live

Check surfaced PRs, branches, and tickets with git and the tracker CLI. A thread with no tag is not done: tag every thread exactly one of `[merged #N]`, `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`, `[reverted #N]`, `[planned, not started]`.

## Brief

Capsule (at most 5 bullets: what this work is, where it stands), threads (one line each, tagged), problems (at most 5, recurring ones first, including reverted fixes so the next attempt starts where the last failed), next move (the single most useful concrete action). Cut detail before threads. Cite findings by their source; sanitize private context before anything public.
