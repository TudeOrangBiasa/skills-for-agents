---
description: Find what a change could break outside itself and prove the one safety fact by running code. Use for blast radius questions or small diffs you don't trust.
name: verify-blast
---
# Blast radius

Find what a change breaks somewhere else, before it ships. Use for "blast radius of X", "what could this break", or reviewing a small diff you don't trust yet.

Companion to `craft-how` (what it does) and `craft-why` (why shaped so). Listing the callers is not the job (grep does that in a second); the job is the breakage grep won't show. The two-sentence version lives in `bug.md` step 3; this skill is the full method.

## Don't trust your own writeup

A verify-blast writeup that sounds right is worthless: it reads convincing whether or not it is true. So don't hand back the writeup. Find the one or two facts the whole thing depends on and prove them by running code.

### How sure are you

For each fact the change's safety depends on, get it as far down this list as is cheap, and say where it stopped.

1. You said so. Worthless on its own.
2. You pointed at the line. A real `file:line`, or the library's own source.
3. You showed the bad case can't happen. You walked the failure step by step and it doesn't reach.
4. You ran it. A script or test that calls the real code and fails loud if you're wrong.
5. You reproduced it in the running app.

Step 4 is usually one small script that imports the same library the app ships and calls the exact function you're worried about.

## Steps

1. Read the change: diff, added/changed/deleted symbols, what behaves differently now, including what the diff does not spell out. Use `craft-why` step 1 to pull the code anchor (git blame and log, PR bodies and discussion).
2. Find the one fact it is safe because of. Most risky-looking changes are safe through a single fact ("this call only drops already-dead entries and does nothing else"). If it holds, most risky cases clear at once. Spend time here, not on long maybe-lists.
3. Look where grep stops: read the called library's source, check its pinned version and local patches; work out timing (queues, teardown, framework differences); follow what symbol search misses (API payload shapes, DB columns, wire formats, another language reading the same bytes, feature flags, code three hops downstream).
4. Be honest per risk: a real chance and a real cost. Keep confirmed risks; list checked-and-cleared separately. Same rules as `craft-why`: cite a real file:line, an empty search is still an answer, never invent a caller or API.
5. Prove the one fact: write a script or test that runs the real code, run it, and paste what happened. Mark unproven what you could not prove.
6. Big or wide changes go through `craft-arena`: ask more than one model the same question and merge the answers when the harness offers model diversity, else lens diversity in fresh contexts. Different models catch different real bugs.

## What to hand back

- **What it does.** What changed, including the non-obvious part.
- **The one fact it's safe because of.** State it, say which ladder step you got it to, and show the proof. If you couldn't prove it, write unproven.
- **Risks.** Each names the break path, the `file:line`, how likely and how bad, and how to check. Paste the proof for the ones that matter.
- **Cleared.** What you checked and why it's fine.
- **Before you merge.** The cheapest test or repro catching the real bug, including the script you wrote.

Write through `review-unslop`, cite real code, strip anything private before it goes public.

**Reply:** the writeup above, with the one safety fact either proven or marked unproven.
