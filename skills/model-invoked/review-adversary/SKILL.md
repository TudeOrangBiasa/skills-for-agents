---
description: Adversarial multi-model review with rubric and bucketed verdict. Adversaries try to break a change or design, and only findings proven by a run survive. Use for contested designs, challenge this, tear this apart, or review before any PR.
name: review-adversary
---
# Interrogate

Adversaries try to break a change or a design. A finding survives only when a run proves it. Report the findings. Do not apply fixes. The signal comes from independent reviewers, not assigned personas.

## 1. Scope

The scope is what the user names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree. Package the diff with the context files a reviewer needs to understand it.

## 2. Intent

State the intent in your own words in one paragraph from the user message, commit messages, PR description, and code. Ask the user when the intent is unclear, before spawning anyone.

## 3. Spawn reviewers

One reviewer per available model, all in one round with the same brief (intent, diff, rubric below): the same prompt against different models, agreement is the signal. Models follow the repo model map; with a single model, run two passes (find, then challenge the findings). Give each adversary its own worktree and copy the scope uncommitted changes into each, so repros stay isolated. If the user typed a contested design here, this is the skill `whips` calls before shipping.

Brief every adversary to break the change: prove each finding with a run against the real code, such as a failing test, a repro script, or command output showing the wrong behavior. For a design or plan, run a prototype or probe the current tree. Each finding reports a title, the exact command, the output it printed, and the output the intent requires. Leave out anything not run: style, naming, structure, and risks needing a future change to matter. No findings is a valid result.

## 4. Rubric

Review through whichever lenses fit; not every lens fits every change.

- **Correctness.** Edge cases, error paths, off-by-one and coercion, state and concurrency. Trace the execution path: never flag "could be nil" without the call chain that makes it nil.
- **Root cause vs symptom.** Guards masking invariant violations, retries hiding broken contracts, casts silencing modeling errors, fixes in module A that belong in module B, instructions where structure would fit.
- **Structural integrity.** Validation at boundaries or scattered, orchestration mixed with detail, coupling new dependencies add, data model fit, bolted-on vs integrated (rule 17), dual API paths with no external consumers (rule 14). Simple code is not penalized for lacking abstraction.
- **Verification.** Behavior tests over implementation tests, invariants that catch regressions, a test for the bug, full-path tests at integration boundaries, artifacts verified not self-reports trusted.
- **Complexity budget.** Single-use abstractions, configuration for cases that do not exist, dead code, just-in-case paths, finished migrations keeping scaffolding. Simpler wins unless simpler is wrong.
- **Security.** Input path traced to each finding: injection sinks, auth gaps on new endpoints, secrets in code or logs, time-of-check-time-of-use.

## 5. Verify, then synthesize and judge

Verify each finding by rerunning its command. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause; note which reviewers raised each. Adversaries find different failures, so the verdict keeps every verified finding, not one adversary's list. Independently raised by two or more is the highest signal; lone findings weigh less; explicit disagreement is context for the verdict.

As lead reviewer put every verified finding in one bucket with a one-line rationale:

- **Act on.** Blocks a real PR: correctness, security, maintainability against actual goals.
- **Consider.** Legitimate but the cost of acting now is unclear.
- **Noted.** Valid but not actionable now.
- **Dismissed.** Wrong, nitpicky, or missing context, with the reason.

## Output

- **Intent.** The restatement.
- **Findings.** For each verified finding: the command, its output, how it breaks the intent, and the adversaries that found it. Say "no verified findings" when none survive.
- **Dropped.** For each adversary, the count of dropped findings and why.
- **Buckets.** Every verified finding in Act/Consider/Noted/Dismissed with a one-line rationale, plus an agreement map (where reviewers agreed and diverged, and what the pattern tells us).
