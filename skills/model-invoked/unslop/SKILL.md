---
name: unslop
description: Cut AI tells from prose before it ships. Use when writing or editing a reply, PR body, commit message, tracker comment, README, doc, or skill.
---

# Unslop

Edit text so it reads like a person wrote it for this project. Keep the meaning and the intended tone. Write clean as you draft; a cleanup pass after drafting misses most of these.

## Process

1. Scan the text for the patterns below.
2. Rewrite each hit. When a sentence only carries a pattern, delete the sentence.

## Patterns

Rule numbers are stable ids that other skills may cite. A removed rule leaves a gap.

### Content

1. **Superficial -ing tails.** "highlighting...", "ensuring...", "reflecting...", "showcasing...". Delete them or state the concrete fact.
2. **Vague attribution.** "Experts believe", "Some argue". Name the source or delete.
3. **Generic conclusions.** "The future looks bright." State the next step or the fact.

### Words

4. **AI vocabulary.** Additionally, crucial, delve, enhance, fostering, garner, intricate, landscape (abstract), pivotal, robust, seamless, showcase, testament, underscore, vibrant. Use the plain word.
5. **Fancy "is".** "serves as", "stands as", "boasts", "features". Write "is" or "has".
6. **Plain words over fancy ones.** Use, help, many, if, not utilize, facilitate, numerous, in the event that.
7. **Abstract metaphor nouns.** Substrate, wedge, vector, north star, flywheel, paradigm, scaffolding (as a metaphor). Name the concrete thing.
8. **Filler.** "In order to" is "to". "Due to the fact that" is "because". "It is important to note that" goes.
9. **Hedging stacks.** "could potentially possibly" is "may".
10. **Adverb props.** "runs quickly" is the number or "is fast". "Significantly improves" is the measured change.

### Shape

11. **"Not just X, but Y."** State the point directly.
12. **Forced threes.** Use the natural count of items.
13. **Synonym cycling.** Pick one name for a thing and repeat it.
14. **Em dashes.** None. Rewrite with a comma, colon, period, parentheses, or a conjunction, whichever the sentence wants.
15. **Colon as a mid-sentence connector.** Fine before a list or example; elsewhere, let the sentence stand.
16. **Bold everywhere.** Bold only a label that starts a list item and ends in a period, or a term being defined.
17. **Title Case Headings.** Use sentence case.
18. **Decorative emoji and curly quotes.** Remove emoji; use straight quotes.

### Talking to the reader

19. **Chatbot phrases.** "I hope this helps", "Let me know if", "Certainly!", "Great question". Delete.
20. **Say what it does.** Replace a feeling ("the data stays close at hand") with the mechanism or a number ("`find()` reads from the cache first"). A sentence that could sit unchanged in another project's docs says nothing about this one.
21. **One idea per sentence.** Split a sentence the reader has to reread.
22. **Active voice.** Name the actor: "the job retries the request", not "the request is retried".
23. **No over-compression.** Keep articles and verbs. Spell out arrows and private abbreviations.
24. **No phase-narrating comments.** A code comment says why the code cannot show, never "Step 1: add the card".
