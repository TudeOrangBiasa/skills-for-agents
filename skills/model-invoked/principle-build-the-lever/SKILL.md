---
name: principle-build-the-lever
description: "Apply to any non-trivial work, not just bulk work: edits, migrations, analyses, checks. Build the tool that does it or proves it (codemod, script, generator, delegate brief) instead of working by hand."
disable-model-invocation: true
---

# Build the Lever

Non-trivial work gets a tool that does it or proves it, not hand edits.

Do the first unit by hand to learn the recipe, then encode it, prove it by rerunning on that unit, and commit it when the work outlives the session. A codemod, script, or generator does the work the same way every time and reruns for free; the tool is one artifact a reviewer can read and rerun. Hand-done changes can only be re-verified by redoing them. If you cited this rule and no tool is in the diff, you did not apply it.

Distinct from `principle-encode-lessons-in-structure`, which turns a recurring instruction into a durable guardrail. This is throughput and reviewability on the work in front of you.

## Why

Hand work drifts. The tenth edit does not match the first, and nobody can tell without redoing all ten. A deterministic script turns "trust me" into "run this": the reviewer reads one recipe and reruns it instead of auditing every unit. The same logic holds when work fans out to subagents: one shared brief (recipe, verification contract, do-not-touch fences) keeps every delegate on the same contract, and it lives outside their write scope so they cannot quietly edit it.

## When it applies

- The work is non-trivial. The bar is triviality, not repetition: a one-off still earns a lever when the lever is what makes the work checkable. Skip it only for a couple of obvious edits visible at a glance.
- Codemod or script for edits, generator for repetitive files, a query over dumped data for analysis, a rerunnable check for verification.
- Prefer a deterministic lever over fan-out. If one script pass can process every unit, run it yourself instead of fanning out delegates to hand-apply the same recipe.
- Keep the lever minimal: the smallest script that does or proves the job, never a framework. Make it safe to rerun.

## Example in this repo

`scripts/check-docs.sh` is the lever for docs hygiene. The recipe (every touched skill mentioned in both READMEs, no dead internal links) was first applied by hand, then encoded as a rerunnable script that both the pre-commit hook and CI run. A reviewer does not re-audit every README mention; they run the script.
