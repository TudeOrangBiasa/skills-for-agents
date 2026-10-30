---
name: principle-encode-lessons-in-structure
description: "Apply when you catch yourself writing the same instruction a second time, or notice a recurring correction. Build the guardrail (lint, flag, check, script) instead of more text."
disable-model-invocation: true
---

# Encode Lessons in Structure

The second time you write the same instruction, stop writing text and build the guardrail.

A lint, a metadata flag, a runtime check, a script. If the lesson needs judgment and cannot be encoded, make the instruction prominent with an example of the failure mode. A structural fix replaces the instruction, never joins it: when the guardrail lands, delete the text it made redundant.

## Why

Text does not enforce itself. Every reader must notice the instruction, remember it, and apply it correctly under time pressure; every new contributor starts from zero. A guardrail pays once and then holds for every future change, including changes made by people who never read the doc. Repeated corrections are the signal: the first correction teaches, the second proves the teaching did not stick and the structure must carry it.

## When it applies

- The same instruction or correction appears twice. Twice is the trigger, not ten times.
- The lesson is checkable: it can become a lint rule, a CI gate, a schema flag, a pre-commit hook, or a script with a pass/fail exit.
- The lesson needs judgment and resists encoding: keep it as text, but make it prominent and attach a concrete example of the failure it prevents.

## Example in this repo

The rule that every new skill must be mentioned in both READMEs is not carried by prose alone: `scripts/check-docs.sh` fails the commit when a mention is missing, and `.husky/pre-commit` runs that script on every commit. The instruction shrank to a pointer; the hook carries the lesson.
