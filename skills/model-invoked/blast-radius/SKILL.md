---
description: Find what a change could break outside itself and prove the one safety fact by running code. Use for blast radius questions or small diffs you don't trust.
name: blast-radius
---
# Blast radius

Find what a change breaks somewhere else, before it ships. Listing the callers is not the job (grep does that in a second); the job is the breakage grep won't show. Companion to `how` (what it does) and `why` (why shaped so). The two-sentence version lives in `bug.md` step 3; this skill is the full method.

## Don't trust the writeup

A blast-radius writeup that sounds right is worthless: it reads convincing whether or not it is true. Find the one or two facts the whole thing depends on and prove them by running code. Push each safety fact down the ladder (said so, pointed at file:line, walked the bad case, ran the real code, reproduced in the app) and say where it stopped.

## Steps

1. Read the change: diff, added/changed/deleted symbols, what behaves differently now, including what the diff does not spell out.
2. Find the one fact it is safe because of. Most risky-looking changes are safe through a single fact ("this call only drops already-dead entries and does nothing else"). Spend time here, not on long maybe-lists.
3. Look where grep stops: read the called library's source, check its pinned version and local patches; work out timing (queues, teardown, framework differences); follow what symbol search misses (API payload shapes, DB columns, wire formats, another language reading the same bytes, feature flags, code three hops downstream).
4. Be honest per risk: a real chance and a real cost. Keep confirmed risks; list checked-and-cleared separately. Cite a real file:line, an empty search is still an answer, never invent a caller or API.
5. Prove the one fact: a script or test running the real code, run it, paste what happened. Mark unproven what you could not prove.
6. Big or wide changes go through `arena`: model diversity catches different real bugs when the harness offers it, else lens diversity in fresh contexts.

## Handoff

What changed (including the non-obvious part); the one safety fact with its ladder step and proof, or marked unproven; risks with break path, file:line, likelihood, cost, and how to check; cleared items with why; the cheapest test or repro catching the real bug. Write through `unslop`, cite real code, strip anything private before it goes public.
