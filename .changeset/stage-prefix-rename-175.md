---
"skills-for-agents": minor
---

rename(skills): 53 skills move to the stage-prefix scheme (#175), plus `ketchup-video` riding along as `learn-catchup-video`. Keeps: `create-formal-verification`, `guide`, `maintain-formal-verification`, `whips`. Old names resolve for one release via `docs/aliases.md` (tested by `scripts/test-aliases.sh`), then the aliases are deleted. `docs/upstream-map.md` maps every local name to its upstream source (pstack/Matt/other) so sync diffs stay mechanical. Consumer repos migrate by renaming installed folders per the alias table or re-running `npx skills add` and picking the new names.
