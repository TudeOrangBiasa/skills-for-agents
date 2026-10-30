---
"skills-for-agents": patch
---

fix(runner): batch open PR list to one fetch per repo per run and filter candidates locally, with one refresh after each processed issue so its new PR is still seen. Closes #87.
