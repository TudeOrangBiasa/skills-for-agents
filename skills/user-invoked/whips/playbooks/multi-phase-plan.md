# Playbook: multi-phase plan

You own the plan, never the code. The plan is a checklist an owner runs box by box and the operator audits from the evidence. The plan is the deliverable. Do not implement.

1. When the change is one or two files with an obvious approach, skip the plan and route to `playbooks/feature.md`. Say so and stop.
2. Settle open questions by prototype before you write. Run `playbooks/prototype.md` for each. Keep the branch, the SHA, and the screenshots for Appendix A. Ask the operator only about a product or preference call that no run can settle, and give options per the `principles` skill file `never-block-on-the-human`.
3. Explore in subagents briefed per `SKILL.md` section 6. Each returns file pointers, conventions, test commands, and entry points. No inlined dumps.
4. Copy the skeleton below into the plan file and fill every placeholder. Unless the operator names a path, write the file under `.scratch/whips/<run>/plan.md`. Keep every heading and every sub-block in the order shown. One section per PR. One PR is one change with its own evidence, per the `principles` skill file `sequence-verifiable-units`. Name the execution playbook in How to read this. A standing program takes `playbooks/orchestrate.md`. Narrower work takes per-PR `playbooks/feature.md` or `playbooks/bug.md` with landing per `playbooks/shipping.md`.
5. Write under `technical-writing` in full, then `unslop`. The body is one Diataxis mode, how-to. Appendices hold explanation and reference. Each heading states the task or the finding. No long dashes. No mid-sentence colons.
6. Run `node skills/user-invoked/whips/scripts/check-plan.mjs <plan.md>` and fix every line it prints, per the `principles` skill file `encode-lessons-in-structure`.
7. Hand back. Post the plan path and the script output, then stop. Execution starts on the operator's explicit go, under the execution playbook the plan names.

**Verification.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked (the `principles` skill file `prove-it-works`). That sentence is the verification rule. Every verification block opens with it. The live block is mandatory. Ten lanes at the PR head drive the real surface through its control skill, per the `swarm` skill, each in its own worktree on the local machine. Each lane is one box with a concrete scenario, the screenshot it saves, and its pass predicate. One lane is the Regression lane against trunk. It runs the same load-bearing scenario on trunk and head. If trunk does not have the feature, the lane records that fact and gates the behavior the diff adds plus the end state the user waits for instead of inventing a trunk result. The perf gate is dual-sided. Trunk and head must both produce the named metric. If trunk lacks the feature, also isolate the work the diff adds and set an absolute budget for that work plus the end-to-end state the user waits for. Do not claim a ratio between unlike scenarios. The perf block names the metric, the interleaved probe, the trunk baseline measured first, and the rule with the number that fails. The review gate is optional per PR. A gated PR stops at merge-ready with `needs-human` and waits for the operator. An ungated PR writes `**Review gate.** None. <PR id> is not review-gated.` and keeps no boxes under it.

**Control skill.** The lanes drive through the project's verification skill, generated once by `/create-verification`. A PR that touches two surfaces gets lanes on both. A surface with no verification skill is a risk in Appendix C, its live block still names how each lane drives it, and the first gated step tells the user to run `/create-verification` and waits.

## Deviations from pstack

- Owners run local, one worktree and branch per owner per `playbooks/opening-a-pr.md`. No cloud VMs.
- Verification is the repo verifier plus self-proof. Solo repos read the local verifier and team repos read required checks, per `playbooks/shipping.md`. No independent swarm verdict.
- The merge box follows `playbooks/shipping.md` and `playbooks/ready-check.md`. The agent merges when the risk tier allows. No operator-only landing.
- The review gate is optional per PR and means `needs-human` per `playbooks/opening-a-pr.md`. No default operator review.
- The audit tick is a scheduled wake. Use cron, an interval loop, or a runner tick. No Cursor `/loop`.
- Prose passes `no-comments` plus `unslop` plus `code-review`. No `/deslop`.
- The control skill is the `/create-verification` output. No `control-ui` or `control-cli`.

````markdown
# <Program> plan

<Under ten lines. What changes, for whom, the rule the program enforces, and the PR ids in order.>

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists, a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

The program runs `skills/user-invoked/whips/playbooks/<execution playbook>.md`. <Who merges, and which PR ids are the operator's items that stop at merge-ready.>

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program

- [ ] State the protocol and this plan to the operator, then stop. Start execution only on the operator's explicit go.
- [ ] Read these from trunk at program start. Re-read them at every tick.
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/<execution playbook>.md`
  - [ ] `git show origin/main:skills/verify-<app>/SKILL.md`
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/opening-a-pr.md`
  - [ ] `git show origin/main:skills/user-invoked/whips/playbooks/shipping.md`
  - [ ] `git show origin/main:skills/<each other leaf skill the program uses>`
- [ ] On the operator's go, arm the audit wake on a schedule and never leave the cadence to memory. Use cron, an interval loop, or a runner tick with the `runner` skill.
- [ ] Use this tick prompt, verbatim. "Re-read the execution playbook from trunk. Audit the operation against it and fix drift in this tick. Probe every active lane and judge progress by side effects only. Stand down a stuck lane and dispatch its replacement now. Then post a short status message to the operator in chat only when the audit found a tracked change that no earlier status message reported, such as a PR opened, a code-ready head, a round launched or closed, a verdict, a merge, a stuck agent and the action taken, a blocker added or cleared, or a decision only the operator can make. Name every such change and nothing else. Do not repeat a table, the merged list, or an unchanged blocker. If the audit found none, end the turn with no reply text. Either way, log this tick's row in your decision trail. The row names the items reported, or none."
- [ ] On the operator's hold or stand-down, send every owner a zero-writes order at once.

### Spawn owners

- [ ] Spawn one owner per PR with the full lifecycle the execution playbook names. One worktree and one branch per owner, off main, per `playbooks/opening-a-pr.md`.
- [ ] Follow this dependency graph. Start dependent work only after its parent merges, or base it on the parent branch when the execution playbook stacks.
  - [ ] <PR id> and <PR id> are independent and first. Both branch from `main`.
  - [ ] <PR id> after <PR id>.
- [ ] Hold the file boundaries. <PR id or class> touches only `<glob>`.
- [ ] Hold the review gate. <Gated PR ids, or none> stop at merge-ready with `needs-human` and wait for the operator review with screenshots and a video before merge.

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
- [ ] <The merge rule per `playbooks/shipping.md`. Who merges, which PR ids the operator lands, and the MERGED read-back.>

### Boot recipe, for every live lane

Each live lane runs in its own worktree at the PR head on the local machine. Drive through the project's verification skill.

- [ ] Create the lane worktree and check out the exact head SHA.
- [ ] <Launch per the skill and wait for its ready signal.>
- [ ] <Deliver input only through the skill's drive commands. Name the read-only diagnostics.>
- [ ] Save every screenshot to `/tmp/<program>-<pr-id>/lane-<n>/<slug>.png` and return the paths with the report.

## <Task as a verb phrase> (<PR id>)

**Depends on.** <PR id, or None.>

**Files.**

- [ ] Edit `<path>`.
- [ ] Create `<path>`.
- [ ] Delete `<path>`.

**Build.**

- [ ] <One change. Name the symbol and the file.>

**You see.**

- [ ] <One observable result, with the exact log line or screen state.>

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] <Test file and the case it gains.> Run `<command>`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes on `<model role>` at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run <the same load-bearing scenario> at trunk and head. If trunk lacks the feature, record that and gate <the behavior the diff adds plus the end state the user waits for>. Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 2. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 3. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 4. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 5. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 6. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 7. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 8. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 9. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 10. <Scenario.> Save `<slug>.png`. Pass when <predicate>.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. <What is measured at both trunk and head. If trunk lacks the feature, also name the diff-added work and the end-to-end state the user waits for.>
- [ ] Probe. <The command or procedure, run at trunk and at the head, interleaved. Both sides must produce the metric.>
- [ ] Baseline. Record the trunk <value> first.
- [ ] Rule. <Head against trunk, with the number that fails. If the scenarios differ, add absolute budgets for the diff-added work and the user-visible end state instead of an invalid ratio.>

**Review gate.** <`None. <PR id> is not review-gated.` with no boxes below, or the gate below.>

- [ ] Copy lane <n> screenshots into `<media path>/<pr-id>-review-<slug>.png`.
- [ ] Record a 30 to 60 second video of the change on a lane worktree. Save it as `<media path>/<pr-id>-review.mp4`.
- [ ] Stop at merge-ready. Label `needs-human` with a `<!-- needs-human reason=review-gate -->` marker comment, post the screenshots and the video, and wait for the operator.

**Merge.**

- [ ] Ready-check verdict of PASS or PASS+NOTES at the exact head SHA.
- [ ] Patch-id unchanged since the verdict.
- [ ] Rebased onto current trunk after the verdict where the mechanics demand it.
- [ ] <Merge per `playbooks/shipping.md`, or hand the merge-ready PR to the operator.>

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Reply to the operator with the report the execution playbook names.

## Appendix A. Prototype evidence

<Each open question a prototype answered, with the branch, the SHA, and the artifact links. Each question that stays unproven.>

## Appendix B. Alternatives rejected

<Each approach weighed and why it lost.>

## Appendix C. Risks

<Each risk with the PR it lands in and what the owner watches.>

## Appendix D. Links and reading list

<Docs to read before editing. Which PRs get `how` and `interrogate`. The trail per `show-me-your-work`.>
````

**Reply:** the plan path, the PR ids with their dependencies and the review-gated set, what the prototypes proved and what stays unproven, and the check script output.
