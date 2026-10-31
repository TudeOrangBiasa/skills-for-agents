# Model-invoked

Skills the agent can fire on its own when the task fits, or the human can type by name. They hold reusable discipline and shared reference. Model-invoked skills may be invoked by other skills.

- **[craft-architect](./craft-architect/SKILL.md)**: Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong.
- **[craft-arena](./craft-arena/SKILL.md)**: Parallel design bakeoff: N candidates on one brief, cross-judge, pick a base, graft the best parts.
- **[verify-bench](./verify-bench/SKILL.md)**: Vet a perf measurement (limiter, tuning, limits, errors, repeatability, relevance) before reporting or acting.
- **[verify-blast](./verify-blast/SKILL.md)**: Find what a change could break outside itself and prove the one safety fact by running code.
- **[craft-break](./craft-break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page.
- **[craft-correct](./craft-correct/SKILL.md)**: Eliminate repeated agent mistakes at the highest level that works: architecture, types, lint, tests, docs last.
- **[craft-vocab](./craft-vocab/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[review-code](./review-code/SKILL.md)**: Review the changes since a fixed point along two axes: Standards and Spec.
- **[craft-diagnose](./craft-diagnose/SKILL.md)**: Diagnosis loop for hard bugs and performance regressions.
- **[craft-domain](./craft-domain/SKILL.md)**: Build and sharpen a project's domain model.
- **[craft-how](./craft-how/SKILL.md)**: Explain how a subsystem works with complexity triage and fixed output sections.
- **[review-adversary](./review-adversary/SKILL.md)**: Adversarial multi-model review with rubric and bucketed verdict.
- **[plan-interview](./plan-interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable plan-interview primitive behind `plan-grill`, `plan-grill-docs`, `ship-triage`, `plan-map` and `craft-deepen`.
- **[ship-pr](./ship-pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence with UI tables, merge danger. Captures visuals with `agent-browser`; attachment method packed in the skill.
- **[craft-proto](./craft-proto/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[principles](./principles/SKILL.md)**: Index of 24 engineering principles behind `/whips` triggers; read the file that fits before the first design decision.
- **[craft-research](./craft-research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo.
- **[ship-merge-fix](./ship-merge-fix/SKILL.md)**: Use when you need to resolve an in-progress git merge/rebase conflict.
- **[review-nocomment](./review-nocomment/SKILL.md)**: Kill needless comments plus the dead code they protect, fix root causes, encode constraints.
- **[setup-hooks](./setup-hooks/SKILL.md)**: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate.
- **[craft-trail](./craft-trail/SKILL.md)**: Keep a reviewable TSV decision trail for long or unattended work, with end audit and attention flags.
- **[craft-swarm](./craft-swarm/SKILL.md)**: Parallel worker fan-out for coverage, races, and gauntlets with one report.
- **[verify-tdd](./verify-tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[review-prose](./review-prose/SKILL.md)**: Write docs, RFCs, readmes, and commit messages to a layered standard.
- **[craft-ts](./craft-ts/SKILL.md)**: TypeScript type discipline for agents editing `.ts`/`.tsx`.
- **[craft-ui-timeline](./craft-ui-timeline/SKILL.md)**: Turn a UI screen recording into an interactive paint timeline page for motion proof.
- **[review-unslop](./review-unslop/SKILL.md)**: Cut AI tells from prose before it ships.
- **[craft-manual](./craft-manual/SKILL.md)**: Generate a user manual from a running web app: content-cropped screenshots, selector annotations, HTML plus PDF build with QA gates.
- **[craft-wizard](./craft-wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
- **[craft-agent-docs](./craft-agent-docs/SKILL.md)**: Writing documents for agents: skills, AGENTS.md, and any doc an agent reaches by a pointer.
- **[craft-why](./craft-why/SKILL.md)**: Find why code is shaped this way with fan-out investigators and confidence tiers.

## Principles

One rule each behind the `/whips` triggers, carried by the [principles](./principles/SKILL.md) index skill. Read the full file for each principle you use; cite only files you read this session.

- **[subtract](./principles/principles/subtract-before-you-add.md)**: Delete dead code first, then build on the simpler base.
- **[root causes](./principles/principles/fix-root-causes.md)**: Trace each symptom upstream and fix it there.
- **[prove it](./principles/principles/prove-it-works.md)**: Run the real artifact the user will hit.
- **[small units](./principles/principles/sequence-verifiable-units.md)**: End each unit and each commit in a check.
- **[domain model](./principles/principles/model-the-domain.md)**: Name the data shape before the logic.
- **[idempotent](./principles/principles/make-operations-idempotent.md)**: Shape reruns to converge.
- **[behavior tests](./principles/principles/test-behavior-not-implementation.md)**: Assert what users observe.
- **[no blocking](./principles/principles/never-block-on-the-human.md)**: Proceed on reversible work.
- **[premise](./principles/principles/attack-the-premise.md)**: Test the shared assumption behind repeated failures.
- **[boundaries](./principles/principles/boundary-discipline.md)**: Validate at system boundaries.
- **[types](./principles/principles/type-system-discipline.md)**: Make illegal states unrepresentable.
- **[lever](./principles/principles/build-the-lever.md)**: Build the tool that does the work or proves it.
- **[structure](./principles/principles/encode-lessons-in-structure.md)**: Build the guardrail on the second repeat.
- **[migrate](./principles/principles/migrate-callers-then-delete-legacy-apis.md)**: Migrate callers, then delete the old API.
- **[separate](./principles/principles/separate-before-serializing-shared-state.md)**: Give concurrent actors their own targets first.
- **[outcome](./principles/principles/outcome-oriented-execution.md)**: Converge rewrites on the target architecture.
- **[first principles](./principles/principles/redesign-from-first-principles.md)**: Redesign as if the requirement had been foundational.
- **[experience](./principles/principles/experience-first.md)**: Choose user delight over implementation convenience.
- **[numbers](./principles/principles/explain-the-number.md)**: Name what bounds a measured number.
- **[context](./principles/principles/guard-the-context-window.md)**: Route bulk to delegates.
- **[design space](./principles/principles/exhaust-the-design-space.md)**: Sketch candidates first for novel decisions.
- **[foundations](./principles/principles/foundational-thinking.md)**: Choose core types before logic.
- **[laziness](./principles/principles/laziness-protocol.md)**: Bias to subtraction over new abstractions.
- **[reader load](./principles/principles/minimize-reader-load.md)**: Count layers between question and answer.
