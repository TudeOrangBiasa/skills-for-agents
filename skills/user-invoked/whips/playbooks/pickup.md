# Playbook: pickup

Resume or take over another run's in-flight work: a branch, a draft PR, a run log, a pause note, or a transcript the user points at. You own the resume point. The prior trail is the input, not something to redo.

1. Find the trail: the pause note or run log (`.scratch/whips/<run>/`), the branch and its draft PR, the linked issue and its comments. A long transcript goes to a subagent that returns a short timeline of decisions and state.
2. Rebuild the state: branch and worktree, what already landed (`git log` and `git diff` against the base), open todos, decisions made and why.
3. Diff done against pending and name the resume point. Do not rerun work the trail shows finished.
4. Check the inherited claims that the next step depends on, on the real artifact: rerun the cited test or repro once. A prior "done" without evidence is unverified, not done.
5. Route the remaining work to its playbook from the router table and continue there. This playbook ends at the handoff.

**Reply:** where the prior run stopped, what you inherited versus redid (ideally nothing redone), the resume point, and which playbook took over.
