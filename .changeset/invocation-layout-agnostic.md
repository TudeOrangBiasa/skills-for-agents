---
"skills-for-agents": minor
---

Restructure the repo around invocation, not topic, and ship plain skills for universal agents. Skills move from `engineering/`, `productivity/`, `misc/`, and `in-progress/` into `skills/user-invoked/` and `skills/model-invoked/`, sorted by their frontmatter invocation. Nine skills that never fit the daily workflow are deleted (`to-questionnaire`, `handoff`, `scaffold-exercises`, `migrate-to-shoehorn`, `git-guardrails-claude-code`, `writing-beats`, `writing-fragments`, `writing-shape`, `claude-handoff`); the orphaned `handoff` references in `ask-matt` become a hand-written portable note. The Claude Code plugin (`.claude-plugin/`) and the duplicated `docs/` tree are removed: each `SKILL.md` plus its co-located files is the single source of truth, installed via skills.sh on any universal agent (Codex, pi, oh-my-pi, agy). The `docs/` path is excluded in `.okignore` so the removal sticks.
