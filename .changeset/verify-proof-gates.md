---
"skills-for-agents": minor
---

Whips tasks are proof-gated: run the repo verification skill or verifier command and record its output before reporting done, with no-proof work marked NOT VERIFIED and never auto-merging. Abstract read-only review is off the ship path: review-code and review-adversary are explicit-ask only, run-proven findings only, and the high tier verifies empirically with verify-blast plus a code-running rerun. Setup-repo records a later verifier as pending so the next whips run waits on verify-new.
