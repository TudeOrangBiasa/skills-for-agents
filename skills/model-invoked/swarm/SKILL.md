---
description: Parallel worker fan-out for coverage, races, and gauntlets with aggregation into one report. Use for parallel coverage, races, or exploration partitions.
name: swarm
---
# Swarm

Fan out N parallel workers, drain them, return one report. Workers may cover separate slices, race the same brief, or mix both. Companion to `arena` (one artifact from competing candidates) and `interrogate` (review of one change).

Open a todo with one entry per phase before launching anything.

## A. Frame

State the done predicate and the artifact or report the swarm must return. Choose the shape: partition into slices, race N workers on identical briefs, or mix both; for a race or mixed shape, declare `first pass`, `rank all`, or `best-of` before spawning. Set N from the user or derive it from the shape. Workers follow the repo model map with effort picked per job; a model race names each arm's model up front. A rejected slug falls back to the closest valid one in the harness error message, else your own model; a missing map role uses your own model. Either way, say so. Each worker gets its own writable output when it writes; briefs that verify or measure name the exact SHAs, and measurement briefs also name the method (sample count, what one sample is, order).

## B. Fan out

Spawn all N in one round, each worker on the Phase A model (omit it for `auto` or `inherit-parent` so it runs on your model). Every brief stands alone: goal, scope, exact slice or race arm, how to verify, what to report. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence; a worker that can prove a defect reports `ISSUES` and lists every issue it can prove, not only the first. A dropout means proceeding with N-1, noted.

## C. Aggregate

Read the terminal results. Drop a result that does not record the SHAs and method its brief named, and respawn that worker once; after a second miss, record a gap (a gap is never a pass). Coverage needs a result for every required slice; a race applies the selection rule declared up front (`first pass`, `rank all`, or `best-of`). Keep a compact result table, one-line evidenced issues, and explicit gaps or dropouts. Never paste raw worker dumps.

## D. Report

One consolidated in-chat report: the table, issue one-liners, gaps or dropouts, and the race rule when used.
