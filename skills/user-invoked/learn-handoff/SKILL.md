---
description: Compact the conversation into a handoff doc for another session to continue. Use between grilling and teaching, across harnesses, or forking side tasks.
disable-model-invocation: true
name: learn-handoff
---
Compact the current conversation into a handoff document so a fresh agent or session can continue the work. Save to the OS temp directory (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows), never the workspace. Classic use: handing a grilling session to `/learn-teach` and back (learn it, return, pick up where you left off).

Include a "suggested skills" section naming which skills the next agent should reach for. Reference artifacts by path or URL (specs, plans, ADRs, issues, commits, diffs) instead of duplicating them. Redact secrets and personal data. An argument narrows the doc to what the next session focuses on.
