---
description: "Eliminate repeated agent mistakes at the highest level that works: architecture, types, lint, tests, docs last. Use each time a correction lands."
name: craft-correct
---
# Correct

The operator keeps correcting agents in this repo for the same mistakes. Change the repo so the next agent cannot make them. Run this each time a correction lands; a repeated correction the skill did not prevent is the skill failing.

Assume every contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Design so a change that looks right from one file is right for the whole repo.

## Find the mistake classes

Read recent commits, reverts, review comments, instruction files, and comments explaining workarounds. Group mistakes into classes; a class counts once it has happened twice.

## Fix each class at the highest level that works

1. **Eliminate with architecture.** One owner per state, one supported way per task, internals hidden so the wrong import fails. Replace hand-synced lists with one source of truth. Delete old ways and dead code an agent would copy.
2. **Enforce with types, then lint.** Unrepresentable bad states first; where the bad code still compiles, add a lint or CI check whose error names the file, type, or function to use instead. Patterns already common fail only on growth (new additions), never the backlog.
3. **Test the behavior.** Write assertions against what the code's users can observe: the test fails when that observable behavior breaks and keeps passing when only internals change.
4. **Write docs or agent rules last, only for judgement calls.** Nothing fails when an agent skips them.

## Fix and prove

Fix the most frequent classes now, one commit each. Prove each new check fails on a real past mistake; run the same command locally and in CI. Exceptions sit on the offending line with a reason, an expiry date, and a human's approval.

## Keep the rule table

Keep a table in the repo's agent instruction file pairing each rule with its enforcer. On each new correction, fix the mistake and add the rule; a rule already there with nothing enforcing it is a repeat, so raise its level in the same change. Drop a rule once its mistake is impossible.

**Reply:** each class with evidence, the level picked, and why a higher level did not work.
