# Landing policy

How PRs land in this repo. Read with `repo-mode.md` (solo or team) and `verifier.md` (the command that decides green).

- **PRs open ready, never as draft.** Draft status never gates landing; the verifier plus the risk tier do.
- **Solo:** the agent merges after the local verifier passes. Trust pre-push; never wait on hosted checks.
- **Team:** required checks decide, like pstack. No required human review, no required owner review.
- **Risk tiers scale verification, not who merges:** low runs the verifier; medium adds a fresh-context surface run; high adds `verify-blast` plus an adversarial reviewer (see the whips `RISK.md`). `needs-human` with a marker reason stops landing until a human decides.
- **Protected paths are extra automated checks, not human labels:** workflow files, CODEOWNERS, policy scripts, license, hooks. A PR touching them needs the normal tier verification plus the path's own check green (for example the `verify` check). No label that only a human may attach; CODEOWNERS notifies without requiring review.
- **Never weaken a gate to land.** A red verifier stops the run; `--no-verify` is never used to bypass.

Upgrading a consumer repo: see [migration-landing.md](./migration-landing.md).
