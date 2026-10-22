---
"skills-for-agents": minor
---

`whips` now opens every PR ready instead of as a draft, following upstream pstack: landing follows the risk tier with the verdict (not draft status) gating the merge, `risk:high` requires an independent PASS or PASS+NOTES verdict comment plus a human merge, and the docs gate fails on `gh pr create --draft` or an `always a draft` instruction under `skills/`.
