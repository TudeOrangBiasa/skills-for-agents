# VIBE-MAPPING (normative, OMP only)

Read this file first on every `/whips` run under OMP vibe mode, and follow it for the whole run. On other harnesses (plain background agents), apply the same shape: director verifies, workers prove, briefs stay self-contained.

## M1. Director toolset and vow

The director uses `read`, an optional parent-owned `todo`, plus `vibe_spawn`, `vibe_send`, `vibe_wait`, `vibe_kill`, `vibe_list`. The vow: never edit, run, grep, or build while workers are out. Verify with `read`, review the diff, write your own summary. Keep todos in-thread unless the parent owns one; never stall a run opening a todo list.

## M2. Brief is refuse-to-spawn

Every spawn carries GOAL, SCOPE, CONTEXT, ACCEPTANCE, VERIFY, TIMEBOX, FORBIDDEN, REPORT, STANDING (see `/whips` section 4). Workers never see director conversation, so a field missing means the unit is not scoped yet. Fill it or do not spawn. Paste standing orders verbatim into every spawn and every resume, because directives decay across resumes. Vibe workers are keep-alive by design, so follow-up turns on the same worker are preferred inside one unit; fresh spawns are for new units and post-failure fix rounds.

## M3. vibe_send truth table, no guarantee

Streaming worker plus `vibe_send` means steered at its next step. Non-streaming mid-turn means queued; queued messages join into one automatic next turn at settlement. Idle or parked means a new background turn starts. None of these guarantees a directive lands before the worker finishes, so never rely on mid-turn steering. Steer inline in briefs plus standing orders and at drain points.

## M4. Advisor severity table

The OMP advisor injects advisories with weigh-dont-obey guidance; it never approves actions or mutates state. `nit` lands at the next boundary. `concern` or `blocker` interrupts a streaming turn and aborts in-flight tools. `preserve` shows a card with no wake (late terminal answers, plan mode, immunity cooldowns). Treat a late `concern` as a card to read at the next drain, never as a reason to redo finished work silently. Only a `blocker` reopens a settled unit, through a fresh agent with a rewritten brief.

## M5. Drain discipline

`vibe_wait` only when blocked (default 30s, re-issue on timeout). Drain in batches: classify every completion (landed, needs-verify, failed, zombie, noise), then spawn the next wave in one message. Never deep-review inline; a completion that needs review becomes a verifier unit. Arrivals during a drain wait for the next one.

## M6. Hooks evidence gate recipe (consumer side)

Documented here, installed in the consumer repo under `.omp/hooks`, never committed into this repo. `tool_call` pre-exec blocks a report-done or submit whose REPORT lacks proof pointers (commit SHAs, verify output, screenshot or video paths). `agent_end` or `turn_end` plus `tool_result` demands the same proof before the turn closes. Hooks fail closed: a hook error blocks, it never waves through.

## M7. Worker limits (do not promise these)

Workers cannot use custom agents, have no per-worker cwd or worktree isolation, and vibe mode is mutually exclusive with plan and goal modes. Keep one writer per branch, serialize shared writes, and never design a playbook step that assumes the missing pieces.
