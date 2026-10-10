---
"skills-for-agents": minor
---

`/whips` becomes a table-driven router. Section 1 is a first-match-wins router table, section 3 a trigger table that maps every model-invoked skill to the condition that fires it, section 5 an autonomy split (reversible work proceeds, a fixed pause list waits for the human), and section 8 asks the reply to cite principles and add a plain-words "Why this way". A new `PRINCIPLES.md` holds eight short principles. Subagent models come from an optional `docs/agents/models.md` per role (`code`, `hard-code`, `judgment`, `review`), falling back to the parent model, never a hardcoded name. `/setup-meta` gains an optional Section F and a `models.md` seed that offer only model ids the user already has configured. `opening-a-pr` adds a `## Why this way` body section and scopes the no-self-assign rule to PRs.
