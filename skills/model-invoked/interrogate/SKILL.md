---
description: Adversarial multi-model review with rubric and bucketed verdict. Use for contested designs, challenge this, tear this apart, or review before any PR.
name: interrogate
---
# Interrogate

Challenge a change from independent angles before it ships. The signal comes from independent reviewers, not assigned personas. Never auto-applies changes; the deliverable is a verdict in buckets.

## 1. Scope

Review the pointed files or diff, the full branch changeset (`git diff main...HEAD` against the base), or the files behind recent work. Package the diff with the context files a reviewer needs to understand it.

## 2. Intent

State the intent in one paragraph from the message, commit messages, PR description, and code. Unsure means asking the user before spawning anyone.

## 3. Spawn reviewers

One reviewer per available model, all in one round with the same brief (intent, diff, rubric below): the same prompt against different models, agreement is the signal. Models follow the repo model map; with a single model, run two passes (find, then challenge the findings). If the user typed a contested design here, this is the skill `whips` calls before shipping.

## 4. Rubric

Review through whichever lenses fit; not every lens fits every change.

- **Correctness.** Edge cases, error paths, off-by-one and coercion, state and concurrency. Trace the execution path: never flag "could be nil" without the call chain that makes it nil.
- **Root cause vs symptom.** Guards masking invariant violations, retries hiding broken contracts, casts silencing modeling errors, fixes in module A that belong in module B, instructions where structure would fit.
- **Structural integrity.** Validation at boundaries or scattered, orchestration mixed with detail, coupling new dependencies add, data model fit, bolted-on vs integrated (rule 17), dual API paths with no external consumers (rule 14). Simple code is not penalized for lacking abstraction.
- **Verification.** Behavior tests over implementation tests, invariants that catch regressions, a test for the bug, full-path tests at integration boundaries, artifacts verified not self-reports trusted.
- **Complexity budget.** Single-use abstractions, configuration for cases that do not exist, dead code, just-in-case paths, finished migrations keeping scaffolding. Simpler wins unless simpler is wrong.
- **Security.** Input path traced to each finding: injection sinks, auth gaps on new endpoints, secrets in code or logs, time-of-check-time-of-use.

## 5. Synthesize and judge

Merge findings that describe the same issue; note which reviewers raised each. Independently raised by two or more is the highest signal; lone findings weigh less; explicit disagreement is context for the verdict. As lead reviewer put every finding in one bucket with a one-line rationale:

- **Act on.** Blocks a real PR: correctness, security, maintainability against actual goals.
- **Consider.** Legitimate but the cost of acting now is unclear.
- **Noted.** Valid but not actionable now.
- **Dismissed.** Wrong, nitpicky, or missing context, with the reason.

## Output

Intent, reviewers with finding counts, the four buckets, and an agreement map (where reviewers agreed and diverged, and what the pattern tells us).
