# Playbook: autopilot-stack

Run `playbooks/autopilot-full.md`, but do not land. Route here on "autopilot-stack", "stack them, don't ship", "autopilot, don't merge", or "build the stack, I'll land it". This opt-out is the one way the operator holds landing while owners keep building with full autonomy.

The operator's go covers the queue's items only. Items the operator names as theirs and PRs outside the queue stop at merge-ready per `playbooks/babysit.md`. A request to state the plan is not a go.

1. In place of autopilot-full step 6, stop at verified. Stop when each PR is verified and green at its current head, then hand the PRs to the operator. After the handoff, nobody pushes without the operator's go. Every wake tick from `docs/agents/unattended.md` re-reads this file, so each tick sees the no-landing rule.
2. Stack a PR only when it builds on another PR. This is the one exception to autopilot-full step 4. Base the PR on the other PR's branch in place of trunk per `playbooks/opening-a-pr.md` step 7. In place of the rebase onto trunk, each PR rebases onto its parent PR's branch, and the stack root rebases onto trunk. A new head on the lower PR restacks the PRs above it, and a PR whose `git patch-id` the restack leaves unchanged keeps its verdict per `playbooks/ready-check.md` step 3. Landing waits for the operator: a child never lands before its base is the trunk, per `playbooks/shipping.md`.

**Reply:** list each PR with its verdict and links to the PR and trail, in place of what merged.
