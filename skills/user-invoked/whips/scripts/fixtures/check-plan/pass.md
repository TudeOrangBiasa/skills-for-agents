# Acme checkout plan

The store gains a cart total with a fixed discount. Shoppers see the final price before they pay. The program enforces one rule. Every PR proves its math on the unit plus the live lane. Two PRs run in order, P1 backend totals then P2 storefront display.

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists, a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

The program runs `skills/user-invoked/whips/playbooks/orchestrate.md`. The agent merges both PRs after a PASS verdict, no operator items.

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program

- [ ] State the protocol and this plan to the operator, then stop. Start execution only on the operator's explicit go.
- [ ] Read these from trunk at program start. Re-read them at every tick.
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/orchestrate.md`
  - [ ] `git show origin/main:skills/verify-acme/SKILL.md`
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/opening-a-pr.md`
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/shipping.md`
  - [ ] `git show origin/main:skills/model-invoked/swarm/SKILL.md`
- [ ] On the operator's go, arm the audit wake on a schedule and never leave the cadence to memory. Use a runner tick with the `runner` skill.
- [ ] Use this tick prompt, verbatim. "Re-read the execution playbook from trunk. Audit the operation against it and fix drift in this tick. Probe every active lane and judge progress by side effects only. Stand down a stuck lane and dispatch its replacement now. Then post a short status message to the operator in chat only when the audit found a tracked change that no earlier status message reported, such as a PR opened, a code-ready head, a round launched or closed, a verdict, a merge, a stuck agent and the action taken, a blocker added or cleared, or a decision only the operator can make. Name every such change and nothing else. Do not repeat a table, the merged list, or an unchanged blocker. If the audit found none, end the turn with no reply text. Either way, log this tick's row in your decision trail. The row names the items reported, or none."
- [ ] On the operator's hold or stand-down, send every owner a zero-writes order at once.

### Spawn owners

- [ ] Spawn one owner per PR with the full lifecycle the execution playbook names. One worktree and one branch per owner, off main, per `playbooks/opening-a-pr.md`.
- [ ] Follow this dependency graph. Start dependent work only after its parent merges, or base it on the parent branch when the execution playbook stacks.
  - [ ] P1 is first and branches from `main`.
  - [ ] P2 after P1.
- [ ] Hold the file boundaries. P1 touches only `src/pricing/**`. P2 touches only `src/storefront/**`.
- [ ] Hold the review gate. None stop at merge-ready with `needs-human` and wait for the human review with screenshots and a video before merge.

### PR mechanics, for every PR

- [ ] Resolve the forge and labels once per `playbooks/opening-a-pr.md`. Record any fallback.
- [ ] Open the PR ready, never draft, per `playbooks/opening-a-pr.md`. A stack child targets its parent branch.
- [ ] Run the repo's lint and typecheck plus the verifier once before the PR-facing push. Push with hooks on, never with `--no-verify`.
- [ ] Run `unslop` on every prose surface, `no-comments` before review, and `code-review` before shipping.
- [ ] Triage every review and bot comment per `references/bot-triage.md`.
- [ ] Rebase onto current trunk before the code-ready report and babysit. Keep that merge base in fix rounds. Rebase again only at merge prep, on a `git merge-tree` conflict with trunk, on a CI failure that comes from a change on trunk, or when a known concurrent change to the same files lands.

### Verdict and merge, for every PR

- [ ] Verify the code-ready head with a fresh subagent that did not write it per `playbooks/ready-check.md`. It runs the head against its base on the real surface through the control skill and returns PASS, PASS+NOTES, or FAIL with evidence. Record the head SHA with the verdict and post the verdict as a PR comment with the `<!-- whips-verdict ... -->` marker. Solo repos read the local verifier, team repos read required checks.
- [ ] Judge every finding by the risk tier per `RISK.md`. A FAIL or INCONCLUSIVE verdict is `risk:high` by rule 9 and waits for the human. A failure on trunk behavior in a lane marked `Regression lane against trunk.` is recorded against trunk and does not block the PR. A new head gets a fresh verdict, except for results that stay valid under the patch-id rule in `playbooks/ready-check.md`.
- [ ] The agent merges each PR per `playbooks/shipping.md` after its PASS verdict, then reads back MERGED.

### Boot recipe, for every live lane

Each live lane runs in its own worktree at the PR head on the local machine. Drive through the project's verification skill.

- [ ] Create the lane worktree and check out the exact head SHA.
- [ ] Launch per `skills/verify-acme/SKILL.md` and wait for `ready on :3000`.
- [ ] Deliver input only through the skill drive commands. Read the health endpoint for diagnostics.
- [ ] Save every screenshot to `/tmp/acme-<pr-id>/lane-<n>/<slug>.png` and return the paths with the report.

## Add cart totals (P1)

**Depends on.** None.

**Files.**

- [ ] Edit `src/pricing/total.ts`.
- [ ] Create `tests/pricing/total.test.ts`.

**Build.**

- [ ] Add `computeTotal` to `src/pricing/total.ts` with a fixed discount rule.

**You see.**

- [ ] `POST /cart/total` returns `{"total": 900}` for a 1000 cart with a 100 discount.

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] `tests/pricing/total.test.ts` gains the discount case. Run `npm test -- total`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes on `review` at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run the checkout happy path at trunk and head. Trunk lacks totals, record that and gate the total line plus the paid state. Save `checkout.png`. Pass when the head shows the total and trunk shows none.
- [ ] Lane 2. Empty cart totals zero. Save `empty.png`. Pass when the endpoint returns zero.
- [ ] Lane 3. Discount larger than the cart floors at zero. Save `floor.png`. Pass when the endpoint returns zero.
- [ ] Lane 4. Two items sum before the discount. Save `sum.png`. Pass when the total equals 1900 for a 2000 cart.
- [ ] Lane 5. Invalid cart id returns 404. Save `missing.png`. Pass when the status is 404.
- [ ] Lane 6. Concurrent totals agree. Save `race.png`. Pass when both responses match.
- [ ] Lane 7. Totals persist after restart. Save `restart.png`. Pass when the total survives a relaunch.
- [ ] Lane 8. Currency formats with two decimals. Save `format.png`. Pass when the body shows `9.00`.
- [ ] Lane 9. Slow backend still totals within budget. Save `slow.png`. Pass when the response lands under 500 ms.
- [ ] Lane 10. Log line names the discount. Save `log.png`. Pass when the log shows `discount=100`.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. p95 of `POST /cart/total` at trunk and head.
- [ ] Probe. `scripts/bench-totals.sh`, run at trunk and at the head, interleaved. Both sides must produce the metric.
- [ ] Baseline. Record the trunk p95 first.
- [ ] Rule. Head p95 within 10 percent of trunk, else fail.

**Review gate.** None. P1 is not review-gated.

**Merge.**

- [ ] Ready-check verdict of PASS or PASS+NOTES at the exact head SHA.
- [ ] Patch-id unchanged since the verdict.
- [ ] Rebased onto current trunk after the verdict where the mechanics demand it.
- [ ] Merge per `playbooks/shipping.md` right after the verdict.

## Show the total on the storefront (P2)

**Depends on.** P1.

**Files.**

- [ ] Edit `src/storefront/cart.ts`.

**Build.**

- [ ] Render the total line in `src/storefront/cart.ts` from the P1 endpoint.

**You see.**

- [ ] The cart page shows `Total 9.00` under the item list.

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] `tests/storefront/cart.test.ts` gains the total line case. Run `npm test -- cart`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes on `review` at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run the cart page at trunk and head. Trunk lacks the total line, record that and gate the new line plus the checkout button state. Save `cart.png`. Pass when the head shows the line and trunk shows none.
- [ ] Lane 2. Empty cart shows zero. Save `empty.png`. Pass when the line reads zero.
- [ ] Lane 3. Totals update on quantity change. Save `qty.png`. Pass when the line moves with the count.
- [ ] Lane 4. Discount row shows below the subtotal. Save `row.png`. Pass when both rows render.
- [ ] Lane 5. Mobile width keeps the line visible. Save `mobile.png`. Pass when no scroll hides it.
- [ ] Lane 6. Reload keeps the total. Save `reload.png`. Pass when the line survives reload.
- [ ] Lane 7. Error state hides the line. Save `error.png`. Pass when a failed fetch shows the error text.
- [ ] Lane 8. Screen reader names the total. Save `a11y.png`. Pass when the label announces.
- [ ] Lane 9. Slow fetch shows a skeleton first. Save `skeleton.png`. Pass when the skeleton precedes the line.
- [ ] Lane 10. Long prices do not overflow. Save `wrap.png`. Pass when the layout holds at 999999.99.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. Time from cart render to total line paint at trunk and head.
- [ ] Probe. `scripts/bench-cart.sh`, run at trunk and at the head, interleaved. Both sides must produce the metric.
- [ ] Baseline. Record the trunk paint time first.
- [ ] Rule. Head within 100 ms of trunk, else fail.

**Review gate.** P2 changes the cart page, so the human reviews before merge.

- [ ] Copy lane 1 screenshots into `shots/p2-review-cart.png`.
- [ ] Record a 30 to 60 second video of the change on a lane worktree. Save it as `shots/p2-review.mp4`.
- [ ] Stop at merge-ready. Label `needs-human` with a `<!-- needs-human reason=review-gate -->` marker comment, post the screenshots and the video, and wait for the human.

**Merge.**

- [ ] Ready-check verdict of PASS or PASS+NOTES at the exact head SHA.
- [ ] Patch-id unchanged since the verdict.
- [ ] Human review done on the gate before the merge.
- [ ] Hand the merge-ready PR to the operator after the human clicks.

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Reply to the operator with the report the execution playbook names.

## Appendix A. Prototype evidence

The discount rounding question ran on branch `proto/discount-round`, SHA `abc1234`, with the rounding table in the branch README. No question stays unproven.

## Appendix B. Alternatives rejected

Percent discount lost to the fixed rule because the ticket names a fixed 100 cut.

## Appendix C. Risks

P2 layout risk is the total line wrapping on narrow screens. The owner watches lane 5.

## Appendix D. Links and reading list

Read `src/pricing/README.md` before P1. P2 gets `interrogate`. The trail follows `show-me-your-work`.
