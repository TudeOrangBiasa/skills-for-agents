---
"skills-for-agents": patch
---

`/whips` playbooks now name only skills that ship in this repo. Grounding and lineage steps run as explorer subagents and git tracing instead of the pstack-only `how` and `why`; design-twice runs through `codebase-design`, the contested-design second opinion through `code-review` plus a second model, and blast radius is an inline step. Steps that name a user-invoked skill (`/wayfinder`, `/to-spec`, `/to-tickets`, `/deepen`, `/break`, `/discuss-with-docs`) are now explicit human gates, since no skill can fire a user-invoked one. Wayfinder handoff builds each ticket through `/whips` instead of `/implement`.
