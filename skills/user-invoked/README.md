# User-invoked

Skills that fire only when the human types their name. They orchestrate; they never fire each other. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

- **[discuss](./discuss/SKILL.md)**: A relentless interview to sharpen a plan or design.
- **[discuss-with-docs](./discuss-with-docs/SKILL.md)**: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
- **[explain-diff-before-merge](./explain-diff-before-merge/SKILL.md)**: Learning gate (deprecated from the merge path 2026-10-31; execute path is `/whips` only).
- **[create-verification](./create-verification/SKILL.md)**: Generate a project-local skill that drives the app like a user, with feature map, proven once.
- **[create-formal-verification](./create-formal-verification/SKILL.md)**: Generate a project-local skill that proves a property where tests rarely reach, with coverage record and sync commit.
- **[maintain-formal-verification](./maintain-formal-verification/SKILL.md)**: Bring property checks back in line after code changes: drift or bug verdict per check.
- **[statechart](./statechart/SKILL.md)**: Check a TLA+ model and draw it as a Mermaid statechart with shortest bug paths.
- **[guide](./guide/SKILL.md)**: Ask which skill or flow fits your situation. A router over the skills in this repo.
- **[handoff](./handoff/SKILL.md)**: Compact the conversation into a handoff doc for another session to continue.
- **[ketchup](./ketchup/SKILL.md)**: Catch up on everything in this chat since your last message, with an executive summary for each action item.
- **[learn-while-delegating](./learn-while-delegating/SKILL.md)**: Delegate beyond your reach and learn it: noted gaps, sliced diffs, three concepts, teach handoff.
- **[recall](./recall/SKILL.md)**: Rebuild recent working context across chats into a tight capsule brief before starting or resuming.
- **[deepen](./deepen/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then discuss through whichever one you pick.
- **[worklog](./worklog/SKILL.md)**: Interview me about specs for the workflows I want to build, within this workspace.
- **[maintain-verification](./maintain-verification/SKILL.md)**: Periodic upkeep for a project's verification skill: source wave plus live pass, at most one PR.
- **[runner](./runner/SKILL.md)**: Run `ready-for-agent` issue queues on any schedule through `/whips` intake, landing per risk tier, with the agent and model you pick at setup.
- **[retro](./retro/SKILL.md)**: Conduct a retrospective on a coding session: refresh meta docs, kill rot, surface patterns.
- **[reflect](./reflect/SKILL.md)**: Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete skill edit.
- **[setup-meta](./setup-meta/SKILL.md)**: Configure this repo for the skills: tracker, labels, domain docs, DESIGN.md, coding standards, commit/PR formats, pre-commit tooling. Run once per repo.
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**: Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolders and reachable only through its entry-point files.
- **[sharpen](./sharpen/SKILL.md)**: Sharpen a task, issue, or prompt before work starts: deeper, not bigger, then a rewritten prompt ready to run.
- **[showcase](./showcase/SKILL.md)**: Show me what you built: diff, running result, and proof in one visual pass.
- **[teach](./teach/SKILL.md)**: Teach the user a new skill or concept, within this workspace.
- **[to-spec](./to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed.
- **[to-tickets](./to-tickets/SKILL.md)**: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges.
- **[triage](./triage/SKILL.md)**: Move issues and external PRs through a state machine of triage roles, categorise, verify, interview if needed, and write agent-ready briefs.
- **[wait-what](./wait-what/SKILL.md)**: Lost in what the agent just said or built: get it re-pitched visually.
- **[wayfinder](./wayfinder/SKILL.md)**: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way to the destination is clear.
- **[whips](./whips/SKILL.md)**: Route any non-trivial task through one entry: match a playbook, drive HIT skills plus subagents, open a reviewed ready PR with evidence. Also picks up `ready-for-agent` issues and sorts review comments.
