---
description: 'Apply when reviewing or shaping code that is hard to trace. Count layers between question and answer, and hidden state in the reader head; collapse one-caller wrappers and shrink mutable scope.'
name: principle-minimize-reader-load
disable-model-invocation: true
---
# Minimize Reader Load

Maintainability is the work a reader must do to understand code. Track two axes: layers to trace (indirections between the question and the answer) and state to hold (hidden or mutable context the reader must keep in their head). Line counts, cyclomatic complexity, and clean architecture checklists are proxies. Reader load is the thing that matters.

## Why

The two axes are independent. A flat file with fifty globals can be as hard to reason about as a six-layer adapter stack. Guard both: every layer you add and every piece of shared state you introduce is a tax on every future reader, and working memory is finite for readers too. This is the human analog of guarding the context window for agents.

## When it applies

Reviewing or shaping code that is hard to trace. Before adding a layer or a piece of state, ask whether it reduces reader load elsewhere by at least as much.

In practice:

- Collapse layers that cost more than they save: wrappers with one caller, adapters with no second implementation, speculative indirection that was never needed. Inline them.
- Make adjacent layers change the abstraction. A layer that repeats the same methods and arguments adds reader load without compression. Collapse pass-through layers.
- Demand interface compression. A broad interface that hides little complexity makes readers learn both the surface and the implementation. Prefer boundaries that hide meaningful decisions.
- Shrink state scope: prefer pure functions (returns over mutations), locals over fields, fields over module state, module state over globals. Derive instead of syncing.
- Name the invariant at the boundary, not in every consumer, so the reader learns it once.

The test: can a new reader answer "where does X come from?" and "what can change X?" in under thirty seconds? If not, cut layers or cut state.

## Where it lives in this repo

Embedded, not a numbered rule: the PRINCIPLES.md header names it as the `codebase-design` vocabulary. The carrier is `skills/model-invoked/codebase-design/SKILL.md`: depth as leverage at the interface, the deletion test, the interface as the test surface, one adapter as a hypothetical seam. Every `whips` trigger that routes through that vocabulary (deepening, architect, refactor and upkeep playbooks) carries reader load with it.

## Example in this repo

A skill folder whose SKILL.md delegates its real content two references deep (an index pointing at a playbook pointing at a shared note) fails the thirty-second test: the reader traces layers without gaining compression. The reader-load fix is to inline the note at the one place it is read, or to compress the interface so the top file answers the question on its own.
