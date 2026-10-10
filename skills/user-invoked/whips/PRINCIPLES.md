# Principles

Eight rules behind the `/whips` triggers. In the reply, name each one that changed a decision and the choice it changed.

1. **Subtract before you add.** Delete dead code, one-caller wrappers, and redundant checks first. Then build the smallest change that solves the problem on the simpler base. A speculative "might help" change gets reverted.
2. **Fix the root cause.** Reproduce first, then ask why until you reach the cause. A guard that silences the symptom is not a fix.
3. **Prove it works on the real artifact.** Run the app, the endpoint, the migration, or the page the user will hit. "It compiles" and "CI is green" are inputs, not proof.
4. **Small verifiable units.** Each commit and each PR ends in a check that passes on its own. Verify one unit before starting the next, and order them so the sequence proves itself.
5. **Model the domain.** Name the data shape before logic: a state machine, a typed model, a table or registry. Scattered conditionals that repeat one assumption mean the shape is missing.
6. **Make operations idempotent.** Commands, migrations, jobs, and loops reach the same end state when they run twice or crash halfway.
7. **Test behavior, not implementation.** Call the code the way its users do and assert a literal expected result. A test that still passes when the code returns nothing gets rewritten or deleted.
8. **Never block on the human for reversible work.** Proceed, show the result, let the human correct course. Save questions for the pause list in `SKILL.md` section 5 and for product calls no experiment can settle.
