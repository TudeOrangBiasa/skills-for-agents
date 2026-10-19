---
description: "Find why code is shaped this way: anchor in git history, fan out one investigator per evidence source, synthesize into confidence tiers. Use for design rationale, tradeoffs, motivating incidents, or where a number came from."
name: why
---
# Why

Find what forces shaped a piece of code: the decision, tradeoff, incident, or constraint behind it. Companion to `how` (what it does). Code shows what it does, never why it exists; the why lives in commits, PRs, tickets, docs, and conversations.

## 1. Build the code anchor

Seed context, built inline and passed to every investigator: file paths with line ranges, key symbols, the last commits touching the target (`git blame -L <start>,<end> <file>`, `git log --follow -p -- <file>`, `git log --oneline -20 -- <file>`), PR numbers from merge subjects, PR bodies and discussion for substantive commits (`gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews`), and linked ticket IDs.

## 2. Spawn one investigator per available source

Git history always runs. Tracker, long-form docs, team chat, observability, error tracking, and analytics run when a tool reaches them; each owns exactly one source, all in one round so they run concurrently. Briefs are self-contained; models follow the repo model map when one exists.

Each investigator works careful, cautious, and precise: cast a wide net before narrowing, read each item whole (the evidence hides in comments and follow-ups), follow links inside its own source only, quote verbatim with exact location, and record what was searched including empty searches. Gather, do not conclude: mechanics are not motivation, code style is not evidence of intent, and contradictions are reported, never smoothed over. Never invent; a partial finding stays labeled partial.

## 3. Synthesize with confidence tiers

One synthesizer merges findings. Every claim sits in one tier, and phrasing matches the tier:

- **Direct.** An author wrote the why (PR description, ticket, comment, doc, chat message). Phrased confident, present tense, cited.
- **Supported.** Indirect evidence converges from several sources, none stating it. Phrased confident but derived, every item cited.
- **Inferred.** A reasonable reading nothing states explicitly. Hedged with the chain shown ("given A and B, C seems likely because D").
- **Speculative.** A plausible guess other explanations fit equally well. Marked as a guess, kept with competing hypotheses.
- **Unknown.** Searched and found nothing. A valid outcome: name each source searched and what was asked of it.

Do not retrofit a clean rationale onto messy history, do not confirm a hypothesis the user embedded without independent evidence, and surface contradicting sources side by side. Confidence words (because, the reason is, fixes, the team decided) need an adjacent citation; hedges (appears to, suggests, plausibly) mark interpretation. Banned: obviously, clearly, of course, dismissive just, "I think".

## Output

What we found (cited), what we can reasonably infer (tiered), competing hypotheses, what we do not know (concrete gaps). If no gaps are mentioned, the search was incomplete.
