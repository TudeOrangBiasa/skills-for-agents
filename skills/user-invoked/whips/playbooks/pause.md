# Playbook: pause

A clean stop that a cold-start agent can resume from: the laptop is closing, the user says pause, the session is about to compact or hit its limit. Explicit only. "Keep going" or "don't stop" means no pause.

1. Stop at a safe boundary. Finish the current small step or back out of it. Start nothing new, and stop any subagents you spawned.
2. Make the work durable. Commit uncommitted edits as one `wip:` commit on the current agent branch and push it. A broken tree says so in one line of the commit body. Open no new PR to pause.
3. Write the pause note to `.scratch/whips/<run>/pause.md`: the goal, the playbook and current step, what is verified, the branch and PR links, next steps in order, key files, and gotchas. Point at the run log rather than copying it.
4. Leave claims honest. An issue you claimed and will not resume soon gets a tracker comment saying where the work stands.

**Reply:** the step you stopped at, the commit and branch, whether the tree is clean, the pause note path, and the first action on resume. Resuming goes through `playbooks/pickup.md`.
