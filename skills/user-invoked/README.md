# User-invoked

Skills that fire only when the human types their name. They orchestrate; they never fire each other. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

- **[create-formal-verification](./create-formal-verification/SKILL.md)**: Generate a project-local skill that proves a property where tests rarely reach, with coverage record and sync commit.
- **[maintain-formal-verification](./maintain-formal-verification/SKILL.md)**: Bring property checks back in line after code changes: drift or bug verdict per check.
- **[guide](./guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo.
- **[learn-catchup](./learn-catchup/SKILL.md)**: Catch up on everything in this chat since your last message, with an executive summary for each action item.
- **[learn-diff-gate](./learn-diff-gate/SKILL.md)**: Learning gate: explain the diff yourself, survive correction plus three why questions, then merge.
- **[learn-recall](./learn-recall/SKILL.md)**: Rebuild recent working context across chats into a tight capsule brief before starting or resuming.
- **[learn-reflect](./learn-reflect/SKILL.md)**: Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete skill edit or a docs update (taste, standards, glossary).
- **[setup-repo](./setup-repo/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[learn-restate](./learn-restate/SKILL.md)**: Fire this the moment an agent message doesn't land. The agent re-pitches it visually, in plain English, using your `GLOSSARY.md` vocabulary.
- **[report-issue](./report-issue/SKILL.md)**: File a bug, feature, or deprecation ticket from a quick notice, with repro and acceptance.
- **[whips](./whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed ready PR with evidence. Also picks up `ready-for-agent` issues and sorts review comments.
