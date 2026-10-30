# Principles

Twenty-four rules behind the `/whips` triggers. Read the full leaf for each principle you use before the first design decision, and cite only principles whose leaf you read this session. In the reply, name each one that changed a decision and the choice it changed.

- [Subtract before you add](../../model-invoked/principle-subtract-before-you-add/SKILL.md): before building on existing code, delete dead code and redundant checks first.
- [Fix the root cause](../../model-invoked/principle-fix-root-causes/SKILL.md): when debugging, trace each symptom upstream to the first wrong step.
- [Prove it works](../../model-invoked/principle-prove-it-works/SKILL.md): after completing a task, run the real artifact the user will hit.
- [Small verifiable units](../../model-invoked/principle-sequence-verifiable-units/SKILL.md): for multi-step work and stacked commits, end each unit in a check.
- [Model the domain](../../model-invoked/principle-model-the-domain/SKILL.md): for stateful logic, name the data shape before the logic.
- [Make operations idempotent](../../model-invoked/principle-make-operations-idempotent/SKILL.md): for state-changing work, shape reruns to converge.
- [Test behavior, not implementation](../../model-invoked/principle-test-behavior-not-implementation/SKILL.md): when writing or keeping a test, assert what users observe.
- [Never block on the human](../../model-invoked/principle-never-block-on-the-human/SKILL.md): for reversible work, proceed and let the human correct course.
- [Attack the premise](../../model-invoked/principle-attack-the-premise/SKILL.md): when repeated fixes fail the same gate, test the shared assumption.
- [Boundary discipline](../../model-invoked/principle-boundary-discipline/SKILL.md): when wiring boundaries, validate and handle errors there.
- [Type system discipline](../../model-invoked/principle-type-system-discipline/SKILL.md): when designing types or parsing untrusted input, make illegal states unrepresentable.
- [Build the lever](../../model-invoked/principle-build-the-lever/SKILL.md): for non-trivial work, build the tool that does it or proves it.
- [Encode lessons in structure](../../model-invoked/principle-encode-lessons-in-structure/SKILL.md): when writing the same instruction twice, build the guardrail.
- [Migrate callers, then delete](../../model-invoked/principle-migrate-callers-then-delete-legacy-apis/SKILL.md): for a new internal API, migrate callers and delete the old one.
- [Separate before serializing](../../model-invoked/principle-separate-before-serializing-shared-state/SKILL.md): for concurrent actors on shared state, give each its own target first.
- [Outcome-oriented execution](../../model-invoked/principle-outcome-oriented-execution/SKILL.md): for planned rewrites, converge on the target and declare breakage scope.
- [Redesign from first principles](../../model-invoked/principle-redesign-from-first-principles/SKILL.md): for a new requirement, redesign as if it had been foundational.
- [Experience first](../../model-invoked/principle-experience-first/SKILL.md): for product tradeoffs, choose user delight over implementation convenience.
- [Explain the number](../../model-invoked/principle-explain-the-number/SKILL.md): before trusting a measured number, name what bounds it.
- [Guard the context window](../../model-invoked/principle-guard-the-context-window/SKILL.md): when context fills up, route bulk to delegates.
- [Exhaust the design space](../../model-invoked/principle-exhaust-the-design-space/SKILL.md): for novel decisions with no precedent, sketch candidates first (carried by `codebase-design` and `architect`).
- [Foundational thinking](../../model-invoked/principle-foundational-thinking/SKILL.md): before writing logic, choose core types first (carried by `codebase-design`).
- [Laziness protocol](../../model-invoked/principle-laziness-protocol/SKILL.md): when tempted to add abstractions, bias to subtraction (carried by rule 1).
- [Minimize reader load](../../model-invoked/principle-minimize-reader-load/SKILL.md): for hard-to-trace code, count layers and hide indirection (carried by the `codebase-design` vocabulary).
