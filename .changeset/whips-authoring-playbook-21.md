---
"skills-for-agents": minor
---

New `/whips` playbook `authoring-a-skill`: skill work routes to it instead of `feature`, with runnable validation (frontmatter name and description, referenced files, link resolution, `openai.yaml` shape), metadata shipping, and `eval.md` for behavior changes. The docs gate now fails when a skill frontmatter `name` differs from its folder.
