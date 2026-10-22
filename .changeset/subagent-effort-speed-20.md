---
"skills-for-agents": minor
---

Subagent model choice now includes optional effort and speed: `models.md` gains Effort and Speed columns (blank means the role's model as-is), `setup-meta` asks about them only when the harness names effort levels, and `whips` shifts effort up for the hardest work and down for routine work with fast mode reserved for urgent runs. Verifier roles are never shifted down. Also fixes the VIBE-MAPPING brief reference to point at `/whips` section 6.
