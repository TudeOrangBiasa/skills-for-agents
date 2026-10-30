---
description: "Find why code is shaped this way: anchor in git history, fan out one investigator per evidence source, synthesize into confidence tiers. Use for design rationale, tradeoffs, motivating incidents, or where a number came from."
name: why
---
# Why

Find what forces shaped a piece of code: the decision, tradeoff, incident, or constraint behind it. Companion to `how` (what it does). Code shows what it does, never why it exists; the why lives in commits, PRs, tickets, docs, and conversations.

Investigators run in agent mode with tool access (never a read-only harness mode that strips it), but write nothing.

## 1. Understand the target and the question

The target is usually a chunk of code, a pattern, a feature, or a named design decision; the question is usually a design rationale, a tradeoff, a motivating edge case, an external constraint, dead code, or a broad history sweep. A vague target ("why do we do it this way?" with no clear referent) means guessing from conversation context (open files, recent edits, what was just discussed), stating your interpretation briefly, then proceeding; the user redirects if you are off.

## 2. Build the code anchor

Seed context, built inline and passed to every investigator and to the synthesizer: file paths with line ranges, key symbols, the last commits touching the target (`git blame -L <start>,<end> <file>`, `git log --follow -p -- <file>`, `git log --oneline -20 -- <file>`, `git log -1 --format=%B <commit>` to extract PR numbers from the `(#1234)` pattern in merge subjects), PR bodies and discussion for substantive commits (`gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews`), and linked ticket IDs.

## 3. Spawn one investigator per available source

Default to the full parallel investigation: a complete coverage map, not a minimal one. Document the null, do not skip the search.

Git history always runs. Tracker, long-form docs, team chat, observability, error tracking, and analytics run when a tool reaches them; each owns exactly one source, all in one round so they run concurrently. Briefs are self-contained; models follow the repo model map (`why-investigator` role) when one exists. Build each brief from [INVESTIGATOR-BRIEF.md](INVESTIGATOR-BRIEF.md), pasting in the category playbook from [SOURCES.md](SOURCES.md). When a tool could fit more than one category, assign it to its primary evidence and record the ambiguity in the coverage map.

Each category surfaces one shape of why, which also names the gap when it returns empty:

1. **Source control** (git, `gh`, comments, tests). The only guaranteed source. Best at implementation-time rationale captured during review.
2. **Tracker.** Best at the product or business forcing function; strongest when the why is external to engineering.
3. **Long-form docs.** Best at design rationale written before it became code.
4. **Team chat.** Best at deliberation that never reached a doc; especially important when the paper trail is thin.
5. **Observability.** Best at infrastructure and runtime reality that motivated the code (timeouts, retries, rate limits, circuit breakers).
6. **Error tracking.** Best at the specific exceptions that motivated defensive or corrective code (catch blocks, null guards, retries).
7. **Analytics.** Best at product and data reality that shaped the code (flag-gated code, experiments, migrations, where a number came from).

When the target looks defensive (null checks, retry logic, timeout handling, rate limiting, feature flags, egress guards, OOM handlers), add incident-flavored queries inside each investigator's own source (incident or sev tickets, incident channels around the ship dates, "fix for incident" style commit messages).

A category is skipped only with an explicit written justification that goes in the final Sources Consulted: no tool reaches it in this environment (flagged as a gap, not a choice), or it is provably irrelevant (a high bar, e.g. error tracking skipped for a build-time script with no runtime path). A trivial target whose PR description already holds the complete answer may be answered inline only after confirming every available search would be redundant; this should be rare.

Each investigator works careful, cautious, and precise: cast a wide net before narrowing, read each item whole (the evidence hides in comments and follow-ups), follow links inside its own source only (cross-source references go under Additional Leads for that source's investigator), quote verbatim with exact location, and record what was searched including empty searches. Gather, do not conclude: mechanics are not motivation, code style is not evidence of intent, contradictions are reported never smoothed over, and no silent substitutions (evidence about feature Y never answers a question about feature X). Never invent; a partial finding stays labeled partial.

## 4. Synthesize with confidence tiers

One synthesizer (`why-synthesizer` role) merges findings. It reads [EPISTEMICS.md](EPISTEMICS.md) in full first (brief template: [SYNTHESIZER-BRIEF.md](SYNTHESIZER-BRIEF.md)), merges overlapping citations into one authoritative reference, surfaces contradictions side by side instead of picking one, spot-checks uncertain citations against the codebase or tools instead of propagating errors, and never cites code as evidence for its own intent.

Every claim sits in one tier, and phrasing matches the tier:

- **Direct.** An author wrote the why (PR description, ticket, comment, doc, chat message). Phrased confident, present tense, cited.
- **Supported.** Indirect evidence converges from several sources, none stating it. Phrased confident but derived, every item cited.
- **Inferred.** A reasonable reading nothing states explicitly. Hedged with the chain shown ("given A and B, C seems likely because D").
- **Speculative.** A plausible guess other explanations fit equally well. Marked as a guess, kept with competing hypotheses.
- **Unknown.** Searched and found nothing. A valid outcome: name each source searched and what was asked of it.

Do not retrofit a clean rationale onto messy history, do not confirm a hypothesis the user embedded without independent evidence, and do not turn an absence of evidence into evidence of absence. Confidence words (because, the reason is, fixes, the team decided) need an adjacent citation; hedges (appears to, suggests, plausibly) mark interpretation. Banned: obviously, clearly, of course, dismissive just, "I think".

Before finalizing: every claim in What We Found and What We Can Reasonably Infer has a citation or moves to Inferred or Hypotheses; every contradiction noticed is surfaced; What We Don't Know names specific gaps. If no gaps are mentioned, the search was incomplete.

Beware recency bias: the most recent commit is rarely authoritative; the current shape is often the accretion of many earlier decisions. Trace back.

## 5. Present

Present the synthesis; light edits for clarity are fine, but do not rewrite the confidence language.

## Output sections

The Question (one or two sentences), The Code in Question (paths, lines, symbols, two or three lines), What We Found (`[Direct]` and `[Supported]` claims, each quoted or paraphrased and cited), What We Can Reasonably Infer (`[Inferred]` bullets with visible inference chains; skip when nothing), Competing Hypotheses (each with evidence for and evidence against or missing; skip when one answer is clear), What We Don't Know (unanswered questions, empty searches, unavailable sources with why, people who would likely know), Sources Consulted (one line per source, including empty and skipped ones with reasons), Confidence Summary (one or two sentences grading each part of the answer). When the question is a precursor to changing the code, convert the findings into a Preserve / Change / Avoid / Risk constraint set for planning the change.
