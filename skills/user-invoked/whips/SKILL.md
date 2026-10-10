---
name: whips
description: "Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed draft PR with pr-shaped evidence."
disable-model-invocation: true
---
# Whips

One entry for non-trivial work. The user types one command with a task. You match a playbook, open its steps as a todo, drive the skills and subagents yourself, and land a reviewed diff with evidence. The human decides only at forks and at the pause list in section 5. Named for the Indonesian pecut, the whip: the director drives the workers.

You are the director. While workers are out you never edit, run, or build. You verify with `read`, review the diff, and write your own summary. Never pass a worker report through verbatim.

## 1. Match one playbook

Read the task and match exactly one row. First match wins.

| The task | Playbook |
| --- | --- |
| Pick up the next agent-ready issue | `playbooks/triage.md` intake |
| Review or bot comments on an open agent PR | `playbooks/triage.md` review mode |
| Check on a PR or stack, get it green, anything outstanding | `playbooks/babysit.md` |
| Is this ready, what do I merge first, give me a merge plan | `playbooks/ready-check.md` |
| A reported defect | `playbooks/bug.md` |
| A fork running code can settle: which layout, flow, query, or approach | `playbooks/prototype.md` |
| A UI ticket | `playbooks/ui.md`, on top of feature |
| Structure changes, behavior must not: rename, extract, dedupe, move | `playbooks/refactor.md` |
| New or changed behavior, a migration | `playbooks/feature.md` |
| A read-only question | `playbooks/investigation.md` |
| A huge, foggy effort | `playbooks/wayfinder-handoff.md` |
| Codebase health on a spare moment | `playbooks/upkeep.md` |
| Every playbook that changes code ends here | `playbooks/opening-a-pr.md` |

Nothing fits: answer directly in chat. Never invent a playbook on the spot.

## 2. Open the todo, verbatim

Open a todo whose first items are the matched playbook steps copied word for word, before any task specific todos. A step you choose not to do stays in the list with `skip: <reason>`.

## 3. Triggers that fire in every playbook

Each row fires whenever its condition holds, on top of the playbook steps. Call the Skill tool with the named skill.

| When | Skill |
| --- | --- |
| Any code | name the data shape first: "codebase-design" |
| Code crosses a function boundary | "codebase-design", design it twice |
| A defect, a failing test, a slow path | "diagnose" |
| A behavior to build or pin | "tdd" |
| Domain terms change or a hard-to-reverse decision lands | "domain-modeling" |
| A question running code can answer | "prototype", instead of asking the user |
| Outside docs or API facts | "research" |
| Contested design, or before any PR | "code-review", plus the same prompt to a second model when the harness offers one |
| A merge or rebase conflict | "merge-fix" |
| A step only a human can do (secrets, dashboards) | "wizard" |
| A PR body | "pr" |

Every prose surface (reply, PR body, commit message, tracker comment) passes the unslop gate: short declarative sentences, no AI tells, no filler or phase-narrating comments, keep only why comments the code cannot show.

A step that names a user-invoked skill (`/wayfinder`, `/to-spec`, `/to-tickets`, `/deepen`, `/break`, `/discuss-with-docs`) is a human gate: tell the user to run it and wait at that step. No skill can fire a user-invoked one, `/whips` included.

[PRINCIPLES.md](PRINCIPLES.md) holds the principles behind these triggers. Read it once per run before the first design decision.

## 4. Enforce the HIT gates, in order

Map before Guardrails, Guardrails before Walk. When the map is vague, return to the Map and do not proceed: call the Skill tool with "prototype" when running code can answer the question, else tell the user to run `/discuss-with-docs` or `/wayfinder`. When guardrails are missing, call the Skill tool with "tdd" and write behavior plus negative cases first, and do not implement. Never quietly change a guardrail to fit a wrong implementation; that decision belongs to the user.

## 5. Autonomy

Reversible work proceeds without asking: branches, worktrees, commits, pushing your own branches, draft PRs, rebasing your own stack, tracker labels, comments that carry the AI disclaimer, and review fixes classified `fix`.

Always pause for the human, and keep building everything else meanwhile:

- Merging, marking a PR ready, enabling auto-merge.
- Force-pushing a branch someone else works on.
- Deploying, deleting data, touching secrets or production config.
- Closing an issue, messaging anyone outside the repo.
- A review comment classified `ask`, and a product or preference call no experiment can settle.

A fork that running code can settle is not a pause: settle it with "prototype" and report the result.

## 6. Drive skills and subagents

Give every delegate a self-contained brief: GOAL, SCOPE, CONTEXT, ACCEPTANCE, VERIFY, TIMEBOX, FORBIDDEN, REPORT, STANDING. A field you cannot fill is a unit you have not scoped yet, so refuse to spawn until it is filled. Prefer a follow-up turn on the same worker inside one unit (it carries context natively). Use a fresh subagent with consolidated scope (original brief plus every later directive plus prior report and branch) for a new unit, a fix round after failure, or a retry. Resume only for state that is costly to move: uncommitted changes or a still running process. Interrupt-chained resumes are banned.
Bulk goes to subagents, summaries stay in this thread. A second opinion is the same prompt against a different model; agreement is the signal.

Pick each subagent's model by role from `docs/agents/models.md` when the repo has it (roles `code`, `hard-code`, `judgment`, `review`). A missing file or a missing role means the subagent runs on your own model. Never name a model or provider yourself.

On OMP, read `VIBE-MAPPING.md` first and follow it on every run: director toolset and vow, the `vibe_send` truth table, advisor severities, drain discipline, and the hooks evidence gate. Never rely on mid-turn steering; steer inline in briefs plus standing orders and at drain points.

## 7. Verify, gate, open the draft

Verify on the matching surface. Verdicts are VERIFIED, NOT VERIFIED, or INCONCLUSIVE, and inconclusive is not a pass. CI green is an input, not a verdict. Evidence-free work returns to a fresh fix agent, never to the same worker by resume chain.

Open the closing PR per `playbooks/opening-a-pr.md`: always a draft, one risk label plus a `## Risk` paragraph per [RISK.md](RISK.md), `Closes #N` when an issue exists, body shaped with the `pr` skill (summary visual, before/after evidence, merge danger). The human marks it ready and merges; agents never do. Visible changes add the ATTACHMENTS.md pair: before/after table, native 1x, matched viewport and crop, video when motion matters, never inside `<details>`. On a PR, agents never add themselves as collaborator, assignee, or reviewer. Claiming an issue by assignment, per the Claim step in `docs/agents/issue-tracker.md`, is allowed. Tools are not people, so they only author the body and request review from humans.

## 8. Reply

What was built, what was chosen and why, the playbook plus skipped steps, open decisions. Name each principle that changed a decision and the choice it changed. Add a short "Why this way" in plain words for the key decisions, written for a developer still building experience: what the alternative was and why it lost. Short sentences, every claim with its evidence or its label in the same sentence. Never hand over a check you could have run.
