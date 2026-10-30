---
description: Assert what the code's users can observe. Use when you write, change, or keep a test, so it fails when behavior breaks and keeps passing when only internals change.
name: principle-test-behavior-not-implementation
disable-model-invocation: true
---
# Test behavior, not implementation

Each test claims something about what the code does for its users: a caller, an end user, another service. Behavior is what those users can see through the interface they use: return values, errors, state they can read back, effects on outside systems such as a request sent, a row written, a message emitted. Implementation is everything else: private helpers, internal call order, intermediate data, which internal collaborator did the work.

Why: a test pinned to internals snaps on every refactor yet catches no bug, while a test looser than the contract stays green while behavior is broken. One taxes every change; the other hides real failure.

## The two edits

Put each test against two imagined edits:

1. **Break the behavior.** Return a wrong value, skip an effect, perform it twice. A test that still passes proves nothing. Common causes: asserting less than the contract promises, deriving the expected value from the code under test, restating a constant or prompt string without running the code that reads it, asserting on data the test assembled itself.
2. **Change the internals.** Restructure the code while every observable result stays identical. A test that now fails is coupled to the implementation and will demand a rewrite on each refactor.

Keep a test that catches the first edit and survives the second; rewrite or delete the rest. Drive the code through its users' interface with a concrete input, take the expected value from the requirement rather than from a run of the code, and assert exactly what the contract promises.

## The contract decides

The promise decides what counts as behavior, not the assertion shape. When the promise is "an empty cart never charges", asserting the payment client received no call is behavior; pair it with a case where the charge lands so the test proves it can see a call. The payload a mocked external service receives is behavior, because that service observes it; a call into an internal helper is implementation, because no user can see it. An empty list is the precise answer when nothing matches and a hollow check when the test merely needs some result. An exact error message pins wording no caller reads, while the error type callers branch on is the contract. A test may pin an invariant instead of a call, for instance a key that must exist in two tables; that invariant is the behavior.

## In this repo

A test for `scripts/check-docs.sh` runs the script against a fixture diff and asserts the exit code plus the reported failures, not the helpers invoked along the way. Failing when the script reports the wrong skill while surviving an internal refactor is behavior; pinning the exact helper trace is implementation.

**Reply:** for each test kept, the behavior it claims and the interface it drives; for each rewritten or deleted, which of the two edits it failed.
