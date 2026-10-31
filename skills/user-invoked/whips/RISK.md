# Risk classification

Every agent PR carries exactly one risk label and one paragraph saying why. The label says which extra verification runs on this PR, scaled to the diff's blast radius. Every PR opens ready, never as a draft; what holds a merge back is the verdict, not draft status. Who may land: low, the agent immediately on an independent PASS verdict (a fresh agent with no access to the author's reasoning, briefed by [VERIFIER-BRIEF.md](VERIFIER-BRIEF.md); never the worker's own claim), merging in the same run; medium, the agent only when every landing condition in `playbooks/ready-check.md` holds; high, the human always, and only after a PASS or PASS+NOTES verdict comment from a verifier that did not write the code (an independent agent or a human reviewer) on the current head SHA. Only high-risk PRs spend human review time. Verifier output and bot approvals are inputs, never verdicts: solo repos read the local verifier, team repos read CI. Neither runs the change as a user would.

Pick the label from the diff against the rules below, and name the matched rule in `## Risk`. A label from a template, or high from doubt without a matched rule, is a misclassification: reclassify, and settle doubt with the `verify-blast` skill, never with automatic high.

Label strings come from `docs/agents/triage-labels.md` when it has `risk-low`, `risk-medium`, and `risk-high` rows; otherwise use `risk:low`, `risk:medium`, and `risk:high`. Create a missing label once with the tracker CLI command from `docs/agents/issue-tracker.md`.

## High

A PR is `risk:high` when any rule below matches. Check each against the diff, not the title.

1. **Auth and security.** Login, sessions, tokens, password handling, permissions, policies or gates, access middleware, CORS or CSRF, rate limits, input sanitizing, file upload validation, crypto.
2. **Money.** Prices, totals, discounts, invoices, payments, refunds, balances, payment gateway calls or webhooks.
3. **Data.** Schema migrations, data backfills, deletes or truncates, changes to soft-delete or cascade rules, jobs that rewrite many rows, seeders that can run in production.
4. **Secrets and config.** `.env.example`, config files, deploy or container files, infrastructure, anything that reads a new secret or changes a default that production relies on.
5. **CI and workflows.** CI workflow files, release scripts, git hooks (including `.husky/`), branch protection or required checks. The docs gate (`scripts/check-docs.sh`) counts here: a PR that teaches the gate a new rule changes what every future PR must pass.
6. **Public contract break.** A removed or renamed endpoint, route, field, status code, event, CLI flag, or exported function that a client or another repo calls. A breaking OpenAPI diff counts.
7. **Dependencies.** A major version bump, a new runtime dependency, or lockfile churn beyond the packages the PR names.
8. **Large diff.** More than 400 changed lines or 15 files, not counting lockfiles, generated files, snapshots, fixtures, and new files no caller reaches yet. A large diff matching none of rules 1-7 is medium, not high.
9. **Unproven.** The verify verdict is not VERIFIED.

Stack examples live in `docs/agents/domain.md` (written by `/setup-repo` per repo). Path is a hint, the diff decides: a comment-only edit to a migration file is not a schema change.

## Medium

A PR is `risk:medium` when no high rule matches and any rule below matches. Check each against the diff, not the title.

1. **New surface in a sensitive area.** A new endpoint, field, flag, job, or exported function touching auth, money, data, or config paths that no existing caller reaches yet.
2. **Additive-only change to sensitive code.** A new optional parameter, nullable column or table, or default-off config key; existing behavior and callers unchanged.
3. **Mid-size diff in sensitive paths.** 150 to 400 changed lines or 6 to 15 files touching the high rules 1-7 areas, with behavior pinned by tests and a VERIFIED verdict.
4. **Minor bump of a security-adjacent dependency** (auth, crypto, payments) with green tests.

A medium PR that gains a high match on reclassify becomes high. A medium PR whose sensitive surface gets its first real caller becomes high.

## Low

Everything else. Typical low-risk work: copy and docs, tests only, internal refactors with the behavior pinned, a new endpoint or field that nothing calls yet, UI changes behind no auth or payment logic, patch or minor dependency bumps with green tests.

## Verification per tier

- **Low:** the repo verifier passes (solo: local verifier; team: required checks). That is the verifier.
- **Medium:** low, plus an agent that did not write the code runs the affected surface (endpoint, page, tests) in a fresh context and checks `git patch-id` when a rebase landed.
- **High:** medium, plus the `verify-blast` skill proves what can break outside the diff by running code, plus one adversarial reviewer in a fresh context (same model, no author reasoning, brief opens with "find how this PR breaks", lens correctness, security, or blast radius per #67). Data and secrets rules add a dry-run or rollback proof. Arming waits until this lane passes; FAIL means `needs-human`.

Cases: an isolated 500-line spike of new files with no runtime caller is medium or low, never high on size alone. A workflow change is high, verified against the gate it changes.

The machine-readable form of this verdict is an HTML marker comment checked by `scripts/verdict-check <pr>` for the optional high lane.

## The reason paragraph

Put it in the PR body under `## Risk`, three sentences at most, in plain words: which verification tier ran and its result (link or SHA).

- High: name each rule that matched, the files that matched it, and the extra verification to run (for example "run the migration against a copy of production data and confirm the rollback").
- Low: name what the PR touches and why no rule matched (for example "views and tests only; no routes, config, migrations, or dependencies changed").
- Medium: name the sensitive area touched, why existing callers are unaffected, and the verdict SHA that backs it.

Reclassify after every push that changes the diff. A label that moves from high to low says so in the paragraph.
