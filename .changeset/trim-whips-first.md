---
"skills-for-agents": minor
---

Whips-first trim: drop 14 rarely used user-invoked skills and fold 9 model-invoked skills into whips playbooks.

Removes `learn-catchup-video`, `plan-grill`, `plan-grill-docs`, `verify-statechart`, `verify-new`, `verify-upkeep`, `plan-map`, `plan-worklog`, `plan-spec`, `plan-sharpen`, `ship-runner`, `ship-triage`, `setup-ts-modules`, and `plan-tickets`. Folds `craft-arena` plus `craft-swarm` into the `fan-out` playbook, `verify-bench` into the `perf-issue` bench checklist, `craft-how` plus `craft-why` into the `investigation` how-trace and why-trace, `review-code` plus `review-adversary` into the `review` playbook, and `craft-manual` plus `craft-ui-timeline` into the `proof-visual` playbook (tooling moved under `whips/scripts/proof-visual/`). `plan-interview` replaces both grill wrappers and sharpening, and now slices tickets too; `whips` triage ripen replaces `ship-triage`; the map, collapse, and tickets run inline via `plan-map-handoff.md`; `create-formal-verification` plus `maintain-formal-verification` stay the two verification skills. `learn-reflect` also routes accepted learnings to docs updates (taste, standards, glossary), not just skill edits. Router, aliases, setup, models, and stub suites updated to match.
