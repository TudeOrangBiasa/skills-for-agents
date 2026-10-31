---
name: guide
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Guide

You don't remember every skill, so ask. Default load is this file only: open [COOKBOOK.md](COOKBOOK.md) only for a recipe, [FACTORY.md](FACTORY.md) only for the big picture, [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) only at a phase boundary.

## Start here

- Idea to build: the main-flow recipe in [COOKBOOK.md](COOKBOOK.md).
- Backlog piling up: `/ship-triage`, then `/ship-runner`.
- Hard bug: `/craft-diagnose`, then `/craft-deepen` for the seam.
- Huge foggy effort: `/plan-map`, then `/plan-spec`.
- Long runs: [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) (continue/clear/note/subagent/compact).
- Setup first: `/setup-repo`, plus `/verify-new` for scripted proof.

## On-ramps
- **`/ship-triage`** ripens issues to agent-ready; **`/ship-runner`** works that queue on schedule.
- **`/craft-diagnose`** takes the hard bugs with a tight feedback loop first.
- **`/plan-map`** charts decision tickets for efforts too big for one session; it hands off to `/plan-spec`, never builds.

- Every skill, one-line blurb each: the skill sections in [README.md](../../../README.md).
- Upstream split: pstack owns automation and shipping, Matt owns planning ([upstream-map.md](../../../docs/upstream-map.md)).
- Stages: [stage-pipeline.md](../whips/playbooks/stage-pipeline.md). Landing and risk: [opening-a-pr.md](../whips/playbooks/opening-a-pr.md) and [RISK.md](../whips/RISK.md).
