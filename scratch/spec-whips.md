# Spec: /whips (SFA playbook router, poteto style, vibe compatible)

Status: approved map, ready to build. Plan: `scratch/plan-sfa-stack.md`.

## 1. Goal

One user invoked skill `/whips` that routes all HIT work without per skill micromanagement. The user types one command with a task. The skill matches a playbook, opens a todo with the playbook steps verbatim, drives model invoked skills plus subagents itself, and lands a reviewed diff plus a pr shaped PR body with visual proof. The human decides only at forks (approach, guardrail approval, ticket boundaries).

Done predicate: a fresh builder who has never seen this repo can read this spec plus the plan and produce `skills/user-invoked/whips/` passing every acceptance check in section 10 with zero follow up questions.

## 2. Non-goals (deferred, not v1)

Program scale `orchestrate` and `autopilot` coordination, `automate-me` personal mode mining, the committed automation pack (benny equivalent ships after the skill proves itself), per role model mapping (extends `/setup-meta` later), platform specific runners.

## 3. Skill identity and layout

- Name: `/whips` (from Indonesian pecut, whip, the director drives the workers).
- Folder: `skills/user-invoked/whips/`.
- Frontmatter in SKILL.md: `name: whips`, description naming the router job, `disable-model-invocation: true`.
- `agents/openai.yaml`: `policy.allow_implicit_invocation: false` (same as every user invoked skill in this repo).
- Files v1:
  - `skills/user-invoked/whips/SKILL.md` (router, matches playbook, owns the loop)
  - `skills/user-invoked/whips/VIBE-MAPPING.md` (normative OMP rules, section 6)
  - `skills/user-invoked/whips/playbooks/feature.md` (section 5A)
  - `skills/user-invoked/whips/playbooks/bug.md` (section 5B)
  - `skills/user-invoked/whips/CREDITS.md` (credit Poteto pstack plus OMP vibe and advisor docs)
  - `skills/user-invoked/whips/agents/openai.yaml`
- Edits v1:
  - `skills/user-invoked/guide/SKILL.md` (router mentions `/whips` as the default entry for non trivial work)
  - top `README.md` (one skill row with link, install wording verbatim from `.agents/install-block.md`)
  - `skills/user-invoked/README.md` (one skill row with link)
  - `.changeset/<name>.md` (only if repo convention requires one per user invoked skill change)

## 4. Router behavior (normative)

- R1: On invoke, read the task and match exactly one playbook (feature, bug, or none fits). No match means answer directly in chat, never invent a playbook.
- R2: Open a todo whose first items are the matched playbook steps copied verbatim. A skipped step stays with `skip: <reason>`.
- R3: Enforce HIT gates in order. Map vague means return to Map (`/discuss-with-docs`, `/wayfinder`, `/prototype`) and do not proceed. Guardrails missing means write `/tdd` behavior plus negative cases first and do not implement. Never quietly change a guardrail to fit a wrong implementation.
- R4: Drive model invoked skills as steps fire. A user invoked skill is never invoked from inside `/whips` (repo rule: user invoked may invoke model invoked only).
- R5: The director never edits, runs, or builds while workers are out. Verify with `read`, review the diff, write its own summary. Never pass through a worker report verbatim.
- R6: Replies follow the unslop gate (section 8) and frame impact for consumer first, maintainer second.

## 5. Playbooks v1

### 5A. feature.md (new or changed behavior)

1. `how` over the affected subsystem (parallel explorers plus synthesizer for anything spanning files, single pass for narrow questions).
2. Name the data shape first per `codebase-design` vocabulary before any logic sketch.
3. `architect` sketch when code crosses a function boundary: at least two structurally distinct candidates, pick on interface depth, record the synthesis decision.
4. Write the throughput checkpoint as todo items: blocking first steps, independent workstreams, shared mutable state (default split, serialize only for real invariants), smallest safe decomposition (if one worker is best, name why).
5. Delegate implementation to a fresh subagent with a brief per section 7. Mandatory review separation: no standing by on a nested agent.
6. Verify on the matching surface per section 9. Inconclusive is not a pass.
7. Rebase into small ordered commits, one verifiable unit per commit.
8. Contested design means `interrogate` before shipping (multi model when available, else `/code-review` two axis).
9. Unslop gate, then PR body per section 8.

### 5B. bug.md (reported defect)

1. Reproduce first on the same surface the report used. No repro means no fix, only a diagnosis note.
2. Trace to root cause per `/diagnose` (tight feedback loop that already goes red on this bug). Ask why until the cause, not the symptom.
3. `blast-radius`: name the one safety fact the fix depends on and prove it by running code.
4. `tdd` when the test path is cheap: failing test first, then the fix, then the regression stays.
5. Delegate or implement per the feature checkpoint when the fix spans workstreams, else directly.
6. Verify the original repro plus the new test on the real artifact.
7. Unslop gate, then PR body per section 8 with before and after proof of the fixed behavior.

## 6. VIBE-MAPPING.md normative content

The file MUST contain, in this order:

- M1: Director toolset and vow (read plus `vibe_spawn`, `vibe_send`, `vibe_wait`, `vibe_kill`, `vibe_list`; never edit, run, grep, or build while workers are out).
- M2: Brief schema from section 7, stated as refuse to spawn conditions (a field missing means the unit is not scoped yet).
- M3: `vibe_send` truth table (streaming means steered at next step, non streaming means queued and joined, idle means new turn) plus the no guarantee clause: never rely on mid turn steering.
- M4: Advisor severity table (nit lands at boundary, concern or blocker interrupts streaming turns, preserve shows a card with no wake) plus cooldown and plan mode notes.
- M5: Drain discipline (`vibe_wait` only when blocked, default 30s re issue on timeout, arrivals during a drain wait for the next one, never deep review inline).
- M6: Hooks evidence gate recipe for the consumer repo (`.omp/hooks`): `tool_call` pre-exec blocks report-done or submit without proof pointers, `agent_end` or `turn_end` plus `tool_result` demands proof, fail closed. Marked consumer side: documented here, installed there, never committed into this repo.
- M7: Worker limits carried from OMP issues (no custom agents on workers, no per worker cwd or worktree isolation, mutual exclusion with plan and goal modes) so playbooks never promise them.

## 7. Brief schema (refuse to spawn when a field is empty)

GOAL (one sentence, executable by a stranger with no chat access). SCOPE (paths the unit may write, paths it may not, exclusive branch or worktree). CONTEXT (file pointers plus upstream reports pasted in full when the unit depends on them, never inlined dumps). ACCEPTANCE (checkable criteria, one per line). VERIFY (exact commands plus known gotchas). TIMEBOX (rough cap, on expiry return partial findings and stop). FORBIDDEN (no rebase, no force push, no fixes outside scope, plus unit bans). REPORT (status, branch, head SHA, verdict, what was actually run, deviations, follow ups). STANDING (repo standing orders pasted verbatim on OMP cloud spawns).

## 8. Gates

- Unslop gate: short declarative sentences, no AI tells, no filler or phase narrating comments, keep only why comments the code cannot show. Applied to replies, PR bodies, decision logs, and agent facing prose before review and before PR.
- PR body: this repo `pr` skill shape (summary visual, before and after evidence, merge danger). Visible changes add the ATTACHMENTS.md pair (table, native 1x, matched viewport and crop, video when motion matters, never in `<details>`). Agents never add themselves as collaborator, assignee, or reviewer. Tools are not people.
- Evidence verdicts: VERIFIED, NOT VERIFIED, INCONCLUSIVE. Inconclusive is not a pass. CI green is an input, not a verdict. Evidence free PRs return to a fresh fix agent, never to the same worker by resume chain.

## 9. Subagent discipline

Fresh subagent per round with consolidated scope (original brief plus every later directive plus prior report and branch). Resume only for state that is costly to move (uncommitted changes, running dev server or watcher). Interrupt chained resumes are banned. Bulk goes to subagents, summaries stay in the parent thread. Second opinion means the same prompt against a different model, and agreement is the signal.

## 10. Acceptance checks (all MUST pass)

- A1: Folder, frontmatter, and `agents/openai.yaml` flags match section 3 exactly.
- A2: SKILL.md enforces R1 through R6 with no em dashes anywhere in the new prose.
- A3: Both playbooks contain every step from section 5 in order, each step naming its owning skill.
- A4: VIBE-MAPPING.md contains M1 through M7 in order.
- A5: CREDITS.md credits Poteto pstack and OMP docs. Guide, both READMEs, and changeset (if required) are updated with the skill linked.
- A6: Dry run on one real small task in this repo produces a diff plus PR body with proof pointers and zero unresolved TODOs.

## 11. Build order

SKILL.md skeleton plus frontmatter first, then VIBE-MAPPING.md, then feature.md, then bug.md, then CREDITS.md plus yaml, then guide plus README edits, then dry run.
