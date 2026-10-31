#!/usr/bin/env bash
# Stub test for the plan-map wayfinder handoff (issue #192). No network,
# no gh, no LLM: a foggy brief fixture plus the handoff contract files only.
# Proves: the handoff yields ready-for-agent tickets with one type plus
# Kompleksitas, needs no tell-the-user-to-run-slash-command wait, reuses
# Destination and Decisions-so-far instead of re-asking, and returns the
# router to a build playbook ending in opening-a-pr.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SKILL="$HERE/.."
HANDOFF="$SKILL/playbooks/plan-map-handoff.md"
STAGES="$SKILL/playbooks/stage-pipeline.md"
TRIAGE="$SKILL/playbooks/triage.md"
OPENING="$SKILL/playbooks/opening-a-pr.md"
PLAN_MAP="$HERE/../../plan-map/SKILL.md"
PLAN_TICKETS="$HERE/../../plan-tickets/SKILL.md"
SKILL_MD="$SKILL/SKILL.md"
FIX="$HERE/fixtures/plan-map-handoff"
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

# 1. No process gate: nothing tells whips to stop and wait on a slash command.
for f in "$HANDOFF" "$STAGES"; do
  grep -qiE 'tell the user to run `/(plan-map|plan-spec|plan-tickets)`' "$f" \
    && fail "$f still mandates a tell-the-user-to-run slash-command wait"
done
grep -qiE 'stop here until the map clears' "$HANDOFF" \
  && fail "handoff still stops until the map clears"
pass "no tell-the-user-to-run slash-command gate in handoff or pipeline"

# 2. Handoff runs map plus collapse plus tickets inline and lands on a build flow.
grep -q 'collapse inline' "$HANDOFF" || fail "handoff lacks inline collapse"
grep -q 'ready-for-agent' "$HANDOFF" || fail "handoff lacks ready-for-agent"
grep -q 'opening-a-pr.md' "$HANDOFF" || fail "handoff never reaches opening-a-pr"
pass "handoff collapses inline and ends in opening-a-pr"

# 3. Fixture yields 3 ready-for-agent tickets, one type plus Kompleksitas each.
[[ -f "$FIX/foggy-brief.md" && -f "$FIX/expected-tickets.md" ]] \
  || fail "fixtures missing under fixtures/plan-map-handoff"
n_tickets="$(grep -c '^## Ticket ' "$FIX/expected-tickets.md")"
[[ "$n_tickets" == "3" ]] || fail "expected 3 tickets, found $n_tickets"
n_ready="$(grep -c 'ready-for-agent' "$FIX/expected-tickets.md")"
[[ "$n_ready" -ge 3 ]] || fail "expected 3 ready-for-agent tickets, found $n_ready"
n_type="$(grep -cE '^- Type: (bug|feature|enhancement|deprecation)$' "$FIX/expected-tickets.md")"
[[ "$n_type" == "3" ]] || fail "expected 3 one-type tickets, found $n_type"
n_komp="$(grep -cE '^- Kompleksitas: O\([^)]+\) .*, [0-9]+ gh calls, [0-9]+ LLM calls$' "$FIX/expected-tickets.md")"
[[ "$n_komp" == "3" ]] || fail "expected 3 Kompleksitas lines, found $n_komp"
n_risk="$(grep -cE 'risk:(low|medium|high)' "$FIX/expected-tickets.md")"
[[ "$n_risk" -ge 3 ]] || fail "expected a risk label per ticket, found $n_risk"
pass "fixture yields 3 ready-for-agent tickets with type plus Kompleksitas"

# 4. No duplicate questioning: Destination and Decisions-so-far are reused.
for f in "$HANDOFF" "$PLAN_TICKETS" "$TRIAGE"; do
  grep -q 'Decisions-so-far' "$f" || fail "$f never reuses Decisions-so-far"
done
grep -qi 'never re-ask' "$HANDOFF" || fail "handoff never bans re-asking"
grep -qi 'no second fog interview' "$HANDOFF" || fail "handoff allows a second fog interview"
grep -qiE 'no second fog interview|never run a second fog interview' "$TRIAGE" || fail "intake allows a second fog interview"
grep -q 'Destination' "$FIX/expected-tickets.md" || fail "tickets drop the Destination"
pass "Destination and Decisions-so-far reused, never re-asked"

# 5. Router still sends only truly foggy work to plan-map; thin fog drives through.
grep -q 'huge, foggy effort' "$SKILL_MD" || fail "router lost the foggy row"
grep -qi 'thin fog drives through' "$SKILL_MD" || fail "router lost the thin-fog carve-out"
grep -qi 'thin fog' "$HANDOFF" || fail "handoff lost the thin-fog carve-out"
grep -q 'not visible in one session' "$HANDOFF" \
  || fail "handoff lost the multi-session test"
pass "router keeps multi-session fog on plan-map, thin fog drive-through"

# 6. Invocation rule documented: user-invoked skills stay, whips works inline.
grep -q 'Invocation rule' "$HANDOFF" || fail "handoff lacks the Invocation rule"
grep -q 'disable-model-invocation\|no skill can fire them' "$HANDOFF" \
  || fail "handoff never resolves disable-model-invocation"
grep -q 'disable-model-invocation: true' "$PLAN_MAP" \
  || fail "plan-map lost user-invokable frontmatter"
grep -q 'Invocation rule' "$STAGES" || fail "pipeline lacks the Invocation rule pointer"
pass "invocation rule documented, plan-map stays user-invokable"

# 7. Pickup: map-collapsed tickets route to build flows ending in ship-pr shape.
grep -q 'opening-a-pr' "$TRIAGE" || fail "intake never reaches opening-a-pr"
grep -q 'map-collapsed\|cleared plan-map' "$OPENING" \
  || fail "opening-a-pr lacks the map-collapsed pickup line"
pass "pickup routes map tickets into build flows ending in opening-a-pr"

# 8. No network, no gh, no LLM in this stub (besides grep reading files) or its fixtures.
grep -vE '^\s*#|no-network self-check|grep -[a-zA-Z]' "$HERE/test-plan-map-handoff.sh" \
  | grep -Eq '\bgh [a-z]|curl |wget |openai|anthropic|llm api' \
  && fail "stub reaches for network, gh, or an LLM" # no-network self-check
grep -rnE '\bgh [a-z]|curl |wget |openai|anthropic|llm api' "$FIX" \
  | grep -v 'gh calls' | grep -q . \
  && fail "fixtures reach for network, gh, or an LLM"
pass "stub is fixture-driven with no network"

echo "plan-map handoff stub: all 8 scenarios green"
