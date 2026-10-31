# Playbook: plan-map handoff

A huge, foggy effort that no single session can hold. The map and its collapse are human gates: `/plan-map`, `/plan-spec`, and `/plan-tickets` are user-invoked, so you tell the user to run each one and wait. This playbook keeps the order straight and builds the tickets once they exist.

This playbook covers the foggy-effort branch of the full pipeline. Full stage order plus learn-handoff contract: `playbooks/stage-pipeline.md`.
When the tickets need one lintable cross-phase plan before building, write it with `playbooks/multi-phase-plan.md`.

1. Confirm the fog: the way from here to the destination is not visible in one session. A well-scoped feature that fits one session is not this playbook; route it to feature.
2. Tell the user to run `/plan-map`. It builds the shared map of decision tickets on the tracker and resolves them one at a time. Each ticket produces decisions, not deliverables. Stop here until the map clears.
3. At the handoff, tell the user to run `/plan-spec`: it collapses the linked decisions into one buildable plan. Never jump from the map straight to code; that skips the collapse and throws the linked detail away. Genuinely small outcomes may go straight to feature, nothing else.
4. Tell the user to run `/plan-tickets`: it splits the spec into tracer-bullet tickets with blocking edges. Ticket boundaries are the user's call.
5. Build the tickets blockers-first, one per `/whips` run with a cleared context between each: the feature or bug playbook, closing with review plus review-unslop plus PR body, then `playbooks/opening-a-pr.md`.
