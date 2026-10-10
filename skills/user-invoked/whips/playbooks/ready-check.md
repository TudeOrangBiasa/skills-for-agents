# Playbook: ready-check

The half after babysit. Verify each open agent PR independently, classify its risk, and hand the human a merge plan: high-risk PRs first for a real review, low-risk PRs as a quick batch. You never mark ready, merge, or arm auto-merge. The human does both batches.

1. Freeze the list. The PRs the user named, else every open draft PR from agent branches in the repo. For stacks, record bottom-to-top order and each PR's base.
2. Verify each PR independently with a fresh subagent that did not write it (section 6 brief, `review` role in `docs/agents/models.md`). It runs the PR's head against its base on the real surface (tests, the page, the endpoint) and returns PASS, PASS+NOTES, or FAIL with evidence. Record the head SHA with the verdict and post the verdict as a PR comment. CI green and bot approvals are inputs, not verdicts.
3. Check each verdict still matches the code: a head SHA that moved after the verdict means verify again.
4. Classify risk per `RISK.md`. Apply the label and write or update the `## Risk` paragraph in the PR body. A FAIL or INCONCLUSIVE verdict is `risk:high` by rule 9.
5. Check mergeability per PR: conflicts, required checks, unresolved threads, base branch. A blocker that babysit can clear goes back to `playbooks/babysit.md`; anything else is listed for the human.
6. Order the plan. Stacked PRs merge bottom-up and only as a contiguous verified run from the root: a PASS above a FAIL waits. Independent PRs order by risk.
7. Report, high-risk first:
   - **Review first**: each high-risk PR with its link, verdict, the matched rules, and the one thing to check.
   - **Quick batch**: low-risk PRs that passed, in merge order, one line each.
   - **Blocked**: FAIL, stale, or conflicted PRs and what each needs.

**Reply:** the three lists above, the stack order, each verdict with who produced it and at which SHA, and a short "Why this way" for any PR whose label might surprise the user.
