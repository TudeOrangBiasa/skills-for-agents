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

Log decision points and checkpoints, not every action: a fork chosen, a unit completed with its verification, a pivot or revert with its trigger, a blocker surfaced, a gate fixed. Per loop iteration, one row. Append-only: a wrong call gets a superseding row, history never edits or deletes. Timestamps are ISO8601; evidence resolves (commit SHA, PR number, file:line, artifact path). Quote cells starting with `=`, `+`, `-`, `@` (formula injection). Plain words, no AI speak; `unslop` applies to log text too.

Use `scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>` (stamps ts, writes the header on first use, guards the formula bytes, creates parent dirs). Bare `printf` appending works when the helper is out of reach, with the same guards.

A run is one conversation including later turns. A pickup, replacement agent, or new chat starts a new run: its first row carries phase `start` naming the prior rows' range it did not write, and it first reads the tail to see whether another run wrote since.

Location: `decisions.tsv` in the work dir (`.scratch/whips/<run>/decisions.tsv` for whips runs), or `.audit/<task-slug>.tsv` for parallel efforts, out of git by default. Commit only ambitious trails a reviewer must read to trust. The full create/read map lives in `docs/agents/docs-layout.md` (written by `/setup-meta`).

## Audit before handing back

Walk this run's rows against what actually happened: every row maps to a real decision or action, each evidence resolves and shows what the row claims, unlogged forks or pivots get added as gaps. Correct the log, not the story: wrong rows are superseded, never edited, even invented ones.

## Attention section

Every reply for a trailed run ends with one: a different-model reviewer scans trail plus reality for weak evidence, skipped or unproven verification, hindsight risks, and gaps a casual skim misses. Lead with `reviewed by <model>` on its own line, then flags pointing at rows. "No flags" is valid.

Read a trail top to bottom following evidence pointers (`column -s$'\t' -t` renders it in a terminal; hosted git renders committed TSV as a table).
