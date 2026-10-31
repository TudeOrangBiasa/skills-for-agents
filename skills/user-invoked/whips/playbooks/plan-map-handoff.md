# Playbook: plan-map handoff

A huge, foggy effort that no single session can hold. Whips drives the whole wayfinder pipeline inline (map, collapse, tickets, build) with model-invoked primitives, reusing the map's Destination and Decisions-so-far verbatim instead of re-asking them. The only stops are product HITL (a decision ticket whose decision itself needs a human) and human-only steps. There is no process gate whose only job is telling the user to re-type a slash command.

This playbook covers the foggy-effort branch of the full pipeline. Full stage order plus learn-handoff contract: `playbooks/stage-pipeline.md`.
When the tickets need one lintable cross-phase plan before building, write it with `playbooks/multi-phase-plan.md`.

## Invocation rule

`/plan-map`, `/plan-spec`, and `/plan-tickets` are user-invoked: no skill can fire them, `/whips` included. Whips does not need to. It charts, collapses, and tickets by doing the same work directly: interview with the Skill tool (`plan-interview` plus `craft-domain`), research and prototype tickets via subagents (`craft-research`, `craft-proto`), and tracker writes per the tracker doc (`docs/agents/issue-tracker.md`). The user-invoked skills stay the human-typed entry points for the same pipeline; this playbook is how whips walks it without asking the user to paste three slash commands.

## Steps

1. Confirm the fog: the way from here to the destination is not visible in one session. Thin fog (one interview round settles it, single-session scope, context still fresh) is not this playbook; drive through inside `/whips` (interview, spec sketch, tickets inline), then route to the matching build playbook. A well-scoped feature that fits one session routes straight to feature.
2. Chart the map on the tracker: one issue labeled `plan-map:map` (Destination, Notes, Decisions-so-far, Not-yet-specified, Out-of-scope) plus child decision tickets with blocking edges, per the tracker doc's Wayfinding operations. Claim, resolve, and graduate exactly as the map skill prescribes; carry the Destination and every Decisions-so-far gist forward verbatim into each later step, never re-ask them.
3. Resolve decision tickets. Interview and Prototype tickets that need a live human reaction are product HITL: stop for the decision itself, then record it and continue. Research and AFK Task tickets run in subagents without stopping. Never stop merely to re-invoke a slash command.
4. When the map clears (destination visible, no blocking undecided fog), collapse inline: synthesize the spec from the linked decisions (the `plan-spec` shape: problem, solution, stories, decisions, testing, out of scope), then split it into tracer-bullet tickets with blocking edges (the `plan-tickets` shape), reusing Destination and Decisions-so-far, quoting RFI answers already on the map instead of re-asking. Never jump from the map straight to code; that skips the collapse and throws the linked detail away. Genuinely small outcomes may go straight to feature, nothing else.
5. Publish each ticket with exactly one type (`bug`, `feature`, `enhancement`, or `deprecation`), a `## Kompleksitas` section (Big-O in named inputs, gh calls, LLM calls), testable acceptance checkboxes, and `ready-for-agent` plus one risk label. A ticket missing any of these is not agent-ready: fix the ticket, never route around it.
6. Build the tickets blockers-first, one per `/whips` run with a cleared context between each: restate the ticket brief in your own words, then the feature or bug playbook, closing with review plus review-unslop plus PR body, then `playbooks/opening-a-pr.md`. No second fog interview: the map already settled the destination and the decisions, so build from the brief.
