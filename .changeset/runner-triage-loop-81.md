---
"skills-for-agents": minor
---

feat(runner): on-loop issue triage for consumer repos. New `runner.sh triage` tick labels up to 3 intake issues per repo per tick (unlabeled, needs-triage, replied needs-info), oldest first, with the repo vocab from docs/agents/triage-labels.md: complete briefs get ready-for-agent plus an honest risk label, thin briefs get needs-info with one concrete question, product calls get needs-human with the triage-decision marker, clear duplicates get duplicate and stay open. Never closes, never merges, never writes code. Bound: 1 list call plus at most 4 calls per triaged issue, zero agent spawns unless opted in, stop-file kill switch, --dry-run prints decisions. New whips playbook issue-triage-loop.md plus bot-triage.md reference folded in from #72, and a triage job in the setup-meta timer template. Closes #81.
