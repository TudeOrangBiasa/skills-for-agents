---
name: learn-reflect
description: "Mine this session for durable learnings with three parallel reviewers, and route each accepted one to a concrete edit on an existing skill. Use when the user says reflect."
disable-model-invocation: true
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

Invoke when the user says "learn-reflect" or "/learn-reflect". Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## 1. Locate the active transcript

Before fanning out, find this conversation's transcript in the harness transcript store. Read only this workspace's store: the current project's session files (on OMP, `~/.omp/agent/sessions/` under this project's bucket; other harnesses name their own store).

Match the file whose opening user prompt is this conversation's first message. Never glob across sibling buckets or other projects: that crosses workspace boundaries and reads private chats from unrelated projects. If no file matches, or the harness keeps no readable store, pass a tight digest of the session instead (what was tried, what failed, what got corrected, what was decided and why). A digest plus the PR diff or run log you already have beats a guessed transcript path.

## 2. Spawn three reviewers in parallel

One message, one batch of three reviewer spawns through the harness subagent tool. Reviewers need their normal tool access to look up the tickets, chat threads, and observability traces the transcript references; a stripped tool set weakens them, so do not run them read-only.

Models follow the repo model map: `learn-reflect-reviewer` for the three reviewers (missing file or row means the parent model). No harness-specific agent type and no model pin appear in the spawn; copy the role id through unchanged. With a single model, run two passes (find, then challenge the findings). Reviewers never edit files; they return findings in their response body.

| Lens | Prompt template |
|---|---|
| Judgment | `agents/judgment-reviewer.md` |
| Tooling | `agents/tooling-reviewer.md` |
| Divergent | `agents/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked.

## 3. Synthesize

One spawn on the `learn-reflect-synthesizer` role (missing file or row means the parent model), same tool access as the reviewers: it spot-verifies citations through lookup tools. Pass `agents/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. It returns an Accepted / Rejected / Backlog list.

## 4. Structural enforcement check

Move any Accepted item that a lint rule, script, metadata flag, or runtime check would enforce more reliably to Backlog. See the `principles` skill file `encode-lessons-in-structure`.

## 5. Apply

Present the synthesizer's full Accepted / Rejected / Backlog output and wait for explicit approval before applying any Accepted edit. The user picks the subset and may redirect routings. Skill changes affect every future agent in the org. Do not auto-apply.

File each Backlog item to your team's devex or backlog tracker without waiting. Only the Accepted list waits for approval.

Never edit a skill inside a vendored or cached copy. Before approval, show each edit's destination: this repo's `skills/<bucket>/<skill>/` path for repo skills, or the target repo's skill path for skills living elsewhere. After approval, edit that path directly.

Follow each approved row's Routing exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): the parent does it directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): draft it through the whips `authoring-a-skill` playbook and its validate loop.
- `tune description: <skill path>` (the skill exists but did not trigger when it should have): retune its description through the same playbook.
- `new skill via create-skill: <kebab-name>`: hand creation to the same playbook. Do not invent the shape ad hoc.

Each accepted learning becomes a small PR to its target skill (one skill per PR, small ordered commits) closed through the whips `opening-a-pr` playbook, or a listed diff when the user wants to land it by hand. If this repo ships a SKILL.md validator, run it on every touched skill before declaring done.

## 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
