# Vendor pstack-claude verbatim instead of porting skill by skill

Evaluation on Remindly plus OmniRelief sessions showed the local pack losing to upstream on five points: routing predictability, template completeness in setup, prose rigor, verification by default, and router maturity. Four port rounds (Gates line, setup Definition of Done, guide Triggers, prose rules, project-playbook mechanism) narrowed the gap but each port added permanent maintenance: every upstream change needs a manual re-port plus budget Tetris, and the whips pack sat at exactly 3200 of 3200 tokens with zero headroom.

We vendor `plugins/pstack/skills` (68 skills) plus `plugins/pstack/agents` (4 agents) verbatim at pin `1ab6b82`. Local behavior deltas end except the repo shell (tests, changesets, install story) and `.agents/playbooks/` project extensions, which ride the very mechanism we pulled. The next resync diffs `skills/` against the new pin instead of porting file by file.

Consequences:

1. Breaking major release. Skill names, router, triage, Gates, and setup flows now follow upstream; every machine reinstalls after merge.
2. Removed local lessons have no upstream equivalent: triage labels, Gates proof blocks, consumer setup scaffolding, report-issue, setup-hooks. They stay recoverable from git history, and the strongest one (visual PR evidence) already returned as a project playbook.
3. Prose and harness gates now skip `skills/` and `agents/` (vendored verbatim) and cover only writing this repo owns.
