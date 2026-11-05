Skills live in `skills/user-invoked/` (human types the name) and `skills/model-invoked/` (agent may fire it). Adding or changing a skill invocation: read [.agents/invocation.md](./.agents/invocation.md).

Writing or editing any SKILL.md, reference file, or README entry: read [.agents/writing-docs.md](./.agents/writing-docs.md) (README entries, guide router upkeep, docs placement).

Install wording or harness support: copy from [.agents/install-block.md](./.agents/install-block.md), never paraphrase.

Changesets, releases, and version bumps: follow [.agents/releasing.md](./.agents/releasing.md).

Hard-to-reverse decisions for this repo live in [.agents/adr/](./.agents/adr/) (skills that say `docs/adr/` mean the user repo; here read `.agents/adr/`).

Merging: in this repo, a `risk:high` PR may be merged by the delegated agent only after an independent PASS or PASS+NOTES verdict on the current head.

Prove the pack with `npm test` (runs `scripts/test-all.sh` across check-docs, aliases, and every stub suite) before every PR.

Style defaults (ID and EN):
1. No em dashes.
2. No "not only X but also Y" construction, in either language.
3. Numbered or lettered lists only, no bullets.
4. No "X arrow Y" construction, spell the relation.
5. Direct honest tone, no filler.
