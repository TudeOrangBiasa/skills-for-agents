---
description: "Usage cookbook for the skills: when to use each flow, skills in order, plus a diagram per recipe."
title: "Cookbook: flows and recipes"
---
# Cookbook: flows and recipes

Each recipe is one complete workflow: when to use it, which skills to type in order, and its diagram. Diagrams render in preview. The interactive router stays in [`SKILL.md`](./SKILL.md); this book is for reading directly.

Conventions in every diagram: boxes are skills you type (`/whips`) or playbooks whips runs, diamonds are your decisions, dashed arrows are escalations. Every recipe closes with a real example from recent CMS work.

## 0. Which path (master map)

```mermaid
flowchart TD
    T["Task in"] --> Q1{"Small and obvious?"}
    Q1 -->|yes| ONE["One-shot: /whips or direct"]
    Q1 -->|no| Q2{"Path visible?"}
    Q2 -->|"yes, one session"| IDEA["/discuss-with-docs, /to-spec, /to-tickets, /whips per ticket"]
    Q2 -->|"very foggy"| WAY["/wayfinder into a map, then main flow"]
    Q2 -->|"real work, no playbook"| FIG["/figure-it-out: design, approve, run"]
    ONE --> PR["Draft PR, landing follows risk tier"]
    IDEA --> PR
    WAY --> PR
    FIG --> PR
```

## 1. Tiny fix one-shot

When: one line, a symlink, a config flag, a copy typo.

```mermaid
flowchart LR
    T["Fix in"] --> W["/whips or direct"] --> V["Verify on the same surface"] --> P["Draft PR, low-risk lands"]
```

No interview: it costs more than the work.

Example: dead `public/storage` symlink. Type into `/whips`: "re-link public/storage to storage/app/public, verify with ls -l". One low-risk PR, lands directly.

## 2. Idea to ship (main flow)

When: an idea to build within one session or a few tickets.

```mermaid
flowchart TD
    D["/discuss-with-docs"] --> Q{"Runnable answer needed?"}
    Q -->|yes| P["/prototype, carry the answer as a note"]
    Q -->|no| S["/to-spec"]
    P --> S
    S --> T["/to-tickets"] --> W["/whips per ticket, fresh context between"]
    W --> B["/babysit to green"] --> R["/ready-check: verdict + risk label"] --> M["You merge per plan"]
```

One unbroken window for discuss through tickets; each whips run starts fresh.

Example: "skeleton loading on the Menu page". `/discuss-with-docs` decides one reusable Skeleton component (not one per page), `/to-spec`, `/to-tickets` (3 tickets: component, use in Menu, e2e proof), `/whips` per ticket.

## 3. Foggy to map

When: greenfield or a giant feature with no visible path.

```mermaid
flowchart TD
    D["/discuss-with-docs"] --> Q{"Planning out of hand?"}
    Q -->|"not yet"| D
    Q -->|yes| W["/wayfinder into a map: 'turn this into a map'"]
    W --> S["/to-spec collapses the map"] --> T["/to-tickets"] --> W2["/whips per ticket"]
```

Never start with wayfinder: a map and tickets you turn out not to need are self-made garbage.

Example: "migrate media uploads to S3". Start `/discuss-with-docs`; planning sprawls into cost, rollback, seeders, so type "`/wayfinder` let's turn this into a map" → map of decision tickets → `/to-spec` collapses the map → tickets → whips.

## 4. Overnight unattended

When: sleep while the queue resolves itself.

```mermaid
flowchart TD
    T["/triage: ripen issues"] --> N["/nightshift: queue runs itself"]
    N --> M["Morning: /ketchup"]
    M --> R["/ready-check"] --> G["You merge the low batch, review high"]
```

Alternative for one long task: `/whips` autonomous-run with predicate + budget, not a queue.

Example: 5 `ready-for-agent` issues → `/nightshift` before sleep → morning `/ketchup` ("2 action items: merge low batch, review Seeder high") → `/ready-check` → merge the low batch, review high.

## 5. UI change with proof

When: interface changes, migrations that must stay pixel-identical. Example: promo modal copy must match the PNG verbatim. `/whips` ui, screenshot @740px crop native 1x, compare against modal-promo.png, PR before/after pair; full migrations use visual-parity (baseline first, zero diff to pass).

```mermaid
flowchart TD
    P["/prototype variants"] --> B["/break: stress on a throwaway page"] --> W["/whips ui or feature"]
    W --> Q{"Migration must match?"}
    Q -->|yes| V["visual-parity: baseline first, zero diff to pass"]
    Q -->|no| R["Record: agent-browser record"]
    V --> R
    R --> L["ui-recording-timeline: trim + timeline page"] --> PR["PR: stills + video + timeline"]
```

## 6. Bug with browser proof

When: defects that need proof by running, not by writing.

```mermaid
flowchart TD
    W["/whips bug: reproduce, diagnose, blast-radius ladder, tdd"] --> R["Record the flow on the same surface"]
    R --> L["Timeline when the video runs long"] --> PR["PR: before/after + running proof"]
```

A writeup that sounds right is worthless without the run.

Example: BUG-02 upload stuck at 100%. `/whips` bug (repro in /admin, root cause in middleware, regression test), record the 151-second flow, `trim` to the upload-save-reload scenes, timeline page, PR before/after + video + timeline.

## 7. Perf number to PR

When: a slow path with a number to defend.

```mermaid
flowchart TD
    P["perf-issue: baseline, cheapest mantra first"] --> Q{"Target met?"}
    Q -->|yes| PR["PR: before, after, delta + artifact"]
    Q -->|"needs iterations"| H["hillclimb: one metric, frozen harness, keep/revert"]
    H --> PR
```

A number without limiter, run count, and spread is not evidence (rule 19).

Example: menu N+1 query, p95 2.1s, target under 500ms. `perf-issue` (baseline + "do it less" mantra: eager load); not enough, so `hillclimb` (p95 metric, frozen median-of-7 harness, 6 iterations 2 kept); PR cites numbers + artifact.

## 8. Lost or behind

When: the chat outran you, or one agent message does not land.

- Behind on news: `/ketchup` (everything since your last message + executive summary per action item).
- Confused by one message: `/wait-what` (visual re-pitch + plain sentences).
- Both run mid-conversation inside other skills.

Example: morning after a 5-issue nightshift, `/ketchup` answers "2 action items: merge low batch (link), review Seeder high (summary + recommendation)". One confusing message mid-flow, `/wait-what` re-pitches it visually.

## 9. Close the loop

When: session over, the environment must be better than before it started.

```mermaid
flowchart TD
    R["/retro: session logs + PR comments"] --> Q{"Mechanical finding?"}
    Q -->|yes| C["Deterministic check or agent-owned tooling"]
    Q -->|"judgement call"| S["CODING_STANDARDS.md or ADR"]
    C --> M["/setup-meta or direct edit (what you approve)"]
    S --> M
```

A repeated manual task becomes a CLI + skill candidate (fewer tokens, fewer hallucinations).

Example: the image-rescue PR was born because proof URLs died with branch deletion. The recurring "rotten proof link" objection became the canonical-main-URL rule + `check-proof-urls.sh` (deterministic check, not prose). PR comments inform the code going forward.

## 10. Deslop the codebase

When: spare moment, hot spots keep hurting, new code copies old shallow shapes.

```mermaid
flowchart TD
    D["/deepen: scan hot spots, HTML report"] --> Q{"Candidate worth it?"}
    Q -->|yes| I["Interview: constraints, seam, surviving tests"]
    I --> W["/whips refactor: behavior pinned, structure changes"]
    Q -->|"needs thinking"| M["/discuss-with-docs, then main flow"]
```

Scope before you scan (YAGNI): recently changed areas first. Unslop cleans prose; deepen cleans structure.

Example: navbar variants scattered across 4 files, same assumption repeated. `/deepen` proposes one deep Navbar module; interview settles the seam; `/whips` refactor extracts it with behavior pinned.
