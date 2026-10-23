Skills live in `skills/user-invoked/` (human types the name) and `skills/model-invoked/` (agent may fire it). Adding or changing a skill invocation: read [.agents/invocation.md](./.agents/invocation.md).

Writing or editing any SKILL.md, reference file, or README entry: read [.agents/writing-docs.md](./.agents/writing-docs.md) (README entries, guide router upkeep, docs placement).

Install wording or harness support: copy from [.agents/install-block.md](./.agents/install-block.md), never paraphrase.

Changesets, releases, and version bumps: follow [.agents/releasing.md](./.agents/releasing.md).

Hard-to-reverse decisions for this repo live in [.agents/adr/](./.agents/adr/) (skills that say `docs/adr/` mean the user repo; here read `.agents/adr/`).

Merging: in this repo, a `risk:high` PR may be merged by the delegated agent only after an independent PASS or PASS+NOTES verdict on the current head.

No em dashes anywhere in this repo prose; rewrite the sentence instead of substituting a character. `scripts/check-docs.sh origin/main` checks this and the rules above before every PR.
