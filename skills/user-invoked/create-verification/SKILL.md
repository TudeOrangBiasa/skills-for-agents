---
description: Generate a project-local skill that drives the app like a user (launch, doctor, drive, evidence, feature map), proven once. Use when a project has no scripted proof.
disable-model-invocation: true
name: create-verification
---
# Create verification

Generate a project-local verification skill that drives the app the way a user does, in any language or framework. Every serious project needs a scripted way to prove behavior: launch the real app, exercise a feature end to end, capture evidence. You write the generator output for the next agent, not a human: it gets read cold, mid-task, by an agent that has never seen the app. Run once per project; `/maintain-verification` keeps it honest afterward.

## 1. Interview the repo, not the user

Answer from the codebase, asking the user only what observation cannot settle:

- **Surface:** what a user actually touches (web UI, CLI/TUI, API, mobile, library). Several means picking the primary and noting the rest.
- **Run:** how the app starts locally (repo scripts, Makefile, README quickstart). Ports, env vars, seed data, auth.
- **Drive:** how an agent interacts programmatically. Existing harnesses first (Playwright/Cypress specs, expect scripts, PTY helpers, curl-able endpoints, debug ports); only then a generic recipe (browser/CDP for web, PTY/tmux session per drive for CLI/TUI, plain HTTP for services).
- **Observe:** capturable evidence (screenshots, transcripts, response bodies, logs, exit codes, DB state).
- **Isolate:** can two instances run side by side (ports, data dirs, profiles)? When not, the skill says so: refusing to double-drive a shared instance beats corrupting the session.

A checkout that does not build or start as-is gets fixed first (or reported precisely); a skill written against a broken base teaches wrong steps. Irrelevant missing assets may be created as marked verification scaffolding and removed in cleanup.

## 2. Generate the skill

Write `skills/verify-<app>/SKILL.md` in the target repo with frontmatter (`name: verify-<app>`, a `description` naming the app, the surface, and when to reach for it; without frontmatter it never registers) plus `agents/openai.yaml`, grounded in findings with no placeholders left:

- **Launch:** exact start command plus readiness signal (a log line, a prompt). Launch reaches usable from an empty data dir (migrations, seeds included); ready means usable, not merely answering. Include teardown. Short-lived CLI/TUI means no kept server: build once, drive each run in its own isolated session.
- **Doctor:** one read-only check answering "worth driving?" (process up, right build, our port, valid auth). Run first whenever anything looks off.
- **Drive:** harness recipe with this repo's real selectors and commands, stable handles (ARIA labels, data attributes, routes, prompt strings) over coordinates and tab order.
- **Evidence:** what to capture and where. Exercise the real user path, never internal setters or test-only endpoints; capture action plus resulting state, not the final screen alone; verify side effects (files, rows, messages) with the visible; mocks only where a production boundary already isolates. Dry-run or test modes get their skips verified by observation, never trusted by name.
- **Cleanup:** tear down created instances (kill what was started, never by process name). Cleanup removes instances and scratch, never evidence: proof survives at its named location.
- **Helpers:** shipped scripts stay executable with invocations shown in the body.

## 3. Seed the feature map

`features/README.md` index plus one file per user-facing feature (top 3-5 from routes, commands, menus, docs). Each file: what it is, how a user reaches it, how the harness drives it, what observable end state proves it, and gotchas. A journey missing a seed precondition reports failure; never weaken the journey to pass. The map is the maintained verification source: proof through one convenient entry stays incomplete while the map lists others.

## 4. Prove it before handover

Run its own instructions end to end once: launch, doctor, drive one mapped feature, capture evidence, clean up, then confirm the evidence survived at its named location. Fix failures (running generated cleanup after every failed iteration so nothing strands processes or ports). Unexecuted output is a draft, not a deliverable. Stand-in targets list every setup step the real target will not get; those stay unverified until a real-target run covers them.

## 5. Offer the loop

Point at `/maintain-verification` for upkeep. Suggest a cadence only when asked.
