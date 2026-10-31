---
name: guide
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Guide

You don't remember every skill, so ask. Read only the section below that fits; each names its file. [COOKBOOK.md](COOKBOOK.md) holds recipes with diagrams; [FACTORY.md](FACTORY.md) holds the layered big picture.

A **flow** is a path through the skills. Most paths run along one **main flow**, and two **on-ramps** merge onto it.

Stub until #191 lands the wording: the upstream split keeps one sentence plus the upstream-map link in this file.

## Start here

- Idea to build: read the main-flow recipe in [COOKBOOK.md](COOKBOOK.md) (grill, spec, tickets, whips, review, merge).
- Bugs or requests piling up: `## On-ramps` below for `/ship-triage`, then `/ship-runner`.
- Something broken and hard: `/craft-diagnose` (below), then `/craft-deepen` for the seam.
- Huge foggy effort: `/plan-map` (below), then merge onto the main flow at `/plan-spec`.
- Long run mechanics: `## Phase boundaries` below for continue/clear/note/subagent/compact.
- Whips-driven skills, vocabulary, standalone list: `## Reference` below (one line each, no detail).
- Setup first: `/setup-repo` (below), plus `/verify-new` for scripted proof. After that, offer `/create-formal-verification` only when the repo has race, retry, state machine, parser, or unsafe code that tests rarely reach; never push it.

Read [COOKBOOK.md](COOKBOOK.md) only when a recipe fits; read [FACTORY.md](FACTORY.md) only for the big picture; read [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) only at a phase boundary.

## On-ramps

- **`/ship-triage`** moves issues through triage roles to agent-ready; **`/ship-runner`** works that queue on schedule. Triage is only for issues you didn't create.
- **`/craft-diagnose`** takes the hard bugs (flake, regression between known-good states) with a tight feedback loop first.
- **`/plan-map`** charts decision tickets for efforts too big for one session; it hands off to `/plan-spec`, never builds.

## Phase boundaries

Continue, `/clear`, portable note (`/learn-handoff`), subagent, `/compact` (default). Decide at a boundary; mid-phase, continue or split. Detail in [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md).

## Reference

- Whips-driven (fired by `/whips`, never typed): `/craft-how`, `/craft-why`, `/craft-architect`, `/craft-arena`, `/review-adversary`, `/review-nocomment`, `/verify-blast`, `/verify-bench`, `/craft-trail`, `/craft-correct`, `/review-prose`, `/craft-ui-timeline`, `/craft-manual`.
- Vocabulary: `/craft-domain`, `/craft-vocab`.
- Standalone: `/plan-grill`, `/plan-interview`, `/ship-merge-fix`, `/craft-break`, `/plan-sharpen`, `/craft-proto`, `/craft-research`, `/craft-wizard`, `/learn-restate`, `/learn-catchup`, `/learn-recall`, `/learn-teach`, `/learn-handoff`, `/learn-retro`, `/learn-reflect`, `/plan-worklog`, `/craft-agent-docs`, `/setup-ts-modules`. Deprecated from merge path: `/learn-diff-gate` (learning value in `/learn-teach`/`plan-interview`; execute is `/whips` only).

## Precondition

**`/setup-repo`**: run before your first flow (tracker, labels, docs, autonomy, jobs, optional models). Projects needing scripted proof add **`/verify-new`** with **`/verify-upkeep`** upkeep. Where tests cannot reach (race, retry, state machine, parser, unsafe code), offer **`/create-formal-verification`** with **`/maintain-formal-verification`** upkeep and **`/verify-statechart`** charts; only when it fits, never by default.
