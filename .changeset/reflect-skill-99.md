---
"skills-for-agents": minor
---

feat(reflect): port session-to-skill learning loop from pstack, no ketchup-video yet

Adds `/reflect`: three parallel reviewers (judgment, tooling, divergent) mine the session transcript and a synthesizer routes each accepted learning to a small skill PR. Transcript lookup stays in this workspace's harness store with a digest fallback, reviewers follow the repo model map (`reflect-reviewer`, `reflect-synthesizer`) with a two-pass fallback on single-model harnesses, and the guide routes reflect vs retro vs ketchup. `ketchup-video` is skipped in this PR: OMP has no reliable authored-slide video render path (see the PR description note); text `/ketchup` stays the catch-up path.

Closes #99
