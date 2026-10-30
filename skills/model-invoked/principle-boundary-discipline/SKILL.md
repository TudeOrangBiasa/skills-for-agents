---
description: Concentrate validation and error handling at system boundaries. Use when wiring CLI args, config, network, or external APIs; trust internal types and keep business logic in pure functions.
name: principle-boundary-discipline
disable-model-invocation: true
---
# Boundary discipline

Validate, narrow types, and handle errors at system boundaries. Trust internal code. Business logic lives in pure functions; the shell stays thin and mechanical.

Why: scattered validation is noisy, redundant, and gives a false sense of safety, while logic tangled in framework wiring cannot be tested without the framework. One guarded edge beats a guard on every door.

## The pattern

- **At boundaries** (CLI args, config files, external APIs, network protocols): validate, return errors, handle defensively. Parse raw input into domain types here, at parse time, never inside business logic.
- **Inside the system:** typed data, error propagation, no re-validation. No repeat nil checks deep in call chains once the boundary has validated.
- **Across the boundary:** expose domain concepts, never the boundary's private representation. No transport, storage, framework, or wire types leaking through the public surface. General-purpose mechanism stays inside; special-purpose policy sits at the edge.

## The tests

- "Is this data crossing a system boundary right now?" When it is not, the validation is redundant.
- "Can this be a pure function the shell just calls?" When it can, extract it: raw bytes in and typed state out, state in and results out, no framework imports.

## In this repo

In `scripts/check-docs.sh`, argument and environment handling is the boundary: `BASE` and `DOCS_SKIP` get their defaults and validation at the top, and the checks below trust those values instead of re-checking them. Skill prose follows the same shape: the contract and inputs get pinned once up front, and the steps below assume them.

**Reply:** where the boundary sits in this change, what gets validated there, and which logic stays pure inside it.
