---
name: guide
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Guide

You don't remember every skill, so ask. Read only the section below that fits; each names its file. [COOKBOOK.md](COOKBOOK.md) holds recipes with diagrams; [FACTORY.md](FACTORY.md) holds the layered big picture.

A **flow** is a path through the skills. Most paths run along one **main flow**, and two **on-ramps** merge onto it.

## Start here

- Idea to build: read the main-flow recipe in [COOKBOOK.md](COOKBOOK.md) (grill, spec, tickets, whips, review, merge).
- Bugs or requests piling up: `## On-ramps` below for `/triage`, then `/runner`.
- Something broken and hard: `/diagnose` (below), then `/deepen` for the seam.
- Huge foggy effort: `/wayfinder` (below), then merge onto the main flow at `/to-spec`.
- Long run mechanics: `## Phase boundaries` below for continue/clear/note/subagent/compact.
- Whips-driven skills, vocabulary, standalone list: `## Reference` below (one line each, no detail).
- Setup first: `/setup-meta` (below), plus `/create-verification` for scripted proof.

Read [COOKBOOK.md](COOKBOOK.md) only when a recipe fits; read [FACTORY.md](FACTORY.md) only for the big picture; read [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) only at a phase boundary.

## On-ramps

- **`/triage`** moves issues through triage roles to agent-ready; **`/runner`** works that queue on schedule. Triage is only for issues you didn't create.
- **`/diagnose`** takes the hard bugs (flake, regression between known-good states) with a tight feedback loop first.
- **`/wayfinder`** charts decision tickets for efforts too big for one session; it hands off to `/to-spec`, never builds.

## Phase boundaries

Continue, `/clear`, portable note (`/handoff`), subagent, `/compact` (default). Decide at a boundary; mid-phase, continue or split. Detail in [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md).

## Reference

- Whips-driven (fired by `/whips`, never typed): `/how`, `/why`, `/architect`, `/arena`, `/interrogate`, `/no-comments`, `/blast-radius`, `/benchmark-checklist`, `/show-me-your-work`, `/correct`, `/technical-writing`, `/ui-recording-timeline`, `/user-manual`.
- Vocabulary: `/domain-modeling`, `/codebase-design`.
- Standalone: `/discuss`, `/interview`, `/merge-fix`, `/break`, `/sharpen`, `/prototype`, `/research`, `/wizard`, `/showcase`, `/wait-what`, `/ketchup`, `/recall`, `/teach`, `/handoff`, `/retro`, `/worklog`, `/writing-for-agents`, `/setup-ts-deep-modules`, `/explain-diff-before-merge`, `/judgment-drill`, `/learn-while-delegating`.

## Precondition

**`/setup-meta`**: run before your first flow (tracker, labels, docs, autonomy, jobs, optional models). Projects needing scripted proof add **`/create-verification`** with **`/maintain-verification`** upkeep.
