---
title: "Factory: how this repo works layer by layer"
description: "TL;DR map of the software factory: loop, environment, strategy, and team, each box linked to the skill or playbook that runs it."
---

# Factory: how this repo works layer by layer

Credit: map after Matt Pocock, see [CREDITS.md](./CREDITS.md).

## TL;DR

This repo turns a vague idea into a reviewed ready PR through one fixed factory: map first, guardrails second, then small walked tickets. Agents run AFK inside that loop with fresh context per ticket, and every claim leaves proof in the PR. Strategy and team layers keep the loop honest: shared language, written decisions, sceptical review, and ownership of each diff. Solo repos land on the local verifier, team repos on required checks; risk tiers add verification (fresh-context run, verify-blast, adversarial review) where the blast radius earns it.

## Overview

```mermaid
flowchart TD
    subgraph Loop["Loop"]
        G["Grill, spec, tickets"]
        A["AFK agents"]
        R["Review in fresh context"]
        M["Merge on evidence"]
    end
    subgraph Env["Environment"]
        D["Deep modules"]
        T["Tests and types"]
        I["AGENTS.md pointers"]
    end
    subgraph Strat["Strategic"]
        K["Knowledge"]
        P["Practices"]
    end
    subgraph Team["Team"]
        O["Ownership"]
        S["Same page"]
        L["Leadership"]
    end
    G --> A --> R --> M
    D --> A
    T --> A
    I --> A
    K --> G
    P --> R
    O --> M
    S --> A
    L -.-> O
```

## Loop and environment

```mermaid
flowchart TD
    Grill["Grill: plan-grill-docs, plan-interview"] --> Spec["Spec: plan-spec"] --> Tickets["Tickets: plan-tickets"] --> AFK["AFK: whips, ship-runner"] --> Review["Review: review-code, review-adversary, ready-check"] --> Merge["Merge: ship-pr, opening-a-pr, RISK"]
    Deep["Deep modules"] --> AFK
    Tests["Tests and types"] --> AFK
    Idx["AGENTS.md pointers"] --> AFK
```

| Box | In this repo | Skill or playbook | Status |
| --- | --- | --- | --- |
| Grill, spec, tickets | Grill with docs, plan-interview primitive, spec, tickets, plan-map for fog | [plan-grill-docs](../plan-grill-docs/SKILL.md), [plan-interview](../../model-invoked/plan-interview/SKILL.md), [plan-spec](../plan-spec/SKILL.md), [plan-tickets](../plan-tickets/SKILL.md), [plan-map](../plan-map/SKILL.md) | ada |
| AFK agents | Whips routes each unit, ship-runner works queues on schedule, autopilot owners carry one PR each to MERGED (or hold the stack for the operator), craft-swarm fans out parallel work | [whips](../whips/SKILL.md), [orchestrate](../whips/playbooks/orchestrate.md), [autopilot-full](../whips/playbooks/autopilot-full.md), [autopilot-stack](../whips/playbooks/autopilot-stack.md), [pickup](../whips/playbooks/pickup.md), [pause](../whips/playbooks/pause.md), [ship-runner](../ship-runner/SKILL.md), [craft-swarm](../../model-invoked/craft-swarm/SKILL.md) | ada |
| Review in a fresh context | Two-axis review, adversarial review, independent ready-check verdict, clear context between tickets | [review-code](../../model-invoked/review-code/SKILL.md), [review-adversary](../../model-invoked/review-adversary/SKILL.md), [ready-check](../whips/playbooks/ready-check.md), [guide](./SKILL.md) | ada |
| Merge on evidence | PR body with proof, opening checklist, risk tier, proof URL check | [ship-pr](../../model-invoked/ship-pr/SKILL.md), [opening-a-pr](../whips/playbooks/opening-a-pr.md), [ready-check](../whips/playbooks/ready-check.md), [RISK](../whips/RISK.md) | ada |
| Deep modules | Shared vocabulary, scan for shallow modules, one-time TypeScript wiring, settle shape before code | [craft-vocab](../../model-invoked/craft-vocab/SKILL.md), [craft-deepen](../craft-deepen/SKILL.md), [setup-ts-modules](../setup-ts-modules/SKILL.md), [craft-architect](../../model-invoked/craft-architect/SKILL.md) | ada |
| Tests and types as feedback loops | Red-green refactor, hooks and checks, generated verification skill, upkeep, formal checks where tests cannot reach, tight craft-diagnose loop, blast radius check | [verify-tdd](../../model-invoked/verify-tdd/SKILL.md), [setup-hooks](../../model-invoked/setup-hooks/SKILL.md), [verify-new](../verify-new/SKILL.md), [verify-upkeep](../verify-upkeep/SKILL.md), [create-formal-verification](../create-formal-verification/SKILL.md), [maintain-formal-verification](../maintain-formal-verification/SKILL.md), [verify-statechart](../verify-statechart/SKILL.md), [craft-diagnose](../../model-invoked/craft-diagnose/SKILL.md), [verify-blast](../../model-invoked/verify-blast/SKILL.md) | ada |
| AGENTS.md as an index of pointers | Repo [AGENTS.md](../../../AGENTS.md) is a pointer index into [.agents/](../../../.agents/) | [craft-agent-docs](../../model-invoked/craft-agent-docs/SKILL.md), [setup-repo](../setup-repo/SKILL.md) | ada |

## Strategic layer

```mermaid
flowchart TD
    subgraph Know["Knowledge"]
        Lang["Shared language"]
        Goals["Clear goals"]
        Dec["Written decisions"]
    end
    subgraph Prac["Practices"]
        Plan["Planning nerve"]
        Scep["Sceptical review"]
        Maint["Maintenance"]
    end
    Lang --> Goals --> Dec
    Plan --> Scep --> Maint
    Dec --> Plan
```

| Box | In this repo | Skill or playbook | Status |
| --- | --- | --- | --- |
| One shared language | Glossary habit plus domain modeling inside doc interviews, re-pitch when a message misses | [craft-domain](../../model-invoked/craft-domain/SKILL.md), [plan-grill-docs](../plan-grill-docs/SKILL.md), [learn-restate](../learn-restate/SKILL.md) | ada |
| Clear goals | Goal restated before playbook match, sharpened brief, spec | [whips](../whips/SKILL.md), [plan-sharpen](../plan-sharpen/SKILL.md), [plan-spec](../plan-spec/SKILL.md) | ada |
| Decisions written down | ADRs under .agents/adr, paper trail interviews, decision trail, map decisions, personal loops | [plan-grill-docs](../plan-grill-docs/SKILL.md), [craft-trail](../../model-invoked/craft-trail/SKILL.md), [plan-map](../plan-map/SKILL.md), [plan-worklog](../plan-worklog/SKILL.md) | ada |
| Planning nerve | One-shot versus grill versus plan-map rule, recipes 1 and 3, figure-it-out for work with no playbook | [guide](./SKILL.md), [COOKBOOK](./COOKBOOK.md), [figure-it-out](../whips/playbooks/figure-it-out.md) | ada |
| Sceptical review | Adversarial review, two-axis review, principles, stress page, number check before reporting | [review-adversary](../../model-invoked/review-adversary/SKILL.md), [review-code](../../model-invoked/review-code/SKILL.md), [PRINCIPLES](../whips/PRINCIPLES.md), [craft-break](../../model-invoked/craft-break/SKILL.md), [verify-bench](../../model-invoked/verify-bench/SKILL.md) | ada |
| Maintenance without blame | Retro states the blame-free rule, backed by the correction ladder, upkeep playbook, verification upkeep, and deslop passes; learn-reflect routes session learnings back into skills | [learn-retro](../learn-retro/SKILL.md), [learn-reflect](../learn-reflect/SKILL.md), [craft-correct](../../model-invoked/craft-correct/SKILL.md), [upkeep](../whips/playbooks/upkeep.md), [verify-upkeep](../verify-upkeep/SKILL.md), [craft-deepen](../craft-deepen/SKILL.md), [review-nocomment](../../model-invoked/review-nocomment/SKILL.md) | ada |

## Team layer

```mermaid
flowchart TD
    Own["Ownership: explain, drill, delegate"] --> Same["Same page: learn-catchup, learn-recall, learn-handoff"] --> Lead["Leadership: out of scope"]
    Same --> Own
```

| Box | In this repo | Skill or playbook | Status |
| --- | --- | --- | --- |
| Ownership | Learning gates (deprecated from merge path; `/learn-teach` or `plan-interview` for the value, with delegated-learning notes folded in) | [learn-diff-gate](../learn-diff-gate/SKILL.md) (deprecated 2026-10-31: not called from merge, ready-check, shipping, or opening-a-pr) | ada |
| On the same page | Catch-up, context rebuild, handoff note, re-pitch | [learn-catchup](../learn-catchup/SKILL.md), [learn-recall](../learn-recall/SKILL.md), [learn-handoff](../learn-handoff/SKILL.md), [learn-restate](../learn-restate/SKILL.md) | ada |
| Leadership that backs it | Solo repo with no org layer, so no skill covers it | | gap |

## Gap list

- **Leadership that backs it (gap):** team backing is an org concern and this repo ships for solo use. Suggestion: keep it out of scope, revisit only when a team adopts the repo.

## Next step

Read the router in [SKILL.md](./SKILL.md) when you want a skill picked for you, and the recipes in [COOKBOOK.md](./COOKBOOK.md) when you want the ordered steps.
