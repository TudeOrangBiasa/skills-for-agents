# Principles

Twenty-four rules behind the `/whips` triggers. Read the full file for each principle you use before the first design decision, and cite only principles whose file you read this session. Texts live in the `principles` skill; each row links its file. In the reply, name each one that changed a decision and the choice it changed.

- [Subtract before you add](../../model-invoked/principles/principles/subtract-before-you-add.md): before building on existing code, delete dead code and redundant checks first.
- [Fix the root cause](../../model-invoked/principles/principles/fix-root-causes.md): when debugging, trace each symptom upstream to the first wrong step.
- [Prove it works](../../model-invoked/principles/principles/prove-it-works.md): after completing a task, run the real artifact the user will hit.
- [Small verifiable units](../../model-invoked/principles/principles/sequence-verifiable-units.md): for multi-step work and stacked commits, end each unit in a check.
- [Model the domain](../../model-invoked/principles/principles/model-the-domain.md): for stateful logic, name the data shape before the logic.
- [Make operations idempotent](../../model-invoked/principles/principles/make-operations-idempotent.md): for state-changing work, shape reruns to converge.
- [Test behavior, not implementation](../../model-invoked/principles/principles/test-behavior-not-implementation.md): when writing or keeping a test, assert what users observe.
- [Never block on the human](../../model-invoked/principles/principles/never-block-on-the-human.md): for reversible work, proceed and let the human correct course.
- [Attack the premise](../../model-invoked/principles/principles/attack-the-premise.md): when repeated fixes fail the same gate, test the shared assumption.
- [Boundary discipline](../../model-invoked/principles/principles/boundary-discipline.md): when wiring boundaries, validate and handle errors there.
- [Type system discipline](../../model-invoked/principles/principles/type-system-discipline.md): when designing types or parsing untrusted input, make illegal states unrepresentable.
- [Build the lever](../../model-invoked/principles/principles/build-the-lever.md): for non-trivial work, build the tool that does it or proves it.
- [Encode lessons in structure](../../model-invoked/principles/principles/encode-lessons-in-structure.md): when writing the same instruction twice, build the guardrail.
- [Migrate callers, then delete](../../model-invoked/principles/principles/migrate-callers-then-delete-legacy-apis.md): for a new internal API, migrate callers and delete the old one.
- [Separate before serializing](../../model-invoked/principles/principles/separate-before-serializing-shared-state.md): for concurrent actors on shared state, give each its own target first.
- [Outcome-oriented execution](../../model-invoked/principles/principles/outcome-oriented-execution.md): for planned rewrites, converge on the target and declare breakage scope.
- [Redesign from first principles](../../model-invoked/principles/principles/redesign-from-first-principles.md): for a new requirement, redesign as if it had been foundational.
- [Experience first](../../model-invoked/principles/principles/experience-first.md): for product tradeoffs, choose user delight over implementation convenience.
- [Explain the number](../../model-invoked/principles/principles/explain-the-number.md): before trusting a measured number, name what bounds it.
- [Guard the context window](../../model-invoked/principles/principles/guard-the-context-window.md): when context fills up, route bulk to delegates.
- [Exhaust the design space](../../model-invoked/principles/principles/exhaust-the-design-space.md): for novel decisions with no precedent, sketch candidates first (carried by `codebase-design` and `architect`).
- [Foundational thinking](../../model-invoked/principles/principles/foundational-thinking.md): before writing logic, choose core types first (carried by `codebase-design`).
- [Laziness protocol](../../model-invoked/principles/principles/laziness-protocol.md): when tempted to add abstractions, bias to subtraction (carried by rule 1).
- [Minimize reader load](../../model-invoked/principles/principles/minimize-reader-load.md): for hard-to-trace code, count layers and hide indirection (carried by the `codebase-design` vocabulary).
