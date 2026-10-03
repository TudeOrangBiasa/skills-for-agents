---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

TDD is the red → green loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle: consult them before and during the loop, not after.

When exploring the codebase, read `GLOSSARY.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Seams: where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Before writing any test, write down the seams under test and confirm them with the user. No test is written at an unconfirmed seam. You can't test everything, so agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Ask: "What's the public interface, and which seams should we test?"

When the shape of that interface is itself in question (how deep the module is, where the seam belongs, what the interface should expose), call the Skill tool with "codebase-design" for the vocabulary. It is the shared source of the module, interface, depth, seam, adapter, leverage and locality terms, and it is a reference to consult, not a session to run.

## The undefined check

Before keeping a test, ask whether it would still pass if every imported function returned `undefined`. If yes, it observes no behavior and cannot fail for a defect. Rewrite the assertion or delete the test.

A test that cannot fail for a defect costs CI time and review attention and catches nothing. Prefer no new test over a bad test.

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior has not changed.
- **Tautological (self-referential)**: the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, `expect(parsed.url).toBe(buildUrl(...))`, `expect(f(a)).toBe(f(a))`), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Weak or mock-only assertion**: no `expect`, or only `toBeDefined`, `toBeTruthy`, `not.toThrow`, `toBeInstanceOf`, `toHaveBeenCalled`, `toEqual([])`, `toHaveLength(0)`. The fix: call the subject in the body with one concrete input and assert the literal output or the observable effect.
- **Constant pin**: the assertion restates a hand-maintained constant, config default, table row, or prompt string (`expect(LIMITS.maxTools).toBe(8)`). It fails when someone edits the constant legitimately, and catches no defect. Test the mechanism that reads the constant with one input instead. Keep only relation checks across table rows and compile-time checks in `*.test-d.ts`.
- **Fixture asserts fixture**: the assertion reads data the test built or a value computed in `beforeEach`, and the subject never runs in the body. The fix: run the subject in the body and assert its output.
- **Horizontal slicing**: writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead: one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## When to skip

Do not force a test when it would be impractical. If the available test would require broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state, vague reproduction steps, or large unrelated fixture churn, skip adding a new test and use the closest useful verification instead: a targeted script, manual reproduction command, browser automation, snapshot comparison, log assertion, or focused integration check.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Do not anticipate future tests or add speculative features.
- **Confirm the red.** Run the new test before fixing. Confirm it fails for the intended reason. If it passes or fails for an unrelated reason, correct the test or reproduction before editing the implementation.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Do not change tests to match a wrong implementation.** Do not weaken existing assertions unless the expected behavior has genuinely changed and the reason is clear.
- **Keep the test focused.** Avoid broad fixture churn or unrelated coverage expansion. If the bug exposes a broader class of failures, land the focused regression first, then consider sibling coverage.
- **Refactoring is not part of the loop.** It belongs to the review stage (see the `code-review` skill), not the red → green implementation cycle.

## Final response

Report the evidence, not just the outcome:

- Name the failing-before test and the failure it produced.
- Name the passing-after test run and any nearby validation performed.
- If failing-before evidence could not be demonstrated, state why and describe the closest check used instead.
