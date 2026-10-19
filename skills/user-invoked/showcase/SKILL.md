---
description: "Show me what you built: diff, running result, and proof in one visual pass. Use when you want the demo, not the status."
disable-model-invocation: true
name: showcase
---
Show me what you built. Fire this when you want to see the work itself, not hear about it: the diff, the running result, the proof, in one visual pass. Distinct from `/ketchup` (news plus action items), `/wait-what` (one confusing message re-pitched), and `/recall` (context rebuilt across chats).

## Gather

Collect, do not narrate yet: the diff against the base branch (or the pointed files), branches and open PRs with their states, produced artifacts (screenshots, recordings, timeline pages, built assets), and the open items list. Missing proof is itself a finding: say which pair never got captured instead of describing around it.

## Present

One screen per change, most important first:

1. **What changed.** One plain sentence plus the smallest visual that proves it (before/after pair, diff snippet, screenshot, timeline link). Pick from the `wait-what` visual catalog: pseudocode for logic, call tree for flow, component tree for UI, file tree for layout, Mermaid for interaction, diff for what moved.
2. **Live state.** Where it runs now (branch, preview URL, PR link) and its verdict (tests, checks, risk tier).
3. **Open items.** What is unfinished or unproven, one line each, with the single next step.

## Rules

- Show, don't tell. Every claim rides a visual or an artifact link; a paragraph without either gets cut.
- Plain words per `unslop`; domain words per `GLOSSARY.md`.
- One visual per point. A wall of screenshots is a dump, not a demo.
- Report only work that landed or is measurably in flight. Plans and intentions belong in tickets, not in this demo.
