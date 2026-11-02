# The canonical install block

One install story, one wording. `README.md` and `.changeset/*` must say **this** and nothing else. Change it here first, then propagate.

Skills install as editable files into the project via [skills.sh](https://skills.sh/TudeOrangBiasa/skills-for-agents). Use the whole-set form on `README.md`:

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take: make sure `setup-repo` is one of them.**

</canonical-block>

…and the single-skill form wherever one skill is named on its own.

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add TudeOrangBiasa/skills-for-agents --skill=<name>
```

```bash
npx skills update <name>
```

</canonical-block>

`skills@latest` is the pinned spelling in all three. It writes the skills into the repo as ordinary files that any agent loading SKILL.md folders reads the same way (Codex, pi, oh-my-pi, agy, and the rest are examples, never requirements). Nothing updates behind your back; pull the latest changes when you want them with `npx skills update`.

This repo ships plain skill files plus `agents/openai.yaml` per skill: keep every skill harness-agnostic, with no harness-specific plugin or packaging. `agents/openai.yaml` carries the display name, short description, and invocation policy any SKILL.md loader can read. There is no local symlink script: install only through the commands above.
