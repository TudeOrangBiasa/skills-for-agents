# Playbook: wayfinder handoff

A huge, foggy effort that no single session can hold. The map and its collapse are human gates: `/wayfinder`, `/to-spec`, and `/to-tickets` are user-invoked, so you tell the user to run each one and wait. This playbook keeps the order straight and builds the tickets once they exist.

1. Confirm the fog: the way from here to the destination is not visible in one session. A well-scoped feature that fits one session is not this playbook; route it to feature.
2. Tell the user to run `/wayfinder`. It builds the shared map of decision tickets on the tracker and resolves them one at a time. Each ticket produces decisions, not deliverables. Stop here until the map clears.
3. At the handoff, tell the user to run `/to-spec`: it collapses the linked decisions into one buildable plan. Never jump from the map straight to code; that skips the collapse and throws the linked detail away. Genuinely small outcomes may go straight to feature, nothing else.
4. Tell the user to run `/to-tickets`: it splits the spec into tracer-bullet tickets with blocking edges. Ticket boundaries are the user's call.
5. Build the tickets blockers-first, one per `/whips` run with a cleared context between each: the feature or bug playbook, closing with review plus unslop plus PR body, then `playbooks/opening-a-pr.md`.
