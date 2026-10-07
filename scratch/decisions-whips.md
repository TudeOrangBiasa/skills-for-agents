# Decision trail: /whips (show-me-your-work catch-up)

Canonical log: `decisions-whips.tsv` (append-only). This file is the readable view.

## Frame

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Researched OMP vibe mode against primary sources | Director rules must be grounded, not guessed | Subagent report, omp.sh docs, can1357/oh-my-pi code | vibe_spawn/send/wait/kill/list, fast/good tiers, pain issues recorded |
| Decoded poteto pstack (Lauren Tan, cursor/plugins) | User terms mapped to real artifacts | pstack README, poteto-mode SKILL.md | Router plus 23 playbooks plus subagent discipline confirmed |
| Corrected 2000 PR/month to ~1000/month | Unverified claims rot into lore | UninformedInvestors plus Pocock interviews | ~1000/mo done, ~800/12d pace. Lesson: verification is the bottleneck |

## Design

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Named the skill `/whips` (Indonesian pecut) | User approved, director-drives-workers | Plan open questions | `skills/user-invoked/whips/` |
| VIBE-MAPPING.md as must-follow reference, not inline | Agents must follow rules every run | Plan, writing-for-agents | M1-M7 normative table |
| Routed-skills inventory (have/adapt/build/defer) | Router is thin, power is what it routes to | Leaf reads: how, why, architect, arena, interrogate, swarm, unslop, reflect, show-me, blast-radius | arena plus swarm plus unslop plus babysit/shipping are gaps; orchestrate deferred |
| Benny-equivalent automations deferred to walk | Map first | Plan Automations section | Triage-worker-audit shape recorded, pack later |
| Evidence gate plus unslop gate plus tools-are-not-people | User cannot review live, PR body is the review surface | pr ATTACHMENTS.md, OMP hooks docs | Proof-less PRs return NOT VERIFIED to a fresh agent |

## Build

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Scaffolded skill plus 6 playbooks plus wiring plus changeset | Spec sections 3/5/10 | `skills/user-invoked/whips/`, guide, READMEs, `.changeset` | A1-A5 pass, zero em dashes |

## Verify

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Dry ran feature playbook on README flow section | Prove the router on a real task | git diff 1+/1-, em dash grep | VERIFIED, left uncommitted for user review |
| Vibe pass on toy bug under `/vibe` | Prove the mapping on real tools | Verdict table, closeout PR body | All rows PASS (M1-M5, evidence, bug fixed) |

## Fix

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Follow-up turns in-unit plus todos in-thread | Vibe evidence: t1-t2 flow plus advisor concern | SKILL.md section 4, M1/M2 edits | Folded into source; test copy untouched |

## Close

| Decision | Why | Evidence | Result |
| --- | --- | --- | --- |
| Test workspace retired after pass | Single-use snapshot, do not maintain | User runs `rm -rf whips-test` | Pending user action |

## Attention

- README one-liner still uncommitted: commit or discard, your call.
- Merge timing is yours: changeset rides the next release.
- Walk phase candidates if you continue: automation pack, arena, swarm, unslop, per-role model mapping.
