---
"skills-for-agents": minor
---

feat: sweep named harnesses from setup-repo and gate generic wording. The unattended section and install-timers now detect any documented non-interactive agent CLI (the recorded agent command or opaque probe binaries) instead of a named install, and a new check-docs gate fails on denylisted harness names under skills, README, and docs unless scripts/harness-name-allowlist.txt exempts the path. Closes #190.
