---
name: guide
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Guide

You don't remember every skill, so ask. Default load is this file only: open [COOKBOOK.md](COOKBOOK.md) only for a recipe, [FACTORY.md](FACTORY.md) only for the big picture, [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) only at a phase boundary.

## Start here

- Idea to build: the main-flow recipe in [COOKBOOK.md](COOKBOOK.md).
- Backlog piling up: `/whips` intake.
- Hard bug: the whips `bug` playbook, then `/whips` refactor for the seam.
- Foggy idea: `plan-interview`, or `/whips` drive-through.
- Long runs: [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) (continue/clear/note/subagent/compact).
- Setup first: `/setup-repo`.

## On-ramps
- **`/report-issue`** files a ticket; **`/whips`** ripens it and builds it.
- **`/whips`** takes the hard bugs with a tight feedback loop first, via its `bug` playbook.
- **`plan-interview`** sharpens foggy work into decisions and slices them into tracer bullets.

- Every skill, one-line blurb each: skill sections in [README.md](../../../README.md).
- Upstream split: pstack owns automation and shipping, Matt owns planning ([upstream-map.md](../../../docs/upstream-map.md)).
- Stages: [stage-pipeline.md](../whips/playbooks/stage-pipeline.md). Landing and risk: [opening-a-pr.md](../whips/playbooks/opening-a-pr.md) and [RISK.md](../whips/RISK.md).
- Advanced: [COOKBOOK.md](COOKBOOK.md).
