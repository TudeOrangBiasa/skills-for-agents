# Upgrading to mode-aware landing

For consumer repos moving from tiered human-merge to solo-vs-team landing.

1. `AGENTS.md`: delete "Open PRs as drafts", "never merge a `risk:high`", "agents must never merge", "when in doubt -> risk:high". Write the Landing block from `/setup-repo` (see `landing-policy.md`).
2. PR policy scripts (for example `scripts/check-pr-policy.mjs`): delete "human adds label" and "human merges" rules; protected paths become extra automated checks (`landing-policy.md`).
3. PR template: delete "stay draft" and "agents must not merge".
4. `docs/agents/triage-labels.md` and `docs/agents/unattended.md`: regenerate via `/setup-repo` (single vocabulary, wake plus budget).
5. CODEOWNERS and branch protection: required checks only, no required owner review.
6. Open draft PRs: `gh pr ready`, reclassify risk with the verify-blast rubric, babysit to MERGED.
7. Adopter example: this repo's own PRs (#117 and after) landed this way.
8. Repo settings: auto-merge, auto-delete branches, and branch protection via `repo-settings` (#76) or the forge UI, once.
