---
"skills-for-agents": minor
---

feat: ship-runner setup is harness-agnostic and claims survive races. Setup drops the preset table and harness-named detection paths: it reads the agent command and model from flags, from the consumer repo's docs/agents/harness.md (new setup-repo template), or by asking the user, then persists them to the consumer repos with a thin host override. Issue claims now re-read assignees and claim markers after the assign write and back off with claim_lost when another runner holds or beat the claim, so a cross-machine race launches at most one agent. Closes #188, closes #194.
