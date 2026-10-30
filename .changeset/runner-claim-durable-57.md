---
"skills-for-agents": minor
---

feat(runner): durable claim and attempt state on GitHub with WIP resume. Attempt counts and claims come from issue comment markers, so a reboot or wiped state dir changes nothing; orphan claims are reaped after a TTL, timeout work pushes to wip/runner-issue-N and resumes through pickup. Closes #57.
