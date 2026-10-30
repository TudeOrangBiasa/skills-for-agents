# Playbook: shipping

How a verified PR lands. pstack behavior: verify on the real surface, then merge directly. No auto-merge arming, no waiting on a queue: only a read-back MERGED counts as landed.

1. Read `docs/agents/repo-mode.md` first. Solo: merge after the local verifier passes (trust pre-push; never wait on `gh pr checks`). Team: required checks decide like pstack; PRs wait on `gh pr checks`.
2. Merge one PR at a time with `gh pr merge <pr> --squash`; record each merge SHA. A requested auto-merge may never fire, so never count arming as landing.
3. After each merge, read back `gh pr view <pr> --json state,mergedAt,baseRefName` and report merged only when state is MERGED and base is the trunk. A merge command can claim success while only queueing.
4. After a parent merges, retarget each child to the trunk (`gh pr edit <pr> --base <trunk>`), transplant its patch onto the merged result, and push with `--force-with-lease=<branch>:<last-pushed-sha>`. Never touch the stack topology outside this step.
5. Babysit each stack per `babysit.md` while landing: conflicts first, then review threads, then checks. Freeze the topology during landing (no base retargets, no stack submits, no decorative force-pushes).
