# Risk classification

Every agent PR carries exactly one risk label and one paragraph saying why. The label tells the human where to spend review time: high-risk PRs get a real review first, low-risk PRs merge as a quick batch. Every PR opens ready, never as a draft; what holds a merge back is the verdict, not draft status. Who may land: low, the agent immediately on an independent PASS verdict (a fresh agent that did not write the code, via `playbooks/ready-check.md` or a second agent; never the worker's own claim), merging in the same run; medium, the agent only when every landing condition in `playbooks/ready-check.md` holds; high, the human always, and only after a PASS or PASS+NOTES verdict comment from a verifier that did not write the code (an independent agent or Tude) on the current head SHA. Only high-risk PRs spend human review time. Green CI and an approving bot review are inputs, never verdicts: neither runs the change as a user would.

Label strings come from `docs/agents/triage-labels.md` when it has `risk-low`, `risk-medium`, and `risk-high` rows; otherwise use `risk:low`, `risk:medium`, and `risk:high`. Create a missing label once with the tracker CLI (`gh label create risk:high --color B60205`, `gh label create risk:medium --color FBCA04`, `gh label create risk:low --color 0E8A16`).

## High

A PR is `risk:high` when any rule below matches. Check each against the diff, not the title.

1. **Auth and security.** Login, sessions, tokens, password handling, permissions, policies or gates, access middleware, CORS or CSRF, rate limits, input sanitizing, file upload validation, crypto.
2. **Money.** Prices, totals, discounts, invoices, payments, refunds, balances, payment gateway calls or webhooks.
3. **Data.** Schema migrations, data backfills, deletes or truncates, changes to soft-delete or cascade rules, jobs that rewrite many rows, seeders that can run in production.
4. **Secrets and config.** `.env.example`, config files, deploy or container files, infrastructure, anything that reads a new secret or changes a default that production relies on.
5. **CI and workflows.** CI workflow files, release scripts, git hooks, branch protection or required checks.
6. **Public contract break.** A removed or renamed endpoint, route, field, status code, event, CLI flag, or exported function that a client or another repo calls. A breaking OpenAPI diff counts.
7. **Dependencies.** A major version bump, a new runtime dependency, or lockfile churn beyond the packages the PR names.
8. **Large diff.** More than 400 changed lines or 15 files, not counting lockfiles, generated files, snapshots, and fixtures.
9. **Unproven.** The verify verdict is not VERIFIED.

In a Laravel app these usually show up as `database/migrations/`, `config/`, `routes/api.php`, `app/Http/Middleware/`, `app/Policies/`, `composer.json`, and `.github/workflows/`. Path is a hint, the diff decides: a comment-only edit to a migration file is not a schema change.

## Medium

A PR is `risk:medium` when no high rule matches and any rule below matches. Check each against the diff, not the title.

1. **New surface in a sensitive area.** A new endpoint, field, flag, job, or exported function touching auth, money, data, or config paths that no existing caller reaches yet.
2. **Additive-only change to sensitive code.** A new optional parameter, nullable column or table, or default-off config key; existing behavior and callers unchanged.
3. **Mid-size diff in sensitive paths.** 150 to 400 changed lines or 6 to 15 files touching the high rules 1-7 areas, with behavior pinned by tests and a VERIFIED verdict.
4. **Minor bump of a security-adjacent dependency** (auth, crypto, payments) with green tests.

A medium PR that gains a high match on reclassify becomes high. A medium PR whose sensitive surface gets its first real caller becomes high.

## Low

Everything else. Typical low-risk work: copy and docs, tests only, internal refactors with the behavior pinned, a new endpoint or field that nothing calls yet, UI changes behind no auth or payment logic, patch or minor dependency bumps with green tests.

## The reason paragraph

Put it in the PR body under `## Risk`, three sentences at most, in plain words:

- High: name each rule that matched, the files that matched it, and the one thing the reviewer should check (for example "run the migration against a copy of production data and confirm the rollback").
- Low: name what the PR touches and why no rule matched (for example "views and tests only; no routes, config, migrations, or dependencies changed").
- Medium: name the sensitive area touched, why existing callers are unaffected, and the verdict SHA that backs it.

Reclassify after every push that changes the diff. A label that moves from high to low says so in the paragraph.
