---
description: "Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong. Use before code crosses a function boundary."
name: architect
---
# Architect

Settle types, signatures, and module shape before code crosses a function boundary, then stay in the loop while implementation fills in. Jumping to code locks in the wrong shape. Runs on `codebase-design` vocabulary; formalizes its design-it-twice pattern.

Open a todo with one entry per phase before starting.

## A. Ground

Build a real mental model of every system the new code touches: run `how` over the relevant subsystems (naming a file is not grounding). When the design redefines ownership or layering, run `why` too, so existing rationale becomes a constraint, not a guess. Skip only true greenfield with no surrounding system.

## B. Sketch

Run `arena` with the design-sketch task plus the Phase A grounding; runners follow the repo model map. Require at least two structurally distinct candidates before synthesis, even when the first looks sufficient: whole-shape alternatives, not point fixes inside one shape.

Screen every candidate for agent-copy robustness: assume the next contributor sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Prefer the design where a change that looks right from one file is right for the whole repo. Compare survivors on interface depth: more complexity hidden behind a smaller public surface wins.

## C. Agree (opt-in)

Default: proceed to implementation with the synthesized design, no checkpoint. Pause for sign-off only on explicit ask ("with checkpoint", "show me before implementing"). The synthesis may ship as its own scaffold commit. For adversarial pressure first, run `interrogate` on the sketch. Human pushback on the shape is Phase A evidence: re-ground and re-run Phase B before writing more code.

## D. Implement against the sketch

Replace sketch bodies with code. The sketch is the contract: deviations surface as signal (wrong sketch, missed requirement, overreaching implementation), never absorbed silently.

## E. Scrap when wrong

A pattern of friction the sketch cannot absorb means throwing it out, never bolting fixes on. Tells: the same workaround shape across unrelated code, unrelated edge cases all needing special branches, types needing escape hatches to compile, the "we need a lock" reflex on supposedly unshared state, callers needing internal rules, repeated same-shape deviations. A few edge cases do not condemn an architecture. When scrapping: re-run `how` on what exists, redesign as if new constraints were day-one assumptions (rule 17), subtract before adding (rule 1), return to Phase B.

## Outputs

Usage first: the caller's usage is written before types are derived from it. Small changes get one file of types and signatures; larger work gets a module map plus definitions, with the rationale (usage sketch plus synthesis decision) alongside.
