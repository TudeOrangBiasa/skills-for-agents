# Model-invoked

Skills the agent can fire on its own when the task fits, or the human can type by name. They hold reusable discipline and shared reference. Model-invoked skills may be invoked by other skills.

- **[architect](./architect/SKILL.md)**: Settle types, signatures, and module shape before code: ground, sketch twice, agree, implement, scrap when wrong.
- **[arena](./arena/SKILL.md)**: Parallel design bakeoff: N candidates on one brief, cross-judge, pick a base, graft the best parts.
- **[benchmark-checklist](./benchmark-checklist/SKILL.md)**: Vet a perf measurement (limiter, tuning, limits, errors, repeatability, relevance) before reporting or acting.
- **[blast-radius](./blast-radius/SKILL.md)**: Find what a change could break outside itself and prove the one safety fact by running code.
- **[break](./break/SKILL.md)**: Stress-test one component against worst-case content and states on a throwaway page.
- **[correct](./correct/SKILL.md)**: Eliminate repeated agent mistakes at the highest level that works: architecture, types, lint, tests, docs last.
- **[codebase-design](./codebase-design/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[code-review](./code-review/SKILL.md)**: Review the changes since a fixed point along two axes: Standards and Spec.
- **[diagnose](./diagnose/SKILL.md)**: Diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Build and sharpen a project's domain model.
- **[how](./how/SKILL.md)**: Explain how a subsystem works with complexity triage and fixed output sections.
- **[interrogate](./interrogate/SKILL.md)**: Adversarial multi-model review with rubric and bucketed verdict.
- **[interview](./interview/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea. The reusable interview primitive behind `discuss`, `discuss-with-docs`, `triage`, `wayfinder` and `deepen`.
- **[pr](./pr/SKILL.md)**: The mandatory PR body shape: summary visual, before/after evidence with UI tables, merge danger. Captures visuals with `agent-browser`; attachment method packed in the skill.
- **[prototype](./prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[research](./research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo.
- **[merge-fix](./merge-fix/SKILL.md)**: Use when you need to resolve an in-progress git merge/rebase conflict.
- **[no-comments](./no-comments/SKILL.md)**: Kill needless comments plus the dead code they protect, fix root causes, encode constraints.
- **[setup-pre-commit](./setup-pre-commit/SKILL.md)**: Set up fast hooks with the repo's own toolchain (oxlint/oxfmt, Biome, or Prettier), type checking, tests, and a token-size gate.
- **[show-me-your-work](./show-me-your-work/SKILL.md)**: Keep a reviewable TSV decision trail for long or unattended work, with end audit and attention flags.
- **[swarm](./swarm/SKILL.md)**: Parallel worker fan-out for coverage, races, and gauntlets with one report.
- **[tdd](./tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[technical-writing](./technical-writing/SKILL.md)**: Write docs, RFCs, readmes, and commit messages to a layered standard.
- **[typescript-best-practices](./typescript-best-practices/SKILL.md)**: TypeScript type discipline for agents editing `.ts`/`.tsx`.
- **[ui-recording-timeline](./ui-recording-timeline/SKILL.md)**: Turn a UI screen recording into an interactive paint timeline page for motion proof.
- **[unslop](./unslop/SKILL.md)**: Cut AI tells from prose before it ships.
- **[user-manual](./user-manual/SKILL.md)**: Generate a user manual from a running web app: content-cropped screenshots, selector annotations, HTML plus PDF build with QA gates.
- **[wizard](./wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform.
- **[writing-for-agents](./writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md, and any doc an agent reaches by a pointer.
- **[why](./why/SKILL.md)**: Find why code is shaped this way with fan-out investigators and confidence tiers.

## Principles

One rule each behind the `/whips` triggers. Read the full leaf for each principle you use; cite only leaves you read this session.

- **[principle-subtract-before-you-add](./principle-subtract-before-you-add/SKILL.md)**: Delete dead code first, then build on the simpler base.
- **[principle-fix-root-causes](./principle-fix-root-causes/SKILL.md)**: Trace each symptom upstream and fix it there.
- **[principle-prove-it-works](./principle-prove-it-works/SKILL.md)**: Run the real artifact the user will hit.
- **[principle-sequence-verifiable-units](./principle-sequence-verifiable-units/SKILL.md)**: End each unit and each commit in a check.
- **[principle-model-the-domain](./principle-model-the-domain/SKILL.md)**: Name the data shape before the logic.
- **[principle-make-operations-idempotent](./principle-make-operations-idempotent/SKILL.md)**: Shape reruns to converge.
- **[principle-test-behavior-not-implementation](./principle-test-behavior-not-implementation/SKILL.md)**: Assert what users observe.
- **[principle-never-block-on-the-human](./principle-never-block-on-the-human/SKILL.md)**: Proceed on reversible work.
- **[principle-attack-the-premise](./principle-attack-the-premise/SKILL.md)**: Test the shared assumption behind repeated failures.
- **[principle-boundary-discipline](./principle-boundary-discipline/SKILL.md)**: Validate at system boundaries.
- **[principle-type-system-discipline](./principle-type-system-discipline/SKILL.md)**: Make illegal states unrepresentable.
- **[principle-build-the-lever](./principle-build-the-lever/SKILL.md)**: Build the tool that does the work or proves it.
- **[principle-encode-lessons-in-structure](./principle-encode-lessons-in-structure/SKILL.md)**: Build the guardrail on the second repeat.
- **[principle-migrate-callers-then-delete-legacy-apis](./principle-migrate-callers-then-delete-legacy-apis/SKILL.md)**: Migrate callers, then delete the old API.
- **[principle-separate-before-serializing-shared-state](./principle-separate-before-serializing-shared-state/SKILL.md)**: Give concurrent actors their own targets first.
- **[principle-outcome-oriented-execution](./principle-outcome-oriented-execution/SKILL.md)**: Converge rewrites on the target architecture.
- **[principle-redesign-from-first-principles](./principle-redesign-from-first-principles/SKILL.md)**: Redesign as if the requirement had been foundational.
- **[principle-experience-first](./principle-experience-first/SKILL.md)**: Choose user delight over implementation convenience.
- **[principle-explain-the-number](./principle-explain-the-number/SKILL.md)**: Name what bounds a measured number.
- **[principle-guard-the-context-window](./principle-guard-the-context-window/SKILL.md)**: Route bulk to delegates.
- **[principle-exhaust-the-design-space](./principle-exhaust-the-design-space/SKILL.md)**: Sketch candidates first for novel decisions.
- **[principle-foundational-thinking](./principle-foundational-thinking/SKILL.md)**: Choose core types before logic.
- **[principle-laziness-protocol](./principle-laziness-protocol/SKILL.md)**: Bias to subtraction over new abstractions.
- **[principle-minimize-reader-load](./principle-minimize-reader-load/SKILL.md)**: Count layers between question and answer.
