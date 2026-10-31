---
description: 'Explain how a subsystem works: triage complexity, fan out explorers on 2 to 4 angles for complex scopes, synthesize into fixed sections. Use for "how does X work", walkthroughs before a change, or placement and layering questions.'
name: craft-how
---
# How

Answer "how does X work" with a working mental model, at senior-engineer-onboarding depth, never annotated source code. Companion to `craft-why` (what forces shaped it) and blast radius (what it breaks elsewhere).

## 1. Triage complexity

Ambiguous scope means stating your interpretation first, then exploring; the user redirects if you are off.

- **Simple** (one module, one utility, "how does function X work"): one explainer explores and explains in one pass, without an explorer-findings section. Skip to step 4.
- **Complex** (multi-file subsystem, cross-cutting feature, full overview): step 2.
- When in doubt, take the simple path.

## 2. Explore (complex only)

Decompose the question into 2 to 4 angles, each a distinct slice of the subsystem. Brief one explorer per angle, all in one round so they run concurrently. Each brief is self-contained (goal, scope, context, acceptance, verify, timebox, forbidden, report); pick the model by role from the repo model map (`craft-how-explorer` role) when one exists, else your own model. Explorers are read-only and stay on their own angle.

Each explorer reports Components Found (name, file, one line each), Flow (step-by-step with the data between steps), Files Read, Boundaries (inputs and outputs to the rest of the codebase), Non-Obvious Things, and Open Questions (honest gaps).

## 3. Synthesize (complex only)

One synthesizer (`craft-how-explainer` role) takes every explorer finding and reconciles them into one picture: merge overlaps, resolve contradictions by checking the code, combine the slices.

## 4. Present

Present the synthesis in the sections below, dropping any that do not apply. Light edits for conversation context are fine; do not substantially rewrite it.

## Output sections

- **Overview.** 1 to 2 paragraphs: what it is, what it does, why it exists. A reader decides from this alone whether to keep reading.
- **Key Concepts.** The types, services, or abstractions needed to follow the rest. Brief definitions, not exhaustive.
- **How It Works.** The core and longest section: trigger, step-by-step flow, where data goes, decision points. Prose with file and function references, not pseudocode; no large code blocks unless a snippet is essential. Add a mermaid diagram when components talk to each other or data transforms through stages; skip it when prose covers the flow.
- **Where Things Live.** The file and directory map someone needs to start working here.
- **Gotchas.** Non-obvious behavior, pitfalls, historical context. Skip when there is nothing worth calling out.

Style: concrete language (`UserService` calls `AuthClient.refresh()`, not "the service delegates to the client"); explain why something is complex instead of only describing it; do not pad what is simple; surface open questions and gaps instead of hiding them.
