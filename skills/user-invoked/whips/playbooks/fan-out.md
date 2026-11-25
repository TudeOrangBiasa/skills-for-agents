# Playbook: fan-out

Parallel workers for coverage, races, and bakeoffs with one report. Two modes: bakeoff picks one artifact from competing candidates; swarm covers slices or races identical briefs.

Open a todo with one entry per phase before launching anything.

## Bakeoff mode

Run N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use when one attempt at a non-trivial artifact would lock in the wrong shape.

### A. Frame

Every candidate gets the same prompt: the artifact each produces, plus a rubric of 3 to 6 concrete gradeable criteria. Runners follow the repo model map; keep at least two runners, dropping to one only when the map lists one. A rejected slug falls back to the closest valid one, else the map default or your own model; say so either way. Each candidate gets its own output location (a git worktree where possible, otherwise a separate directory).

### B. Fan out

Spawn all N in one round, each with the task, the shared grounding, its output path, and instructions to produce the artifact plus a short rationale naming the alternatives it considered and rejected. A candidate with no output means proceeding with N-1, dropout noted.

### C. Cross-judge

After all candidates complete, one readonly judge (a different model family from the map when one runs, else your own model with the difference stated) sees the rubric and the candidates by path label, scores each rubric criterion per candidate, and recommends a base with rationale. Never judge while candidates are still writing.

### D. Pick a base

Read every candidate end to end and score criterion by criterion (not holistic feel), then compare with the cross-judge. Agreement confirms the pick; disagreement means bias or an ambiguous rubric, so read both rationales before deciding. Pick the base a future maintainer extends most easily without breaking invariants; ties break toward the cleaner boundary or smaller API.

### E. Graft

Walk each loser once more for the one or two things worth porting (not most of it), and fold each in by hand so the result stays coherent under one mental model. Convergence on one shape ships the consensus, no graft needed. Wild divergence means Phase A was under-specified: reframe and re-run, never average the divergence.

### F. Verify

Verify the synthesized artifact like any other output. A problem the bakeoff missed means Phase A was wrong (re-run) or a graft was missed (back to Phase E); never paper it over.

## Swarm mode

Fan out N parallel workers, drain them, return one report. Workers may cover separate slices, race the same brief, or mix both.

### A. Frame

State the done predicate and the artifact or report the swarm must return. Choose partition into slices, race N workers on identical briefs (`first pass`, `rank all`, or `best-of` declared before spawning), or mix both. Set N from the shape. Workers follow the repo model map with effort picked per job. Each worker gets its own writable output when it writes; briefs that verify or measure name the exact SHAs, and measurement briefs also name the method (sample count, what one sample is, order). Every brief stands alone: goal, scope, exact slice or race arm, how to verify, what to report.

### B. Fan out

Spawn all N in one round. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence; a worker that can prove a defect lists every issue it can prove, not only the first. A dropout means proceeding with N-1, noted.

### C. Aggregate

Read the terminal results. Drop a result that does not record the SHAs and method its brief named, and respawn that worker once; after a second miss, record a gap (a gap is never a pass). Coverage needs a result for every required slice; a race applies the selection rule declared up front. Keep a compact result table, one-line evidenced issues, and explicit gaps or dropouts. Never paste raw worker dumps.

### D. Report

One consolidated in-chat report: the table, issue one-liners, gaps or dropouts, and the race rule when used.
