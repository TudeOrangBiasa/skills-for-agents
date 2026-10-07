# Test plan: /whips vibe pass (copy paste edition)

Workspace: `/home/todayz/orca/projects/whips-test/`. Source of truth for the skill stays in the skills-for-agents repo. Do not fix the skill in the test workspace.

## Step 0. Setup

1. Open the workspace in OMP.
2. Confirm `.agents/skills/whips/` shows SKILL.md, VIBE-MAPPING.md, 6 playbooks, CREDITS.md.
3. Confirm `python3 --version` works where workers will run.

## Step 1. Launch (paste after `/vibe`)

```text
/vibe Fix the bug in demo/ per demo/TASK.md. Read .agents/skills/whips/VIBE-MAPPING.md first and follow it for the whole run, then run .agents/skills/whips/playbooks/bug.md step by step. Done means: repro fails before and passes after on all three TASK.md cases, root cause named, one minimal fix, TASK.md untouched. Every worker gets a self-contained brief (GOAL, SCOPE, CONTEXT, ACCEPTANCE, VERIFY, TIMEBOX, FORBIDDEN, REPORT, STANDING). Verify with read, never edit or run yourself. No PR to open here: close with a pr-shaped body plus before/after proof in chat.
```

If the director edits code itself, stop immediately and report M1 FAIL.

## Step 2. Standing orders (paste verbatim if the director spawns cloud workers)

```text
STANDING: one writer on demo/price.py. No rebase, no force push, no fixes outside demo/. REPORT carries status, head SHA, verdict, exact verify commands with output, deviations, follow-ups. Evidence or it did not happen.
```

## Step 3. Observe (hands off)

- Spot check at least one brief for all 9 fields.
- Note every `vibe_send` and whether it landed as steered, queued, or new turn.
- Note every advisor card (nit, concern, blocker, preserve) plus what the director did.
- `vibe_wait` only when blocked. Do not steer the director yourself; your interference voids the test.

## Step 4. Drain and closeout

- Completions get classified (landed, needs-verify, failed, zombie, noise) before the next wave.
- Closeout must carry: repro output before and after on all 3 TASK.md cases, named root cause, head SHA or diff, pr-shaped body. Green CI alone, or a bare done, fails the evidence gate.

## Step 5. Report back (paste filled in)

```text
Verdict table:
- M1 director vow: PASS/FAIL + evidence (which tools the director used)
- M2 full briefs: PASS/FAIL + evidence (paste one brief or its gaps)
- M3 no mid-turn reliance: PASS/FAIL + evidence (steer attempts and modes)
- M4 advisor handling: PASS/FAIL + evidence (cards seen and responses)
- M5 drains: PASS/FAIL + evidence (how completions were classified)
- Evidence gate: PASS/FAIL + evidence (proof pointers in closeout)
- Bug actually fixed (all 3 TASK.md cases): PASS/FAIL + evidence (repro output)
Breakage worth fixing in the skill: <list or none>
```

## Abort rules

- Director edits, runs, or greps while workers are out: stop, M1 FAIL.
- Worker idle over 5 minutes with no drain progress: note it, `vibe_list`, continue once, then stop if stuck.
- Anything surprising: keep the transcript, stop, report.
