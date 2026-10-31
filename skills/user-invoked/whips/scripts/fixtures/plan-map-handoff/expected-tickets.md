# Expected collapse of foggy-brief.md (fixture for test-plan-map-handoff.sh)

Three tickets, blockers first, each one type plus Kompleksitas.

## Ticket 1: digest store

- Type: feature
- Kompleksitas: O(C) channels, 2 gh calls, 0 LLM calls
- Acceptance: one digest row per channel per day; rerun same day writes nothing new
- Labels: ready-for-agent, risk:medium
- Reuses: Destination line above (one digest per channel per day)

## Ticket 2: audit row before dispatch

- Type: feature
- Blocked by: Ticket 1
- Kompleksitas: O(S) sends, 2 gh calls, 0 LLM calls
- Acceptance: every send has an audit row; a missing row blocks dispatch
- Labels: ready-for-agent, risk:medium
- Reuses: audit decision above (row before dispatch)

## Ticket 3: channel retry policy

- Type: enhancement
- Blocked by: Ticket 1
- Kompleksitas: O(R) retries, 2 gh calls, 0 LLM calls
- Acceptance: failed send retries twice, then pages with the audit id
- Labels: ready-for-agent, risk:low
- Reuses: Destination scope (team channels only), no second fog interview
