# Playbook: pause

A clean stop that a cold-start agent can resume from: the laptop is closing, the user says pause, the session is about to compact or hit its limit. Explicit only. "Keep going" or "don't stop" means no pause.

1. Stop at a safe boundary. Finish the current small step or back out of it. Start nothing new, and stop any subagents you spawned.
2. Make the work durable. Commit uncommitted edits as one `wip:` commit on the current agent branch and push it. A broken tree says so in one line of the commit body. Open no new PR to pause. The push is a deliberate break from pstack `pause-safely.md` ("no push unless you already had one out"): a pause that no other machine can fetch is not durable.
3. Write the pause note to `.scratch/whips/<run>/pause.md`: the goal, the playbook and current step, what is verified, the branch and PR links, next steps in order, key files, and gotchas. Point at the run log (`decisions.tsv` per `show-me-your-work`, never prose copied) rather than copying it. Then mirror the same note into one comment on the PR, or on the issue when no PR exists yet: find the comment whose body contains `<!-- whips-pause run=<id> -->` and edit it in place; create it only when missing; post nothing when the body would be identical. One comment per run, never a new comment per pause.
4. Mirror the run log the same way while the run is unattended: one comment carrying `<!-- whips-run-log run=<id> -->` holds the short per-iteration summary, edited in place and created only when missing. The local `decisions.tsv` (appended with the `show-me-your-work` `scripts/log.sh` helper, one row per landed unit) stays the detail source. A tick that changed nothing writes nothing: no edit, no comment (the ketchup rule is to skip steps that changed nothing).
5. Leave claims honest. An issue you claimed and will not resume soon gets a tracker comment saying where the work stands.

Mirror mechanics: list with `gh api repos/<owner>/<repo>/issues/<n>/comments` (works for PRs too), match the marker for this run, compare bodies before writing, and PATCH `.../issues/comments/<id>` on the matched comment or `gh pr comment <n>` / `gh issue comment <n>` only when no match exists. The TSV row format comes from the `show-me-your-work` `log.sh` helper; the marker comments carry only the short summary, never the full log.

**Reply:** the step you stopped at, the commit and branch, whether the tree is clean, the pause note path, and the first action on resume. Resuming goes through `playbooks/pickup.md`.
