# Foundational Thinking

Get the data shape right before writing logic. Define core types early, trace every access pattern, and choose structures that match the dominant paths. Structural decisions protect option value; code-level decisions protect simplicity.

## Why

Logic written on the wrong shape has to fight it at every step: scattered conditionals, repeated assumptions, adapters papering over a missing model. When the shape is right, downstream code becomes obvious and each increment lands as a coherent abstraction or deepens one that exists.

## When it applies

Before any logic sketch: choosing core types, sequencing scaffold against features, sharing state between concurrent actors.

In practice:

- Data structures first. Name the organizing structure (state machine, typed model, table or registry) before delegates write logic. Types and data models converge; three similar statements still beat a premature abstraction.
- Scaffold first. If something helps every later phase, do it first: ask whether every subsequent phase benefits from it existing. CI, linting, test infrastructure, shared types. Setup before features, tests before fixes. Small single-purpose increments, and do not spread a new capability across callers as special-case coordination.
- Concurrency corollary. Before sharing state between actors, ask what happens if another actor modifies it concurrently. If the answer is anything but nothing, isolate.
- Subtract before scaffolding. Remove dead code first, then lay foundations.

## Where it lives in this repo

Embedded, not a numbered rule: the PRINCIPLES.md header names it as `craft-vocab` (see `SKILL.md` section 3). The carrier is the `whips` trigger "Any code: name the data shape first" plus the `craft-vocab` vocabulary (module, interface, depth, seam, adapter, leverage, locality) and the `craft-architect` skill that settles types, signatures, and module shape before code crosses a function boundary. The scaffold and concurrency halves surface in `playbooks/feature.md` (blocking gates before fan-out, shared state split by default) and in the small-units and separate-before-serializing leaves.

## Example in this repo

A feature spanning several files names its data shape in the `whips` feature playbook before any delegate writes logic: the organizing structure, the files it touches, the seam it sits at. Shared check infrastructure such as `scripts/check-docs.sh` is scaffold: it lands before the content it guards, so every later phase benefits from it existing.
