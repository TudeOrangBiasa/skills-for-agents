---
description: "Usage cookbook for the skills: when to use each flow, skills in order, plus a diagram per recipe."
title: "Cookbook: flows and recipes"
---
# Cookbook: flows and recipes

Each recipe is one complete workflow: when to use it, which skills to type in order, and its diagram. Diagrams render in preview. The interactive router stays in [`SKILL.md`](./SKILL.md); this book is for reading directly. For the big picture, read [FACTORY.md](./FACTORY.md).

Conventions in every diagram: boxes are skills you type (`/whips`) or playbooks whips runs, diamonds are your decisions, dashed arrows are escalations.

## 0. Which path (master map)

```mermaid
flowchart TD
    T["Task in"] --> Q1{"Small and obvious?"}
    Q1 -->|yes| ONE["One-shot: /whips or direct"]
    Q1 -->|no| Q2{"Path visible?"}
    Q2 -->|"yes, one session"| IDEA["/plan-grill-docs, /plan-spec, /plan-tickets, /whips per ticket"]
    Q2 -->|"very foggy"| WAY["/plan-map into a map, then main flow"]
    Q2 -->|"real work, no playbook"| FIG["/whips routes to figure-it-out: design, approve, run"]
    ONE --> PR["Ready PR, landing follows risk tier"]
    IDEA --> PR
    WAY --> PR
    FIG --> PR
```

Thin fog skips the hops: when one interview round settles it in a fresh context, `/whips` drives through interview, spec sketch, and tickets inline (drive-through policy) instead of changing sessions.

## 1. Tiny fix one-shot

When: one line, a symlink, a config flag, a copy typo.

```mermaid
flowchart LR
    T["Fix in"] --> W["/whips or direct"] --> V["Verify on the same surface"] --> P["Ready PR, low-risk lands"]
```

No interview: it costs more than the work.

Example: dead `public/storage` symlink. Type into `/whips`: "re-link public/storage to storage/app/public, verify with ls -l". One low-risk PR, lands directly.

## 2. Idea to ship (main flow)

When: an idea to build within one session or a few tickets.

```mermaid
flowchart TD
    D["/plan-grill-docs"] --> Q{"Runnable answer needed?"}
    Q -->|yes| P["prototype sketch, carry the answer as a note"]
    Q -->|no| S["/plan-spec"]
    P --> S
    S --> T["/plan-tickets"] --> W["/whips per ticket, fresh context between"]
    W --> B["whips babysit playbook to green"] --> R["whips ready-check playbook: verdict + risk label"] --> M["Land per mode: solo verifier, team checks"]
```

One unbroken window for grill through tickets; each whips run starts fresh. Thin fog skips the hops via drive-through (recipe 0). Gate to a dedicated session only when the fog needs its own window.

Spec and tickets already exist: skip straight to `/whips` per ticket, blockers-first along the frontier, fresh context (and `/clear`) between tickets. Tracker issues with `ready-for-agent`: `/whips` intake interactively, `/ship-runner` unattended.

Example: "skeleton loading on the Menu page". `/plan-grill-docs` decides one reusable Skeleton component (not one per page), `/plan-spec`, `/plan-tickets` (3 tickets: component, use in Menu, e2e proof), `/whips` per ticket.

Upstream split: pstack owns automation and shipping, Matt owns planning ideas ([upstream-map.md](../../../docs/upstream-map.md)).

## 3. Foggy to map

When: greenfield or a giant feature with no visible path.

```mermaid
flowchart TD
    D["/plan-grill-docs"] --> Q{"Planning out of hand?"}
    Q -->|"not yet"| D
    Q -->|yes| W["/plan-map into a map: 'turn this into a map'"]
    W --> S["/plan-spec collapses the map"] --> T["/plan-tickets"] --> W2["/whips per ticket"]
```

Never start with plan-map: a map and tickets you turn out not to need are self-made garbage. And thin fog never reaches it: drive-through inside whips handles what one interview round settles.

Example: "migrate media uploads to S3". Start `/plan-grill-docs`; planning sprawls into cost, rollback, seeders, so type "`/plan-map` let's turn this into a map" → map of decision tickets → `/plan-spec` collapses the map → tickets → whips.

## 4. Overnight unattended

When: sleep while the queue resolves itself.

```mermaid
flowchart TD
    T["/ship-triage: ripen issues"] --> N["/ship-runner: queue runs itself"]
    N --> M["Morning: /learn-catchup"]
    M --> R["whips ready-check playbook"] --> G["Land per mode; humans at triage"]
```

Alternative for one long unattended run: `/whips` with a checkable predicate plus budget, not a queue. Execute stays `/whips` only. With a clear predicate, run the [autonomous-run](../whips/playbooks/autonomous-run.md) playbook: predicate, wake, smallest change per iteration, decision trail, never relax the predicate.

## 4b. Overnight trust contract

When: the queue runs while you sleep (#214).

```mermaid
flowchart TD
    D["Done predicate written"] --> W["Wake: cron, interval loop, or ship-runner tick"] --> R["Run: smallest change per iteration, verify, commit or revert"] --> S["Stop rules fire"] --> M["Morning: decision trail plus catchup"]
```

Done means: a falsifiable predicate written before the run, checked on the real artifact after each iteration. Stop rules: the predicate holds, the iteration or hour budget runs out, or no approach is left (write what was tried and hand back). Never relax the predicate to declare victory. Work lands per risk tier; humans decide at triage and on irreversible actions. Wake wording stays harness-neutral: cron, an interval loop, or a ship-runner tick. Morning audit reads the decision trail (`.scratch/whips/<run>/decisions.tsv`) plus `/learn-catchup`.

## Advanced (off the main flow)

These ship but sit outside the COOKBOOK and FACTORY main path; reach for them only when the task names them. Formal proof: `/create-formal-verification`, `/maintain-formal-verification`. Skill authoring: `/craft-agent-docs` via the authoring playbook. Optional repo layout: `/setup-ts-modules`. Quarantined: `/learn-diff-gate` (deprecated from the merge path; stays installed but off the default flow).

## FAQ

For the full catalog of skills, see the skill sections in [README.md](../../../README.md). Each answer below is one pointer; the owning skill holds the detail.

**Issues exist but carry no labels?** → [`/ship-triage`](../ship-triage/SKILL.md) walks each issue to a triage role; roles in its SKILL.md.

**Labels already say `ready-for-agent`?** → `/whips` intake while you watch, [`/ship-runner`](../ship-runner/SKILL.md) while you sleep.

**Spec and tickets already exist?** → `/whips` per ticket, blockers-first (recipe 2).

**PRs green, which merges first?** → `/whips` with "check on PR X" or "merge plan" ([ready-check](../whips/playbooks/ready-check.md) verdicts, land per [RISK](../whips/RISK.md)).

**PRD in hand but the stack is undecided?** → [`/plan-grill-docs`](../plan-grill-docs/SKILL.md) to settle it, then the main flow (recipe 2).

**MVP scoped but deploy target unknown?** → `/plan-grill-docs` for constraints plus primary-source reading for platform facts, decided into an ADR.

**Sharpening a task or ticket before a run?** → [`/plan-sharpen`](../plan-sharpen/SKILL.md) for a brief, [`/plan-grill`](../plan-grill/SKILL.md) for a plan with no repo under it.

**Learning something over multiple sessions?** → [`/learn-catchup`](../learn-catchup/SKILL.md) to resume, then `/whips` to build.

**Automating loops in your own life?** → [`/plan-worklog`](../plan-worklog/SKILL.md); repo-work checkpoints hand off to `/whips` or `/ship-runner`.

**Handed a project with no map?** → orient before building: [`craft-how`](../../model-invoked/craft-how/SKILL.md) walkthrough first, then [`/setup-repo`](../setup-repo/SKILL.md) when its output is missing.

**Setting up a repo for a mixed team?** → [`/setup-repo`](../setup-repo/SKILL.md) first: one tracker, one label vocabulary, frontier discipline.

**Monorepo built and developed together?** → [`/setup-repo`](../setup-repo/SKILL.md) multi-context (per-context glossaries).

**Starting TypeScript packages that import across each other?** → [`/setup-ts-modules`](../setup-ts-modules/SKILL.md) once, before agents start importing. Advanced skill, off the main flow.

**Whole project still needs research across domains?** → one primary-source read per domain in parallel via `/whips` investigation, then `/plan-grill-docs` to decide.

**No frontend design and no hassle wanted?** → `/whips` per ticket with "no design, keep one simple variant".

**Big decisions changed and meta docs went stale?** → [`/learn-reflect`](../learn-reflect/SKILL.md) contradiction pass, proposed first and written only on approval.

**Sessions lost, forgot what was done?** → reconstruct from ground truth (git log, tracker, docs as-is), then `/learn-reflect` to resync.

**Starting fresh but recent work spans several chats?** → [`/learn-recall`](../learn-recall/SKILL.md): mines repo history plus session traces into a capsule brief.

**Multi-day program with one approval up front?** → [`figure-it-out`](../whips/playbooks/figure-it-out.md) for the designed phase list, then `/ship-runner` or one unattended run to execute.

**Must AFK with a deadline near, parallel tickets, no QA time?** → frontier tickets to `/ship-runner` before leaving; morning [`/learn-catchup`](../learn-catchup/SKILL.md) plus ready-check via `/whips`.

**Overnight run missed the spec, start over?** → no: `/learn-catchup`, check the Spec axis, then `/whips` pickup with the spec plus the missed point.

**Frontend refactor with a stack change, design stays?** → [`visual-parity`](../whips/playbooks/visual-parity.md): baseline first, zero diff to pass.

**Stack plus design both change?** → new UI, not a migration: `/whips` ui/feature with the new design as the spec.

**Screenshots requested, can they be automated?** → yes: `agent-browser` drives the flow and captures screenshots, video, and timeline pages; [`/ship-pr`](../../model-invoked/ship-pr/SKILL.md) attaches them to the PR.

**Deploy to hosting with no SSH, scripts ready, env left to fill?** → hand the exact commands to the human; no skill walks human-only steps.

**Lost or behind?** → [`/learn-catchup`](../learn-catchup/SKILL.md) for news since your last message, [`/learn-catchup-video`](../learn-catchup-video/SKILL.md) to watch it, [`/learn-restate`](../learn-restate/SKILL.md) for one confusing message.

**Session over, make the environment better?** → [`/learn-reflect`](../learn-reflect/SKILL.md) writes learnings back into skills and proposes repo fixes.

**Spare moment, shallow modules keep hurting?** → `/whips` upkeep playbook surveys the seam; `/whips` refactor extracts it.

**Slow path with a number to defend?** → [`perf-issue`](../whips/playbooks/perf-issue.md) baselines, [`hillclimb`](../whips/playbooks/hillclimb.md) iterates; a number without limiter, run count, and spread is not evidence (see [`verify-bench`](../../model-invoked/verify-bench/SKILL.md)).

**UI change needing proof?** → [`/craft-break`](../../model-invoked/craft-break/SKILL.md) stress on a throwaway page, then `/whips` ui; long video gets a [`craft-ui-timeline`](../../model-invoked/craft-ui-timeline/SKILL.md) page.
