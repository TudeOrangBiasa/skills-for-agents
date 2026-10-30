---
description: 'Apply when context fills up: large outputs, long files, repeated reads, fan-out planning. Route bulk to delegates, keep summaries in this thread, never let raw payloads ride along.'
name: principle-guard-the-context-window
disable-model-invocation: true
---
# Guard the Context Window

Bulk goes to delegates, summaries stay in this thread; raw payloads never ride along.

## The rule

Size phases, cap files per phase, set turn budgets. Parse large artifacts in a subagent and keep only the reduced finding.

## Why

Context overflow degrades reasoning quality, creates compression artifacts, and halts progress. Once the window fills with raw payloads, the agent starts forgetting the plan, re-reading files it already read, and making decisions on truncated evidence. A reduced finding costs one delegate call; a flooded window costs the whole session.

## When this applies

Use this when context is filling up: large outputs, long files, repeated reads, fan-out planning, multi-file audits. If you are about to paste a long log or read a dozen files to answer one question, this principle is already talking to you.

Do not use it to avoid reading the code a decision actually needs: delegate the bulk, but verify the reduced finding against the source before acting on it.

## How to apply

1. Size phases and cap scope: limit files per phase, set turn budgets, account for mechanism costs.
2. Route bulk to delegates: one subagent per slice, each returning a summary, never the raw payload.
3. Keep summaries in this thread: decisions, findings, and pointers back to sources, not the sources themselves.
4. Parse large artifacts in a subagent: long logs, full test outputs, and wide audits get reduced before they reach the main thread.

## Example in this repo

Auditing every skill for stale cross-references: fan out one delegate per bucket, each returning only a table of broken links; the main thread merges five tables instead of reading fifty files. The full file contents never ride along.

## Say it in the reply

Name this principle and the choice it changed: what bulk you delegated, and what summary stayed in the thread.
