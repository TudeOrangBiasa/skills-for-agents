# Credits

All 24 principle files adapted from the pstack skill set by poteto ([Lauren Tan](https://x.com/poteto), MIT). Rewritten to this repo voice: rule-first shape with Why and a repo-local example, no harness-specific wording. Copied in, not depended on, so standalone installs keep working without the upstream repo.

- [subtract-before-you-add](./principles/subtract-before-you-add.md): removal-before-construction sequencing, cut-before-polish, designing for observed usage, the ban on speculative validators and guards, prompt simplification, deleting stub references. Example: the whips token budget in `check-docs.sh`.
- [fix-root-causes](./principles/fix-root-causes.md): fault-versus-symptom framing, reproduce-then-ask-why, instrumenting over guessing, the legitimate-state test for guards, persisted-state suspicion after restarts, pattern-over-instance fixes, the paragraph-comment smell, the cheap always-on signal. Example: a CI-only `check-docs.sh` failure.
- [prove-it-works](./principles/prove-it-works.md): real-artifact verification, proxy-versus-source distinction (liveness, actual values, observation method first), scripting the check as re-runnable proof, keeping the artifact visible. Example: proving a `check-docs.sh` change with fixture diffs.
- [sequence-verifiable-units](./principles/sequence-verifiable-units.md): before/after bracket execution, clean-trunk baselining, story-ordered delivery (failing test first, subtraction before reshape, baseline before treatment, scaffold before feature), the prove-it-works plus build-the-lever complement. Example: stacking a skill split as leaves, then index, then monolith trim.
- [model-the-domain](./principles/model-the-domain.md): domain-as-data-structure framing (state machines, typed models, registries, reducer/event models, knowledge-owned modules, access-pattern collections), the do-not-force-an-abstraction caution, skipped-it signs (growing if/else chains, synced booleans, temporal decomposition). Example: skill metadata as one typed shape.
- [make-operations-idempotent](./principles/make-operations-idempotent.md): converge-to-the-same-end-state framing, read-state-and-diff-against-goal, the stale-residue rule, the three-question rerun test. Example: whips marker comments (`whips-pause`, `whips-run-log`) and `scripts/check-docs.sh`.
- [test-behavior-not-implementation](./principles/test-behavior-not-implementation.md): behavior-versus-implementation split, the two-imagined-edits test, contract-decides cases (mocked payloads, empty results, error types), the invariant note. Example: testing `scripts/check-docs.sh` against fixture diffs.
- [never-block-on-the-human](./principles/never-block-on-the-human.md): proceed-then-present, the reversible-versus-irreversible line, the self-healing note. Example: the whips pause list in `SKILL.md` section 5.
- [attack-the-premise](./principles/attack-the-premise.md): suspect-the-shared-premise trigger, write-it-down-and-test-it, follow-the-evidence branching, the stop rule. Upstream cross-links replaced with this repo rule numbers. Example: repeated check-docs gate failures.
- [boundary-discipline](./principles/boundary-discipline.md): boundaries-versus-inside split, parse-at-the-edge, the no-leaking-representation rule, the two test questions. Example: argument handling in `scripts/check-docs.sh`.
- [type-system-discipline](./principles/type-system-discipline.md): branded semantic primitives, parse-at-every-boundary for external data, deriving types from authoritative schemas; sum types and exhaustive matches foregrounded. Example: skill path identity and `scripts/check-docs.sh`.
- [build-the-lever](./principles/build-the-lever.md): first-unit-by-hand recipe learning, rerun-and-diff proof, deterministic lever over fan-out, the delegate brief as a shared artifact outside delegate write scope, the cited-it-means-a-file-is-in-the-diff bar. Example: `scripts/check-docs.sh` as the rerunnable lever reviewers run.
- [encode-lessons-in-structure](./principles/encode-lessons-in-structure.md): structural-fix-replaces-the-instruction corollary, prominent-instruction-with-failure-example fallback for judgment-bound lessons, second-occurrence trigger. Example: `scripts/check-docs.sh` plus the `.husky/pre-commit` hook carrying the README-mention rule.
- [migrate-callers-then-delete-legacy-apis](./principles/migrate-callers-then-delete-legacy-apis.md): same-wave caller migration with legacy API deletion, test updates to the new contract, deletion of pre-refactor detail tests, the no-external-backward-compat gate. Example: one-wave skill renames plus the dead-link check in `scripts/check-docs.sh`.
- [separate-before-serializing-shared-state](./principles/separate-before-serializing-shared-state.md): shared-mutable-state identification, owned-targets-default with merge-only-at-read-time, structural serialization as the checked fallback, instructions-are-not-concurrency-control. Examples: per-PR `.changeset/` files and per-slice worktrees.
- [outcome-oriented-execution](./principles/outcome-oriented-execution.md): end-state integrity over transitional stability, planned scoped reversible breakage, declared breakage zones, high-signal checks on touched areas, full verification at completion; the no-throwaway-compat rule from PRINCIPLES.md rule 16 folded in.
- [redesign-from-first-principles](./principles/redesign-from-first-principles.md): do-not-bolt-on, read-everything-first, the from-scratch question, full propagation through types docs and examples, whole-redesign-then-incremental-delivery with its option-value rationale.
- [experience-first](./principles/experience-first.md): delight over implementation convenience, every-control-must-be-justified, ship-less-ship-better, prototype-before-committing, tighten-the-core-loop, get-the-details-right, the wide user definition (end user, importing colleague, next maintainer), the sequence-vs-target split against foundational thinking.
- [explain-the-number](./principles/explain-the-number.md): write-the-decision-before-you-run, the why-not-double limiter question with its profile-or-counters bar, the rule-out-what-else roster (errors, skipped or cached work, code that never ran, untuned sides, noise, too-small-to-matter), the run-count-spread-limiter evidence bundle, the skip signals, the Prove It Works distinction; verify-bench pointer aimed at our skill.
- [guard-the-context-window](./principles/guard-the-context-window.md): bulk-to-delegates summaries-in-thread, phased sizing with file caps and turn budgets, the context-overflow Why (degraded reasoning, compression artifacts, stalled progress); PRINCIPLES.md rule 20 specifics (raw payloads never ride along, large-artifact parsing in a subagent) folded in.
- [exhaust-the-design-space](./principles/exhaust-the-design-space.md): competing prototypes before commitment, side by side comparison for novel UI and architecture, feel over logic for product choices. Carrier: the `craft-vocab` design-it-twice method plus the `craft-architect`, `craft-proto`, and `craft-arena` triggers.
- [foundational-thinking](./principles/foundational-thinking.md): data structures before logic, structural versus code-level decisions, DRY the structure not every line, the concurrency corollary, scaffold sequencing, coherent increments, subtraction before scaffolding. Carrier: the `craft-vocab` vocabulary and the `whips` "name the data shape first" and `architect` triggers.
- [laziness-protocol](./principles/laziness-protocol.md): consolidating repeated decisions behind one source of truth, minimizing the diff. Carrier: rule 1, the subtract-before-you-add file.
- [minimize-reader-load](./principles/minimize-reader-load.md): reader load as layers to trace plus state to hold, collapsing one-caller wrappers and pass-through layers, interface compression, shrinking state scope, naming invariants at the boundary, the thirty-second test. Carrier: the `craft-vocab` vocabulary.

## Upstream map

| Before (24 leaf skills, removed) | After |
|---|---|
| `principle-subtract-before-you-add` | `principles`, file `principles/subtract-before-you-add.md` |
| `principle-fix-root-causes` | `principles`, file `principles/fix-root-causes.md` |
| `principle-prove-it-works` | `principles`, file `principles/prove-it-works.md` |
| `principle-sequence-verifiable-units` | `principles`, file `principles/sequence-verifiable-units.md` |
| `principle-model-the-domain` | `principles`, file `principles/model-the-domain.md` |
| `principle-make-operations-idempotent` | `principles`, file `principles/make-operations-idempotent.md` |
| `principle-test-behavior-not-implementation` | `principles`, file `principles/test-behavior-not-implementation.md` |
| `principle-never-block-on-the-human` | `principles`, file `principles/never-block-on-the-human.md` |
| `principle-attack-the-premise` | `principles`, file `principles/attack-the-premise.md` |
| `principle-boundary-discipline` | `principles`, file `principles/boundary-discipline.md` |
| `principle-type-system-discipline` | `principles`, file `principles/type-system-discipline.md` |
| `principle-build-the-lever` | `principles`, file `principles/build-the-lever.md` |
| `principle-encode-lessons-in-structure` | `principles`, file `principles/encode-lessons-in-structure.md` |
| `principle-migrate-callers-then-delete-legacy-apis` | `principles`, file `principles/migrate-callers-then-delete-legacy-apis.md` |
| `principle-separate-before-serializing-shared-state` | `principles`, file `principles/separate-before-serializing-shared-state.md` |
| `principle-outcome-oriented-execution` | `principles`, file `principles/outcome-oriented-execution.md` |
| `principle-redesign-from-first-principles` | `principles`, file `principles/redesign-from-first-principles.md` |
| `principle-experience-first` | `principles`, file `principles/experience-first.md` |
| `principle-explain-the-number` | `principles`, file `principles/explain-the-number.md` |
| `principle-guard-the-context-window` | `principles`, file `principles/guard-the-context-window.md` |
| `principle-exhaust-the-design-space` | `principles`, file `principles/exhaust-the-design-space.md` |
| `principle-foundational-thinking` | `principles`, file `principles/foundational-thinking.md` |
| `principle-laziness-protocol` | `principles`, file `principles/laziness-protocol.md` |
| `principle-minimize-reader-load` | `principles`, file `principles/minimize-reader-load.md` |
