# Playbook: wayfinder handoff

A huge, foggy effort that no single session can hold. `/wayfinder` charts the map, this playbook hands the cleared map into the build without losing its linked detail.

1. Confirm the fog: the way from here to the destination is not visible in one session. A well-scoped feature that fits one session is not this playbook; route it to feature.
2. `/wayfinder` builds the shared map of decision tickets on the tracker and resolves them one at a time. Each ticket produces decisions, not deliverables.
3. At the handoff, collapse the map: `/to-spec` turns the linked decisions into one buildable plan. Never loop the map straight into `/implement`; that skips the collapse and throws the linked detail away. Genuinely small outcomes may go straight, nothing else.
4. `/to-tickets` splits the spec into tracer-bullet tickets with blocking edges, worked blockers-first per ticket with `/implement` and a cleared context between each one.
5. Each `/implement` runs the feature or bug playbook inside, closing with review plus unslop plus PR body per ticket, then `playbooks/opening-a-pr.md`.

