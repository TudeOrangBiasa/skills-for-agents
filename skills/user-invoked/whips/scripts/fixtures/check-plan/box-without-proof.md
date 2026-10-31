# Box proof plan

A short plan where the live lanes and the perf boxes forget their proof.

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
- [ ] On the operator's go, arm the audit wake on a schedule and never leave the cadence to memory. Use a ship-runner tick with the `ship-runner` skill.
- [ ] Use this tick prompt, verbatim. "Post a short status message naming every tracked change, or end with no reply text."
- [ ] On the operator's hold or stand-down, send every owner a zero-writes order at once.

### Spawn owners

- [ ] Spawn one owner per PR. One worktree and one branch per owner, off main, per `playbooks/opening-a-pr.md`.
- [ ] Follow this dependency graph. P1 branches from `main`.
- [ ] Hold the file boundaries. P1 touches only `src/**`.
- [ ] Hold the review gate. None are gated.

### PR mechanics, for every PR

- [ ] Resolve the forge and labels once per `playbooks/opening-a-pr.md`. Record any fallback.
- [ ] Open the PR ready, never draft, per `playbooks/opening-a-pr.md`. A stack child targets its parent branch.
- [ ] Run the repo's lint and typecheck plus the verifier once before the PR-facing push. Push with hooks on, never with `--no-verify`.
- [ ] Run `review-unslop` on every prose surface, `review-nocomment` before review, and `review-code` before shipping.
- [ ] Triage every review and bot comment per `references/bot-triage.md`.
- [ ] Rebase onto current trunk before the code-ready report and babysit. Keep that merge base in fix rounds.

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

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run the happy path at trunk and head. Pass when the head logs `ran`.
- [ ] Lane 2. Second pass. Save `two.png`.
- [ ] Click around the page for a while and confirm it feels right.
- [ ] Lane 4. Fourth pass. Save `four.png`. Pass when the log repeats.
- [ ] Lane 5. Fifth pass. Save `five.png`. Pass when the log repeats.
- [ ] Lane 6. Sixth pass. Save `six.png`. Pass when the log repeats.
- [ ] Lane 7. Seventh pass. Save `seven.png`. Pass when the log repeats.
- [ ] Lane 8. Eighth pass. Save `eight.png`. Pass when the log repeats.
- [ ] Lane 9. Ninth pass. Save `nine.png`. Pass when the log repeats.
- [ ] Lane 10. Tenth pass. Save `ten.png`. Pass when the log repeats.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. p95 of the run at trunk and head.
- [ ] Check that it feels fast enough.
- [ ] Baseline. Record the trunk p95 first.
- [ ] Rule. Head within 10 percent of trunk, else fail.

**Review gate.** None. P1 is not review-gated.

**Merge.**

- [ ] Ready-check verdict of PASS at the exact head SHA.
- [ ] Merge per `playbooks/shipping.md` right after the verdict.

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Reply to the operator with the report the execution playbook names.

## Appendix A. Prototype evidence

No open questions needed a craft-proto run.
