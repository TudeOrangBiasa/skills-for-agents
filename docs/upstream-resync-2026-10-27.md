# Upstream resync note: whips playbooks vs pstack at ab1f702 (2026-10-27)

Diff report only, per #228. Compared SFA `skills/user-invoked/whips/playbooks/` plus `review-unslop` and `craft-trail` against the pstack `poteto-mode` tree and leaf skills at `ab1f702` (post-#986). No code copied; candidates listed for later port tickets.

Files compared (SFA side, all at main `596ac19` before this wave):

- `opening-a-pr.md`, `shipping.md`, `ready-check.md` vs pstack opening/landing equivalents
- `feature.md`, `bug.md`, `figure-it-out.md` vs pstack feature and autonomous-run equivalents
- `multi-phase-plan.md`, `stage-pipeline.md`, `plan-map-handoff.md` vs pstack program and pipeline equivalents
- `review-unslop` (model-invoked) and `craft-trail` vs pstack `unslop` and `show-me-your-work`

Findings:

1. Briefing shape: pstack opening-a-pr mandates Why, What changed, Scope, Tradeoffs, Blast Radius, Verification. SFA matched only Summary, Evidence, Merge Danger plus Scope and Verification lines. Ported in this wave (#216): six-section briefing in `opening-a-pr.md` step 6, aligned with the `ship-pr` body shape (#220).
2. Autonomous execution: pstack has a dedicated until-predicate playbook (wake, smallest change per iteration, discard non-progress, decision trail, never relax done). SFA covered it only via figure-it-out section B behind a human design gate. Ported in this wave (#212): `autonomous-run.md`, harness-neutral wake only.
3. Overnight trust contract: pstack guide 07-overnight teaches checkable done, permissions, escape hatch, morning audit via trail. SFA cookbook recipe 4 named the queue but not the contract. Ported in this wave (#214): cookbook 4b plus autonomous-run pointer.
4. Smallest-change culture: pstack forces goal plus smallest change at task start and an MVP slice with stop-after-verified on feature and bug paths. SFA restated the goal only and had no slice or stop rule. Ported in this wave (#211).
5. Solo drive-through: pstack treats thin-fog plan-spec and tickets as inline work. SFA gated on named user-invoked skills except plan-map-handoff. Ported in this wave (#215).
6. No further blind copies: review-unslop, craft-trail, stage-pipeline, and multi-phase-plan already track their pstack counterparts (credit rows in CREDITS.md and the upstream map); no behavior gaps found worth a port ticket.

Freshness: this note is the resync evidence for the 2026-10-27 pstack tip. Next resync compares against whatever tip is current then.
