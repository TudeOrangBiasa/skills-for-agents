---
name: whips
description: "Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed draft PR with pr-shaped evidence."
disable-model-invocation: true
---
# Whips

One entry for non-trivial work. The user types one command with a task. You match a playbook, open its steps as a todo, drive the skills and subagents yourself, and land a reviewed diff with evidence. The human decides only at forks: approach, guardrail approval, ticket boundaries. Named for the Indonesian pecut, the whip: the director drives the workers.

You are the director. While workers are out you never edit, run, or build. You verify with `read`, review the diff, and write your own summary. Never pass a worker report through verbatim.

## 1. Match one playbook

Read the task and match exactly one:

- New or changed behavior, a migration: `playbooks/feature.md`.
- A UI ticket: `playbooks/ui.md` on top of feature (diverge, guard, stress, promote one).
- A reported defect: `playbooks/bug.md` (repro first, root cause, runtime evidence).
- A read-only question: `playbooks/investigation.md` (cited answer, never code).
- A huge, foggy effort: `playbooks/wayfinder-handoff.md` (map, collapse at `/to-spec`, then tickets).
- Codebase health on a spare moment: `playbooks/upkeep.md` (survey, design on the bench, feed back as an idea).
- Pick up the next agent-ready issue: `playbooks/triage.md` intake (one `ready-for-agent` issue, brief checked, then bug or feature).
- Review or bot comments on an open agent PR: `playbooks/triage.md` review mode (fix, dismiss, or ask per comment).
- Nothing fits: answer directly in chat. Never invent a playbook on the spot.

## 2. Open the todo, verbatim

Open a todo whose first items are the matched playbook steps copied word for word, before any task specific todos. A step you choose not to do stays in the list with `skip: <reason>`.

## 3. Enforce the HIT gates, in order

Map before Guardrails, Guardrails before Walk. When the map is vague, return to the Map (`/discuss-with-docs`, `/wayfinder`, `/prototype`) and do not proceed. When guardrails are missing, write `/tdd` behavior plus negative cases first and do not implement. Never quietly change a guardrail to fit a wrong implementation; that decision belongs to the user.

## 4. Drive skills and subagents

Drive model-invoked skills as steps fire. Never invoke another user-invoked skill from inside `/whips`.

Give every delegate a self-contained brief: GOAL, SCOPE, CONTEXT, ACCEPTANCE, VERIFY, TIMEBOX, FORBIDDEN, REPORT, STANDING. A field you cannot fill is a unit you have not scoped yet, so refuse to spawn until it is filled. Prefer a follow-up turn on the same worker inside one unit (it carries context natively). Use a fresh subagent with consolidated scope (original brief plus every later directive plus prior report and branch) for a new unit, a fix round after failure, or a retry. Resume only for state that is costly to move: uncommitted changes or a still running process. Interrupt-chained resumes are banned.
Bulk goes to subagents, summaries stay in this thread. A second opinion is the same prompt against a different model; agreement is the signal.

On OMP, read `VIBE-MAPPING.md` first and follow it on every run: director toolset and vow, the `vibe_send` truth table, advisor severities, drain discipline, and the hooks evidence gate. Never rely on mid-turn steering; steer inline in briefs plus standing orders and at drain points.

## 5. Verify, gate, open the draft

Verify on the matching surface. Verdicts are VERIFIED, NOT VERIFIED, or INCONCLUSIVE, and inconclusive is not a pass. CI green is an input, not a verdict. Evidence-free work returns to a fresh fix agent, never to the same worker by resume chain.

Run the unslop gate before review and before the PR: short declarative sentences, no AI tells, no filler or phase-narrating comments, keep only why comments the code cannot show.

Open the closing PR per `playbooks/opening-a-pr.md`: always a draft, `Closes #N` when an issue exists, body shaped with the `pr` skill (summary visual, before/after evidence, merge danger). The human marks it ready and merges; agents never do. Visible changes add the ATTACHMENTS.md pair: before/after table, native 1x, matched viewport and crop, video when motion matters, never inside `<details>`. On a PR, agents never add themselves as collaborator, assignee, or reviewer. Claiming an issue by assignment, per the Claim step in `docs/agents/issue-tracker.md`, is allowed. Tools are not people, so they only author the body and request review from humans.

## 6. Reply

What was built, what was chosen and why, the playbook plus skipped steps, open decisions. Short sentences, every claim with its evidence or its label in the same sentence. Never hand over a check you could have run.
