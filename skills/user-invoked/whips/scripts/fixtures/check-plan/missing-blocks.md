# Broken intro plan

This intro runs long on purpose so the intro length rule fires. Line three. Line four. Line five. Line six. Line seven. Line eight. Line nine. Line ten. Line eleven. Line twelve.

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists, a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

The program runs `skills/user-invoked/whips/playbooks/orchestrate.md`. The agent merges the PR after a PASS verdict.

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program

- [ ] State the protocol and this plan to the operator, then stop. Start execution only on the operator's explicit go.
- [ ] Read these from trunk at program start. Re-read them at every tick.
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/orchestrate.md`
  - [ ] `git show origin/main:skills/verify-acme/SKILL.md`
- [ ] On the operator's go, arm the audit wake on a schedule and never leave the cadence to memory. Use a runner tick with the `runner` skill.
- [ ] Use this tick prompt, verbatim. "Post a short status message naming every tracked change, or end with no reply text."
- [ ] On the operator's hold or stand-down, send every owner a zero-writes order at once.

### Spawn owners

- [ ] Spawn one owner per PR. One worktree and one branch per owner, off main, per `playbooks/opening-a-pr.md`.
- [ ] Follow this dependency graph. P1 branches from `main`.
- [ ] Hold the file boundaries. P1 touches only `src/**`.
- [ ] Hold the review gate. None are gated.

### Verdict and merge, for every PR

- [ ] Verify the code-ready head with a fresh subagent per `playbooks/ready-check.md`. It returns PASS, PASS+NOTES, or FAIL with evidence and the verdict carries the head SHA.
- [ ] Judge every finding by the risk tier per `RISK.md`. A new head gets a fresh verdict under the patch-id rule.
- [ ] The agent merges per `playbooks/shipping.md` after its PASS verdict, then reads back MERGED.

### Boot recipe, for every live lane

Each live lane runs in its own worktree at the PR head on the local machine. Drive through the project's verification skill.

- [ ] Create the lane worktree and check out the exact head SHA.
- [ ] Launch per the skill and wait for its ready signal.
- [ ] Save every screenshot to `/tmp/acme-p1/lane-<n>/<slug>.png` and return the paths with the report.

## Add one thing (P1)

**Depends on.** None.

**Files.**

- [ ] Edit `src/one.ts`.

**Build.**

- [ ] Add `run` to `src/one.ts`.

**You see.**

- [ ] The log shows `ran`.

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] `tests/one.test.ts` gains the happy path. Run `npm test -- one`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes on `review` at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run the happy path at trunk and head. Save `one.png`. Pass when the head logs `ran`.
- [ ] Lane 2. Second pass. Save `two.png`. Pass when the log repeats.

**Review gate.** None. P1 is not review-gated.

**Merge.**

- [ ] Ready-check verdict of PASS at the exact head SHA.
- [ ] Merge per `playbooks/shipping.md` right after the verdict.

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Reply to the operator with the report the execution playbook names.
