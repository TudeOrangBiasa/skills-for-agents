---
description: "Keep a reviewable decision trail for long or unattended work: TSV log per decision, end audit, cross-model attention flags. Use for runs a human reviews after stepping away."
name: show-me-your-work
---
# Show me your work

Keep one canonical decision trail for long-running or unattended work: a TSV log, one row per decision (what, why, evidence, result). Commit it only when a reviewer needs the trail to trust the result. Other skills route their audit trail here instead of inventing one: reference it by name and let it own the format.

## Format

One TSV file, single-line cells, evidence as pointer never prose. Header:

```text
ts	phase	decision	why	evidence	result
```

Columns: `ts` is an ISO8601 timestamp; `phase` the phase or workstream; `decision` what was chosen or done, one line; `why` the reason in plain words, a driving principle stated plainly never as a jargon tag; `evidence` a pointer that proves it (commit SHA, PR number, `file:line`, artifact or screenshot path); `result` the outcome or predicate state (`tests green`, `reverted`, `pixel-diff 0`, `INCONCLUSIVE`, `open`).

Plain-spoken rows, so a reviewer reads the trail at a glance:

```text
ts	phase	decision	why	evidence	result
2026-05-24T09:02:00Z	frame	counted the work first, about 100 components and roughly 75 hours	wanted to know the size before starting a long run	commit 3a9f1c2	found 5 things to sort out before starting
2026-05-24T11:15:00Z	widget	moved the widget styles over without changing how it looks	keep the change small and the result identical	commit 7c21e0a, pixel-diff 0	looks identical, tests pass
```

Log decision points and checkpoints, not every action: a fork chosen, a unit completed with its verification, a pivot or revert with its trigger, a blocker surfaced, a gate fixed. Per loop iteration, one row. Skip the trivial and self-evident. Append-only: a wrong call gets a superseding row, history never edits or deletes. Quote cells starting with `=`, `+`, `-`, `@` (formula injection). Plain words, no AI speak; `unslop` applies to log text too. Prefer evidence produced by committed scripts over hand-made one-offs (rule 13).

Use `scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>` (stamps ts, writes the header on first use, guards the formula bytes, creates parent dirs). Bare `printf` appending works when the helper is out of reach, with the same guards.

A run is one conversation including later turns. A pickup, replacement agent, or new chat starts a new run: its first row carries phase `start` naming the `ts` range of prior rows it did not write, with evidence naming this run (such as its agent id). A run returning to the log first reads the tail to see whether another run wrote since; its first row after another run's `start` row is a `start` row too. Use phase `start` for nothing else.

Location: `decisions.tsv` in the work dir (`.scratch/whips/<run>/decisions.tsv` for whips runs), or `.audit/<task-slug>.tsv` for parallel efforts, out of git by default. Commit only ambitious trails a reviewer must read to trust. The full create/read map lives in `docs/agents/docs-layout.md` (written by `/setup-meta`).

## Audit before handing back

Read this run's transcript from the harness transcript store, never another workspace's private chats, and walk this run's rows against what actually happened: a stretch runs from one of this run's `start` rows, or from the first row if this run created the log, to the next `start` row of another run. Every row maps to a real decision or action, each evidence resolves and shows what the row claims, unlogged forks or pivots get added as gaps. Correct the log, not the story: wrong rows are superseded, never edited, even invented ones. Rows outside this run's stretches are not audited here; when this run's own work shows one of them is wrong, supersede it like any wrong call.

## Attention section

Before handing back, spawn a reviewer on a different model family from the one that did the work; self-review is not a substitute. The reviewer reads the trail and the run's transcript, then scans for what is suboptimal or risky rather than redoing the work: weak or absent evidence, skipped or unproven verification, hindsight risks, gaps a casual skim misses. The reviewer runs on the repo model map when one exists, else your own model; with a single model, use a fresh context with an adversarial brief. Match effort and speed to the job.

Every reply for a trailed run ends with one: lead with `reviewed by <model>` on its own line, then flags pointing at rows. "No flags" is valid; the model line alone is not.

Read a trail top to bottom following evidence pointers (`column -s$'\t' -t` renders it in a terminal; hosted git renders committed TSV as a table).
