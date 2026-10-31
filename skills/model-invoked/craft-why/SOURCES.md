# Source Playbooks

One playbook per evidence category. Paste the playbook for the investigator's category into its brief (see INVESTIGATOR-BRIEF.md). The playbooks are vendor-neutral: adapt the concrete moves to whatever tool reaches the category in this environment (an MCP, a CLI, a web UI, an API).

Playbook per category:

- Source control: git plus the forge CLI (e.g. `gh`), always available.
- Tracker: the linked-issue walk, adapted to whatever tracker the repo uses.
- Long-form docs: keyword search plus full-page reads in the team's doc tool.
- Team chat: author-bounded and thread-scoped search in the team's chat tool.
- Observability: the team's metrics, logs, traces, monitors, and incident records.
- Error tracking: the team's exception history.
- Analytics: the product analytics warehouse, if the environment exposes one.

Cross-cutting:

- Incident lenses below. Add them when the target code looks defensive (null checks, retry, timeout, rate limit, feature flag, egress guard, OOM handler).

## 1. Source control (git + forge)

The most trustworthy source, tied directly to the code, and the most complete. Everything that went through the repo should be here: commits, PR descriptions and review threads, inline comments, TODOs, ADRs, tests (whose names and assertions often encode the motivating edge cases), co-changed files, CHANGELOG entries, and ticket IDs in messages and PR bodies.

Expand the seed commit list:

```bash
# History through renames
git log --follow --oneline -- <file>

# Pickaxe: commits that added or removed this exact text
git log -S '<exact_string_from_code>' -- <file>

# Or for patterns:
git log -G '<regex>' -- <file>

# Who wrote each line and when
git blame -L <start>,<end> <file>

# One commit's full diff
git show <hash>

# Commits between two points affecting this file
git log <old>..<new> -p -- <file>
```

Look for out-of-band docs:

```bash
# ADRs often live in docs/adr/ or similar
rg -l -i 'architecture.decision' --glob '*.md'

# TODOs and FIXMEs near the target
rg -n -C2 '(TODO|FIXME|HACK|XXX|NOTE)' <target_file>

# Related tests
rg -l '<symbol>' --glob '*test*'
```

## 2. Tracker

Where the product or business context usually lives: "we're doing this because customer X asked" or "this is for the compliance initiative."

1. **Start with linked tickets.** If the seed commits or PRs reference ticket IDs, fetch those first. Read the full issue including comments.
2. **List related issues by keyword.** Search for the feature name, key symbol, or business term. Try multiple phrasings.
3. **Walk the issue tree.** If you land on a sub-issue, fetch its parent. Sub-issues are tactical. Parents often carry the why.
4. **Read project docs.** If the issue belongs to a project, check attached docs. Project-level documents are where specs and rationale are most often captured.
5. **Check labels and milestones.** Labels hint at the motivation category (customer-request, incident-followup, compliance). Milestones tie work to deadlines, which often reveal motivation.

Good evidence: an issue stating the business problem, a comment recording a decision ("we went with approach B because A would require touching billing"), a parent issue titled like an initiative, an attached PRD, labels naming a customer or incident.

Pitfalls: scope drift (a ticket closed and reopened with different scope; read the whole history), mechanical templates ("Why" sections filled with boilerplate), stale tickets (check dates against the ship date), closed-as-duplicate chains (follow them to the canonical ticket), inaccessible issues (note as a gap, never guess).

## 3. Long-form docs

Long-form rationale written before it becomes code: PRDs, specs, RFCs, ADRs, design-review notes, postmortems, runbooks, strategy docs. A significant feature usually has a doc.

1. **Keyword searches.** Try the feature name, key symbols, author handles (docs are often authored before the code lands), error strings or user-visible terms, and time-bounded queries when the ship date is known.
2. **Fetch candidate pages.** Read the full content, not the preview. Rationale is often buried mid-document.
3. **Follow backlinks and child pages.** Design docs often have sub-pages for alternatives considered, appendices, or implementation notes.
4. **Check related databases.** Meeting-note indexes can surface the discussion that decided it.
5. **Search author-specific spaces.** A personal notebook may hold exploratory thinking that preceded the code.

Good evidence: a PRD with a Motivation section matching the target's purpose, an Alternatives Considered section, a postmortem naming the target as the fix for an incident, meeting notes recording "we decided X because Y", a non-trivially filled ADR.

Pitfalls: outdated docs (specs written before implementation and never updated; cross-check against the PR), doc vs reality drift (flag the divergence), boilerplate templates (look for specificity), unlinked docs (broad keyword searches help), multiple drafts (find the finalized one; check dates), access-restricted pages (note the gap).

## 4. Team chat

Real-time deliberation that never reached a doc. Inspect the available chat tool's schema first; if authentication fails, stop and report the gap.

1. **Author-bounded search.** Messages from the PR author around the merge date. Limits scope dramatically and often hits gold.
2. **PR link search.** Teams often link PRs when reviewing or discussing them. Search for the PR URL or just the pull number.
3. **Error string search.** If the code handles a specific error, search for the error string. Incident threads often surface.

Pitfalls: retention cliffs (very old messages may be gone; note the cutoff), unsearchable DMs (a known limitation), casual jokes read as decisions ("lol just do the thing" isn't a decision), context collapse (always fetch the thread; a lone message reads differently), auth failures (stop, report that chat wasn't searchable, never invent findings).

## 5. Observability

The runtime record, what actually happened in production, as opposed to what was planned or discussed: metrics (a metric's presence is itself evidence someone thought the number worth watching), monitors and alerts (conditions the team decided warranted waking someone up), dashboards, traces and spans, logs, incident records, investigation notebooks.

1. **Identify the owning services** and their upstream/downstream dependencies.
2. **Dashboards and monitors first.** Search by feature name, service name, symbol. When one covers the target, note its queries and watched thresholds. The threshold is frequently the answer to "why is this clamped at N?"
3. **Metrics around the target.** Search by name pattern, read metadata, pull timeseries bracketing the change. A metric spiking just before the merge and stabilizing after is strong supporting evidence.
4. **Logs. Narrow, don't dump.** Search with symbols, error strings, or feature names. Strongly prefer time-bounded queries (e.g. 30 days around the change). Aggregate rather than dumping raw logs.
5. **Traces and spans.** Useful for timeouts, retries, slow paths, and cross-service behavior.
6. **Incidents.** If the target looks defensive, search for incidents around the time it was added. An incident whose timeline includes "added defensive check for X" is near-direct evidence.

Good evidence: a monitor whose query and threshold match the constraint the code enforces, a dashboard by the target's author with widgets matching what the code guards, a production spike immediately before the merge, an incident referencing the same symbols or error strings, logs showing an error pattern the defensive code would prevent, timestamped before the change.

Pitfalls: correlation is not causation (check neighboring PRs in the same window), overfitting to the chart you found (a chart reflects its maker's framing), vanished telemetry (renamed metrics or short retention are gaps, not null results), noise at scale (narrow aggressively by service, tag, time window), instrumented but not caused (cross-reference with commit and PR dates).

## 6. Error tracking

The specific exceptions and error trajectories that motivated defensive or corrective code.

1. **Orient.** Find the organization and project the target service reports to.
2. **Search issues.** Build queries from the exception classes the target handles, its function or class name, the error strings it checks, and its file path.
3. **Narrow by release and time window.** For a suspected issue, check first seen and last seen (does the stop line up with the ship date?), the affected releases (which saw it, which was the fix?), and the frequency trajectory (spike, then resolved?).
4. **Pull the full event.** Does the stack trace pass through the target code? Do the tags and breadcrumbs match the conditions it defends against?
5. **Check releases near the target.** Cross-reference release versions with the PR merge date.

Pitfalls: AI root-cause summaries are hypothesis generators, not authoritative evidence. The actual events and stack traces are primary.

Good evidence per issue: issue ID and title, project, first/last seen, event count, affected releases, a representative stack-trace excerpt (verbatim, not summarized), first/last-seen correlation with the ship date, a link, and any author comments or resolution notes.

## 7. Analytics warehouse

The product and data view (what users did, which experiments ran, how usage evolved, where a threshold came from). It complements observability, which is the infra and runtime view.

Probe before assuming names: schemas are environment-specific, so confirm tables and columns before trusting them. Time-bound every query (a window bracketing the ship date, typically 30 days around it; wider only for strong reason). Prefer typed, deduplicated models over raw event tables; drop to raw only when no model exists or fresh events are still in refresh lag.

Patterns that pay off:

1. **Event usage trajectory.** Daily counts across the window around the merge. A step from zero to steady volume within a day or two of the merge is strong circumstantial evidence the PR launched the feature. A decay to zero suggests a deprecation.
2. **Guard-rail origin.** The distribution (median, p99, max) of the relevant property in the days before the PR. A p99 matching the target's threshold constant suggests the number came from data.
3. **Experiment or flag lookup.** Find the exposure table, then pull exposure counts by variant for the relevant flag key near the PR date.
4. **Query-history evidence.** For migrations, backfills, or perf rewrites, the expensive queries that likely motivated the change (sorted by duration or bytes read).
5. **Lineage.** If the target reads from or writes into a warehouse model, the model's own history often carries the rationale. Hand that lead back to the git investigator rather than chasing it yourself.

Pitfalls: instrumented but not caused (pair with a git citation before claiming causation), silent instrumentation changes (a volume step may mean logging changed, not behavior), schema drift (a column today may not have existed then), refresh lag (fall back to raw tables for the last hours), retention cliffs (a window predating retention is a gap, not a null result), unqueryable notebooks (if the rationale likely lives in one, name it as a gap).

Per finding, return: the fully-qualified table and exact query, the time window, a compact numeric summary (counts, percentiles, first/last-seen; never raw row dumps), the temporal correlation with the ship date, and the relevance plus strength (direct, circumstantial, weak).

## 8. Incident lenses (defensive targets only)

- **Tracker**: look for tickets labeled incident, sev, postmortem-action-item, reliability.
- **Chat**: search incident channels around the dates the target code was added.
- **Git**: commits like "fix for incident", "add defensive check", "revert" followed by "re-apply with..." are strong signals.
