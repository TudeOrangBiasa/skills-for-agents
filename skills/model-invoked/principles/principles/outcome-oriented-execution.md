# Outcome-Oriented Execution

Optimize for the intended, verifiable end state rather than preserving smooth intermediate states.

## The rule

Planned rewrites converge on the target architecture. Intermediate breakage is acceptable when it is planned, scoped, and reversible. Declare where breakage is allowed, keep high-signal checks on touched areas, and require full verification at plan completion. No throwaway compatibility code that becomes permanent.

## Why

Keeping every intermediate step green forces throwaway compatibility code, and throwaway code has a habit of surviving. Each shim added "just for the migration" becomes a second API to maintain, the old path keeps working so the migration never quite finishes, and the end state carries strata of scaffolding instead of one clean architecture. Declared breakage converges faster and lands cleaner: one target, no fossils.

## When this applies

Use this for planned rewrites and migrations with explicit phase boundaries: renames across many files, format migrations, architecture moves with a written plan.

Do not use it for everyday feature work (keep the tree green), for unplanned breakage found mid-work (that is a bug: fix it or revert it), or as an excuse to skip checks on code you are actively touching.

## How to apply

1. Name the target architecture in one paragraph before touching code, so every phase has something to converge on.
2. Declare the breakage zones: which checks may go red, in which areas, during which phases.
3. Keep high-signal checks on actively touched areas green: the tests that guard what you are changing keep running and passing.
4. Write no compatibility code that exists only to keep intermediates smooth. If a phase truly needs a bridge, time-box it and delete it before the plan completes.
5. Require full static and runtime verification at plan completion, end to end on the real artifact.

## Example in this repo

Migrating every skill to a new frontmatter contract: declare upfront that the mention checks may go red mid-migration (READMEs catch up last), keep proof checks green on each skill as you touch it, write no shim in the check script to accept both formats, and require the full docs gate green at completion.

## Say it in the reply

Name this principle and the choice it changed: what breakage you declared, or what compatibility code you refused to write.
