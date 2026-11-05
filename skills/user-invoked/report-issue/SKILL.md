---
description: "File a bug, feature, or deprecation ticket on this repo from a quick notice."
disable-model-invocation: true
name: report-issue
---

# Report issue

You noticed something worth fixing or building in the skills-for-agents repo (TudeOrangBiasa/skills-for-agents, https://github.com/TudeOrangBiasa/skills-for-agents/issues). This skill turns the notice into one ticket on that tracker, using the template that fits (bug, feature, deprecation). One notice is one ticket with one type. Never file a bare complaint: every ticket carries a repro or a what-to-build plus testable acceptance, or it stays unsent.

## What it does

Takes a rough notice ("X looks broken", "we should add Y", "Z is dead weight") and produces a filed ticket with the right template fields filled: type, repro or what-to-build, Kompleksitas, acceptance, parent and blocked-by where they exist. The defining constraint: the interview that fills the template happens before any `gh` call, so the tracker never receives a foggy ticket.

## When to reach for it

You invoke this by typing `/report-issue`, and the agent will not reach for it on its own. Reach for this when you spot a defect, a missing behavior, or dead weight in this repo and want it tracked with repro plus acceptance. For working an existing backlog instead, use `ship-triage`.

## Pick the template first

Match the notice to one template in `.github/ISSUE_TEMPLATE/`, never blend them:

1. Something broken: `bug.yml`. Needs perilaku sekarang vs yang diharapkan plus langkah repro minimal.
2. Something new or better: `feature.yml`. Needs what to build as end-to-end behavior plus optional risk with one RISK rule.
3. Something to remove: `deprecation.yml`. Needs what gets removed, its replacement, plus proof the removal is clean (grep yang harus kosong, link yang harus resolve).

## Interview before filing

Ask only for the fields the chosen template requires and the notice did not supply yet. One round at a time, concrete questions, no padding. Required in every ticket: one `## Kompleksitas` line (the repo term, spelled with K; files plus verification steps, e.g. O(1) file, 1 repro test) and testable acceptance criteria (what gets verified and how). A ticket missing either stays a draft in chat, never filed.

For a bug, verify the claim first when the repro is cheap: check the code path or run the failing step. Say confirmed with the path, or failed, or needs detail. For a feature, check redundancy first: search for an existing implementation by domain concept. If built already, say so and file nothing.

## File it

Target the skills-for-agents tracker explicitly: every `gh` call passes `--repo TudeOrangBiasa/skills-for-agents`, because this skill may run from a consumer repo checkout. Duplicate search is scoped there too (`gh issue list --repo ... --search ...`), never the current directory remote. Create one issue with `gh issue create --repo TudeOrangBiasa/skills-for-agents`, title prefixed `[bug]:`, `[feat]:`, or `[deprecate]:` per template, labels from the template (`needs-triage`, `risk:low`; raise risk only with evidence). Report back the issue URL plus number. Never batch two notices into one ticket; never open a PR from here (that is `whips` work once triage ripens it).

## Common questions

**Does this replace ship-triage?**
No. This files the ticket; `ship-triage` ripens it to agent-ready. Filed tickets land in `needs-triage` by default.

**What if the notice is already tracked?**
Search open issues first by concept, not wording. If found, point at it and file nothing.

**What if I am unsure about Kompleksitas?**
Estimate in verification steps (files touched, tests run, gh calls). One honest line beats a precise-looking fiction.

## It's working if

1. Every filed ticket has a repro or what-to-build plus acceptance, checkable on the issue page.
2. No ticket lands without a Kompleksitas line.
3. Duplicates get pointed at instead of filed twice.

## Where it fits

Role: standalone reach-for-it-anytime reporter feeding the triage queue (`report-issue` files, `ship-triage` ripens, `whips` builds). Neighbours: `ship-triage` because it consumes what this files, linked repo-relatively at [ship-triage](../ship-triage/SKILL.md); `plan-tickets` because multi-ticket breakdowns belong there, linked at [plan-tickets](../plan-tickets/SKILL.md). The map: [guide](../guide/SKILL.md).
