---
description: 'Explain how a subsystem works: triage complexity, fan out explorers on 2 to 4 angles for complex scopes, synthesize into fixed sections. Use for "how does X work", walkthroughs before a change, or placement and layering questions.'
name: how
---
# How

Answer "how does X work" with a working mental model, at senior-engineer-onboarding depth, never annotated source code. Companion to `why` (what forces shaped it) and blast radius (what it breaks elsewhere).

## 1. Triage complexity

Ambiguous scope means stating your interpretation first, then exploring; the user redirects if you are off.

- **Simple** (one module, one utility, "how does function X work"): one pass, explore and explain together. Skip to step 3.
- **Complex** (multi-file subsystem, cross-cutting feature, full overview): step 2.
- When in doubt, take the simple path.

## 2. Explore (complex only)

Decompose the question into 2 to 4 angles, each a distinct slice of the subsystem. Brief one explorer per angle, all in one round so they run concurrently. Each brief is self-contained (goal, scope, context, acceptance, verify, timebox, forbidden, report); pick the model by role from the repo model map when one exists, else your own model.

## 3. Synthesize and present

One synthesizer takes every explorer finding and produces the sections below, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas. Light edits for conversation context are fine; do not substantially rewrite the synthesis.
