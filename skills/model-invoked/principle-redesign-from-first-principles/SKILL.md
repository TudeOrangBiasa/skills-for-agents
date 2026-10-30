---
description: 'Integrate a new requirement by redesigning as if it had been foundational from day one: read every affected file, propagate through types, docs, and examples, then deliver incrementally.'
name: principle-redesign-from-first-principles
disable-model-invocation: true
---
# Redesign From First Principles

A new requirement is not bolted on; redesign as if it had been foundational from day one.

## The rule

Read every affected file, ask what you would build from scratch with this requirement, propagate through types, docs, and examples, then deliver incrementally.

## Why

A bolted-on requirement stacks new assumptions on top of old ones plus the adapter gluing them together. Each layer looks cheap alone, but every later change pays for all of them: the design stops being one coherent idea and becomes archaeology. Redesigning from first principles keeps it one idea. The upfront reading costs hours; the avoided adapters save weeks.

This is the method for preserving option value when a change lands in an existing design: a coherent base stays easy to change again.

## When this applies

Use this when a new requirement interacts with an existing design: a new field in a shared contract, a new trigger in a playbook, a new agent in a roster. The more references the change touches (types, docs, examples, rationale), the more this pays off.

Do not use it for isolated additions with no interaction, or for typo-level fixes where there is no design to rethink.

## How to apply

1. Read all affected files and understand the current design before proposing anything.
2. Ask: if we were writing this from scratch with this new requirement, what would we build?
3. Propagate the answer through every reference: types, docs, examples, rationale sections. A redesign that leaves stale docs behind is a bolt-on with better marketing.
4. Think about the whole redesign, then deliver it incrementally: full picture first, sequenced landings after.

## Example in this repo

Adding a new check to the docs gate: read the gate script, the skill READMEs, and the contributing docs first; design the gate as if the check had always existed (message format, failure checklist, escape hatch); update script, docs, and examples together; land it in sequenced commits rather than one giant diff.

## Say it in the reply

Name this principle and the choice it changed: what you redesigned instead of bolting on, and which references you propagated it through.
