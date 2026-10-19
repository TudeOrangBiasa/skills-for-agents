---
description: "Learn while delegating beyond your reach: note gaps, agent builds in slices, three concepts explained, handoff plus LEARNED.md log. Use when the task exceeds you."
disable-model-invocation: true
name: learn-while-delegating
---
# Learn while delegating

Delegate a task you cannot fully build yourself yet, and learn it in the passing. The agent works; you study the work. Use when the diff ahead is beyond your current reach but inside your learning zone.

## Steps

1. **Note what you lack.** Name the concepts you cannot build unaided, in your own words, before the agent starts. Vague ("the backend part") means narrowing first: which call, which shape, which rule.
2. **The agent builds.** It works normally (tickets, tests, proof), with one extra duty: keep the diff reviewable in small slices, because each slice is a lesson.
3. **Three concepts explained.** After the work lands, the agent picks the three load-bearing concepts in the diff and explains each against the exact lines that carry it. You restate each back until it holds without the code in front of you.
4. **Handoff to teach.** Anything still shaky becomes a `/teach` handoff (`/handoff` writes it): mission, what failed to stick, what to drill next.
5. **Log in LEARNED.md.** One entry per concept that stuck: what it is, where it lives in the codebase, what you confused it with. The file is the record that delegation is compounding instead of hollowing.

## Rules

- Learn-before-merge is for PRs; this is for skills. Merge gates check one diff, this builds capability across diffs.
- Never delegate what you could build in under an hour: the overhead exceeds the lesson. Never delegate two zones above your level: nothing sticks.
- A concept explained three times without sticking is a missing prerequisite, not a failure. Go one level down.
