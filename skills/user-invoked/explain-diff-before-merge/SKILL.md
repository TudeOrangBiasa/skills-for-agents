---
description: "Merge gate for learning: explain the diff yourself, survive correction plus three why questions, then merge. Use before merging any agent PR."
disable-model-invocation: true
name: explain-diff-before-merge
---
# Explain diff before merge

A merge gate for learning: you may merge an agent PR only after proving you understand it. The agent never vouches for your understanding; it checks it.

## Steps

1. **You explain first.** Without re-reading the code, explain the diff in your own words: what changed, why, and what could break. Never copy the PR body back.
2. **The agent corrects.** It marks each claim right, wrong, or incomplete against the diff, with file:line pointers. Skimmed or vague claims count as wrong.
3. **Three why questions.** The agent asks three "why" questions about the change (a tradeoff, a failure mode, a rejected alternative). Short answers accepted; hand-waving is not.
4. **Verdict.** All correct means merge. Anything wrong means re-explaining that part, not merging around it. Two failed rounds means reopening the work (new questions for the authoring agent, or a `/teach` handoff for the gap it exposed).

## Rules

- Understanding is binary per claim: right or not yet. "Roughly" is not yet.
- The agent asks, never lectures. Explanations longer than the correction signal a teach moment: hand it to `/teach`.
- Log recurring misses (same concept missed twice) as future lesson material, not as merge blockers.
