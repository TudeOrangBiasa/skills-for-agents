---
description: "Parallel design bakeoff: N candidates on one brief, cross-judge, pick a base, graft the best parts. Use when one attempt would lock in the wrong shape."
name: arena
---
# Arena

Run N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use when one attempt at a non-trivial artifact would lock in the wrong shape. Companion to `swarm` (coverage and races) and `interrogate` (adversarial review of one change).

Open a todo with one entry per phase before launching anything.

## A. Frame

Every candidate gets the same prompt, so the prompt is the contract: the artifact each produces, and a rubric of 3 to 6 concrete gradeable criteria for this task (the picker's tool; candidates only see the task). Runners follow the repo model map; keep at least two runners, dropping to one only when the map lists one. Use the same model N times when the work is generation-bound rather than judgment-sensitive, more runners when covering multiple design directions. A rejected slug falls back to the closest valid one in the harness error message, else the map's default or your own model; a dropped seat is refilled on a remaining runner's model, else your own model. Either way, say so. Each candidate gets its own output location (a git worktree where possible, otherwise a separate directory) per rule 15.

## B. Fan out

Spawn all N in one round, each with the task, the path to the shared grounding, its own output path, and instructions to produce the artifact plus a short rationale naming the alternatives it considered and rejected. A candidate with no output means proceeding with N-1, dropout noted.

## C. Cross-judge

After all candidates complete, one readonly judge (a different model family, from the map's judge entry, never your own model when it is an `auto` or `inherit-parent` entry) sees the rubric and the candidates by path label, scores each rubric criterion per candidate, and recommends a base with rationale. It runs in parallel with your reading in Phase D. Never judge while candidates are still writing. When no other-family model runs, pick the base alone and say Phase C skipped the judge.

## D. Pick a base

Read every candidate end to end before picking, score criterion by criterion against the rubric (not holistic feel), and compare with the cross-judge when Phase C ran one. Agreement confirms the pick; disagreement means bias or an ambiguous rubric, so read both rationales before deciding. Pick the base a future maintainer extends most easily without breaking invariants; ties break toward the cleaner boundary or smaller API (rule 1).

## E. Graft

Walk each loser once more for the one or two things worth porting (not most of it), and fold each in by hand (rule 17) so the result stays coherent under one mental model. Convergence on one shape means shipping the consensus, no graft needed. Wild divergence means Phase A was under-specified: reframe and re-run, never average the divergence.

## F. Verify

Verify the synthesized artifact like any other output (rule 3). A problem the arena missed means Phase A was wrong (re-run) or a graft was missed (back to Phase E); never paper over it.

## Outputs

One synthesized artifact with a short note: the base and why, the cross-judge verdict (or that Phase C skipped the judge), each graft with its source, what was rejected and why, convergence or dropouts, and the verification result.
