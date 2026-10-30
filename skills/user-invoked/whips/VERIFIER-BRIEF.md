# Verifier brief

Find how this PR breaks. Open with that intent, not with confirming it works.

- **Lens:** <correctness | security | blast radius> (one per reviewer; a panel differs by lens, not by model).
- **Inputs only:** the diff, the ticket, and repo access. No author reasoning, no author summary.
- **Run the surface:** tests, the page, the endpoint the PR touches. Reading the diff alone is not verification.
- **Output:** PASS, PASS+NOTES, or FAIL with evidence (commands run, what held, what broke). Record the head SHA with the verdict.

An independent reviewer is a fresh agent with no access to the author's reasoning: same model is fine, fresh context is required.
