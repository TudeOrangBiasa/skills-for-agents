---
description: "Write docs, RFCs, readmes, and commit messages to a layered standard: modes, sentences, STE, Global English. Use when writing or reviewing prose docs."
name: review-prose
---
# Technical writing

Write so a tired engineer understands on the first read. The `ship-pr` skill owns PR bodies; this skill owns everything else written: docs, RFCs, readmes, commit messages. `review-unslop` owns the slop-pattern catalog and applies to every doc this skill touches.

Three rules sit above everything: cut every word that does no work; use the short everyday word (a long word must buy its length with precision); when a rule makes a sentence worse, fix the sentence another way or leave it alone. The codebase is the word list: real symbols, files, flags, commands, never synonyms. No invented jargon; propose new offenders to `review-unslop`'s metaphor rule in the reply instead of editing that skill.

## Rhythm

Obeying every rule can still read machine-written. Mix sentence lengths on purpose; one thought per sentence but not one length per sentence; have a view where the mode allows it; be specific over sterile ("a column rename fails the build", not "schema changes can cause issues").

## Pick the mode first (Diataxis)

One document, one mode. Action plus learning is tutorial (learner builds visible results, "we", commands); action plus work is how-to (competent reader, forks allowed, named by task); understanding plus work is reference (dry, complete, mirrors the thing described); understanding plus learning is explanation (one bounded why, opinion allowed here only). Never mix modes: split and link instead.

## Sentences, STE, Global English

Talk to the reader as "you", present tense, actors named, instructions as commands, condition before instruction, common case first, no "simply/easy/quickly", headings carrying the point in sentence case, lists parallel, code in code font, serial commas. One instruction per sentence; split instructions past ~20 words; warnings before guarded steps; keep articles; one word per action; commands never narrated, never passive; plain verbs over -ing. Disambiguate placement ("only fails on growth" vs "fails only on growth"); break noun strings; every pronoun points at one obvious noun; no dropped verbs; repeat articles preventing misreads; periods over semicolons; new sentence over em dash; parentheses hold full units; no slashes; one name per thing everywhere; no idioms.

## Repo specifics

PR descriptions and commit messages get every layer except Diataxis; a PR body stays a sub-minute briefing with evidence linked, never pasted. Product UI strings follow product copy guidelines, not this skill. Indent code with tabs, use real paths, keep every count or tree claim true at the landing commit with its regen command.
