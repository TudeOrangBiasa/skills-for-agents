Skills are organized into two folders under `skills/`, split by who can invoke them:

- `user-invoked/`: fire only when the human types their name (`disable-model-invocation: true` plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`). They orchestrate; a user-invoked skill may invoke model-invoked skills, but never another user-invoked one.
- `model-invoked/`: the agent can fire on its own when the task fits, or the human can type by name. They hold reusable discipline and shared reference.

Every skill must have a reference in the top-level `README.md`, with the skill name linked to its `SKILL.md`.

Install commands are copied verbatim from [.agents/install-block.md](./.agents/install-block.md). This repo ships plain skill files plus `agents/openai.yaml` per skill, and targets universal agents (Codex, pi, oh-my-pi, agy, and anything that reads skills the same way). There is no Claude Code plugin and no harness-specific packaging: keep every skill harness-agnostic.

Each folder has a `README.md` that lists every skill in the folder with a one-line description, with the skill name linked to its `SKILL.md`. There is no separate docs tree: each `SKILL.md` plus its co-located reference files is the single source of truth. Never duplicate skill content into a second docs location.

Every `SKILL.md` carries its invocation in frontmatter. See [.agents/invocation.md](./.agents/invocation.md).

[`guide`](./skills/user-invoked/guide/SKILL.md) is the router that maps every user-reachable skill and how they relate. Whenever you add, rename, remove, or change how a user-reachable skill fits the flows, re-read `guide`'s `SKILL.md` and update it so the map stays accurate: a new skill it never mentions, or a stale one it still routes to, is a router that lies.

To (re)link every skill into the local harness skill directories (`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each entry is a symlink into this repo, so a `git pull` keeps installed skills current; re-run the script after adding, removing, or renaming a skill.

No em-dashes anywhere in this repo's prose (`SKILL.md` files, `README.md`, `CHANGELOG.md`, ADRs, changesets, code comments). Where a sentence reaches for one, rewrite it instead with a comma, colon, period, parentheses, or a conjunction, whichever the sentence actually wants; never do a blind character substitution.
