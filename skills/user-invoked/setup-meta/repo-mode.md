# Repo mode

Solo or team: one word both humans and playbooks read.

- **Mode:** `<solo|team>`
- **Solo:** the agent merges after the local verifier passes (pre-push). No waiting on GitHub checks. Trust pre-push; run the verifier again before `gh pr create`.
- **Team:** CI decides like pstack. Required checks green before landing; PRs wait on `gh pr checks`.

Missing file means setup never ran: stop and tell the user to run `/setup-meta`.
