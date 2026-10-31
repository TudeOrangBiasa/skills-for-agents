---
description: "Learning gate: explain the diff yourself, survive correction plus three why questions, then merge. Use before merging any agent PR."
disable-model-invocation: true
name: learn-diff-gate
---
# Explain diff before merge

> Deprecated from the merge path (2026-10-31): do not call from merge, ready-check, shipping, or opening-a-pr. Learning value folds into `/learn-teach` or `plan-interview`. Execute path is `/whips` only.

A merge gate for learning: you may merge an agent PR only after proving you understand it. The agent never vouches for your understanding; it checks it.

## Steps

1. **You explain first.** Without re-reading the code, explain the diff in your own words: what changed, why, and what could break. Never copy the PR body back.
2. **The agent corrects.** It marks each claim right, wrong, or incomplete against the diff, with file:line pointers. Skimmed or vague claims count as wrong.
3. **Three why questions.** The agent asks three "craft-why" questions about the change (a tradeoff, a failure mode, a rejected alternative). Short answers accepted; hand-waving is not.
4. **Verdict.** All correct means merge. Anything wrong means re-explaining that part, not merging around it. Two failed rounds means reopening the work (new questions for the authoring agent, or a `/learn-teach` handoff for the gap it exposed).

## Rules

- Understanding is binary per claim: right or not yet. "Roughly" is not yet.
- The agent asks, never lectures. Explanations longer than the correction signal a teach moment: hand it to `/learn-teach`.
- Log recurring misses (same concept missed twice) as future lesson material, not as merge blockers.

## Delegated learning (folded from the delegated-learning skill, 2026-10-31)

When the diff ahead is beyond your current reach but inside your learning zone, the same gate doubles as the classroom:

1. **Note gaps first.** Name the concepts you cannot build unaided, in your own words, before the agent starts. Vague ("the backend part") means narrowing first: which call, which shape, which rule.
2. **Sliced diffs.** The agent keeps the diff reviewable in small slices; each slice is one lesson. Never delegate what you could build in under an hour; never delegate two zones above your level.
3. **Three concepts.** After the work lands, the agent picks the three load-bearing concepts and explains each against the exact lines that carry it. You restate each back until it holds without the code in front of you. A concept explained three times without sticking is a missing prerequisite: go one level down.
4. **Shaky ground becomes a `/learn-teach` handoff** (`/learn-handoff` writes it): mission, what failed to stick, what to drill next.

No `LEARNED.md` compounding log: `/learn-teach` learning records already keep the durable record, so a second log file only splits it.
