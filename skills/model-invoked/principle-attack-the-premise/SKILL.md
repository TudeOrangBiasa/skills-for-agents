---
description: Question the assumption shared by repeated failures. Use when two or more fixes built on one sentence failed the same gate; write the premise down and test it before writing another fix.
name: principle-attack-the-premise
disable-model-invocation: true
---
# Attack the premise

Two fixes built on one sentence that failed the same gate mean the sentence is suspect, not the fixes. Write the premise down and test it directly before writing another fix on top of it.

Why: each failed fix is evidence against the belief it assumed. A third fix on the same premise spends effort where the evidence already says the cause is not.

## The pattern

1. **Write the premise down.** The premise is the one sentence every failed fix assumed. One sentence, explicit, falsifiable.
2. **Test the premise before the next fix.** Find an observation that would come out differently if the premise were false, and make it. Study how the failures distribute, not only how large they are. A rerunnable probe or count that settles the premise is evidence; keep it.
3. **Follow the evidence.** When it contradicts the premise, the cause sits elsewhere: find what the failures share that the premise never predicted. When the premise holds, ask the next why per rule 2 (fix the root cause); the earlier fixes likely treated a consequence instead of the cause. Prefer removing the condition over compensating for it: when one part always lands on the losing side, change what puts it there rather than adding cleanup that runs forever.

Stop: never start the next fix before the premise is written down and tested.

## In this repo

Two whips ticks that patched the same script and failed the same check-docs gate do not need a third patch yet. They need the premise written down ("the gate fails because of file X") plus a direct probe, such as running the gate on a fixture with and without X, before any more editing. This differs from rule 17 (redesign from first principles), which rebuilds a design around a new requirement; here the design stands and one assumed fact is on trial.

**Reply:** the premise in one sentence, the probe that tested it, and what the evidence said.
