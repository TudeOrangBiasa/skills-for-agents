# Fix Root Causes

Follow each symptom upstream to the first place the system went wrong, and fix it there. The symptom is where a wrong state became visible; the root cause is the first place the system did something it should not do, or failed to handle a state it should handle. A guard counts as a fix only when the state it handles is legitimate, not a symptom being silenced.

## Why

A symptom fix hides the evidence and leaves the fault free to surface somewhere else. Each one makes the system harder to reason about, because the code now carries a workaround for a bug nobody named. Fixing at the root removes the whole class of future symptoms at once.

## When it applies

Any debugging: a failing check, a wrong output, a flaky run. Work the pattern:

- Reproduce first. When stuck, instrument: read the actual error and the actual state instead of guessing.
- Ask "craft-why" at each step until the answer is a wrong decision in the code, not a consequence of an earlier one.
- Ask whether the state that triggered the symptom is legitimate. If the system may be in that state, the code that broke on it is the root cause and handling it there is the fix. If the state should never exist, a check where it broke hides the bug: find what produced the state. Guards, retries, swallowed errors, clamped values, and discarded state are the usual ways to hide one.
- When something fails only after a restart, suspect persisted state first: config files, caches, lock files, serialized state.
- Fix the pattern, not just the instance: find every place with the same fault and fix them all.
- If a workaround needs a paragraph-long comment to justify it, the code is wrong. Fix the code, not the comment.
- When the deciding fact took a deep dig to surface, leave behind the cheap, always-on signal that would have shown it at first glance.

## Example in this repo

A `check-docs.sh` failure that only appears in CI but never locally is a symptom at the gate, not the fault. The root-cause move is to ask what differs upstream: the base ref the range is computed against, a file the local tree has but the CI checkout lacks, a locale or tool version changing an output the script parses. Silencing it with `DOCS_SKIP=1` or a looser grep hides the bug; finding the divergent input fixes every future run that would have hit the same wall.
