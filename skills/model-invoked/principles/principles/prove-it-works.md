# Prove It Works

Run the app, the endpoint, the migration, or the page the user will hit. "It compiles" and "CI is green" are inputs, not proof. Verify every task output by checking the real thing directly; never infer from proxies, self-reports, or cached representations.

## Why

Unverified work has unknown correctness. Indirect verification feels cheaper than direct observation: file mtimes, output freshness, agent self-reports, cached screenshots. But acting on a wrong inference costs far more than checking the source once.

## When it applies

After completing a task, before declaring done. Check the real thing, not a proxy:

- Check process liveness directly, not indirectly through derived state.
- Read the actual value, not a cached or derived representation.
- When verification fails, suspect the observation method before suspecting the system.

Script the check when you can. The strongest proof is a deterministic script that re-runs the same comparison, not a one-time eyeball. Write the script, run it, and keep its output as an artifact a reviewer can re-run instead of trusting your word.

## Example in this repo

A change to `scripts/check-docs.sh` is proven by running it against a fixture diff that should fail each touched check, not by reading the script and judging it correct. Stage a docs change that violates the rule you edited, run `./scripts/check-docs.sh`, and watch it fail the way you expect; then fix the fixture and watch it pass. The passing and failing runs are the proof; the green shell prompt after an unrelated edit is not.
