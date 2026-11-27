---
name: guide
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Guide

You don't remember every skill, so ask. Default load is this file only: open [COOKBOOK.md](COOKBOOK.md) only for a recipe, [FACTORY.md](FACTORY.md) only for the big picture, [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) only at a phase boundary.

## Triggers

1. Foggy idea or scope to slice: `plan-interview`.
2. Backlog ticket to build: `/whips` intake.
3. Hard bug: the whips `bug` playbook, then `/whips` refactor.
4. Code crossing a function boundary: `craft-architect`.
5. Parallel runners: the whips `fan-out` playbook.
6. Long or unattended run: `craft-trail`.
7. Prose, docs, PR or commit text: `review-prose` on top of `review-unslop`.
8. Measured number: explain what limits it before trusting it.
9. Setup first: `/setup-repo`. Full catalog plus recipes: [COOKBOOK.md](COOKBOOK.md).
10. Every skill, one-line blurb each: skill sections in [README.md](../../../README.md).
11. Upstream split: pstack owns automation and shipping, Matt owns planning ([upstream-map.md](../../../docs/upstream-map.md)).
12. Stages: [stage-pipeline.md](../whips/playbooks/stage-pipeline.md). Landing and risk: [opening-a-pr.md](../whips/playbooks/opening-a-pr.md) and [RISK.md](../whips/RISK.md).
13. Advanced: [COOKBOOK.md](COOKBOOK.md).
