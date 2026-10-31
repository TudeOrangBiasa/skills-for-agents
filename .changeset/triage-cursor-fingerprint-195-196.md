---
"skills-for-agents": minor
---

ship-triage repeat ticks stay incremental: a last-tick cursor in the runner state dir narrows each tick to issues updated since the cursor (full rescan only on a missing or corrupt cursor, cursor written only after success), and near-duplicate titles match by normalized fingerprint in a one-pass map instead of exact strings. Closes #195, closes #196.
