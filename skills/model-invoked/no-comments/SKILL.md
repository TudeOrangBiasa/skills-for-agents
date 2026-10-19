---
description: Kill needless comments plus the dead code they protect, fix root causes in scope, encode real constraints as structure. Use before review or when comments outnumber reasons.
name: no-comments
---
# No comments

Hunt needless comments and the dead code and workarounds they protect, fix the root cause in scope, and encode real constraints as structure. Comments that survive must prove they are about something unchangeable. Companion to `interrogate` (adversarial review of the change) and rule 24 (no phase-narrating comments): this one goes further, treating every comment as guilty until proven load-bearing.

## Scope

The caller's files or diff; otherwise the current diff against the base branch, working tree included.

## Steps

1. Spawn one reviewer per available model with the same brief (scope plus this rubric), all in one round; single-model harnesses run two passes (find, then challenge). Models follow the repo model map. Never restate the rubric inside the brief; point at it.
2. Judge every finding skeptically before touching code. Reject application-code edits, scope escapes, exception-protected deletions, misstated kill reasons, and flags treating kept intentional code as guilty. A keep survives only with proof it is about something unchangeable (generated code, external contract, hardware limit); run `how` or `why` on thin keeps before believing them. Ambiguous kill means do not restore; refuted or still-ambiguous keep means delete. A rejected report gets one rerun with the failure named; reject twice and the skill fails open with the report.
3. Fix trivial accepted flags directly: delete the dead path, drop the parameter, use the real API. Fixes needing shape get one `codebase-design` sketch first; the sketch shapes, implementation follows.
4. Implement the smallest root-cause fix in scope (rule 2) and remove every named workaround. Root cause out of scope means landing the smallest in-scope fix and reporting the rest open. Never bolt on symptom guards, never widen the fence.
5. Constraint comments (`do not remove`, `do not change wording`, `talk to X`) become encodings, not keeps: offer the cheapest in-scope type, runtime check, test, or CI lint (rule 13), wait for approval, encode, then delete the comment. Unattended runs need caller pre-approval; without it, delete, report the constraint open, and sketch the out-of-scope work.
6. Report: deletion count, restored comments, reruns, sketch, fixes, encoding offers and landings, unenforced constraints, other open work.
