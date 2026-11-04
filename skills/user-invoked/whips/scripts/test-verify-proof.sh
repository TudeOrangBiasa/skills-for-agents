#!/usr/bin/env bash
# test-verify-proof.sh: stub test for the no-proof-not-done rule (#236) plus
# the no-abstract-review-gate rule (#237).
# No network, no gh. Checks the shipped wording directly:
#   1. whips SKILL.md Verify section names the verify skill discovery plus the
#      verifier.md command, the verify-new fallback, and the NOT VERIFIED rule.
#   2. opening-a-pr.md step 3 runs the verify skill and step 6 requires the
#      Verification line (NOT VERIFIED without it).
#   3. No playbook gates code-ready/shipping/merge on review-code,
#      review-adversary, or a read-only second opinion.
#   4. RISK.md high tier and landing-policy.md require an empirical rerun,
#      never a read-only skim.
#   5. review-code is on-ask with run-proven Spec findings; review-adversary is
#      explicit-ask only; craft-trail Attention flags missing proof only.
#   6. setup-repo Section I records later as pending verifier.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../../.." && pwd)"
pass() { printf 'verify-proof ok: %s\n' "$1"; }
fail() { printf 'verify-proof FAIL: %s\n' "$1" >&2; exit 1; }

WHIPS="$REPO/skills/user-invoked/whips/SKILL.md"
OPENING="$REPO/skills/user-invoked/whips/playbooks/opening-a-pr.md"
RISK="$REPO/skills/user-invoked/whips/RISK.md"
LANDING="$REPO/skills/user-invoked/setup-repo/landing-policy.md"
SETUP="$REPO/skills/user-invoked/setup-repo/SKILL.md"
SETUP_VERIFIER="$REPO/skills/user-invoked/setup-repo/verifier.md"
REVIEW_CODE="$REPO/skills/model-invoked/review-code/SKILL.md"
ADVERSARY="$REPO/skills/model-invoked/review-adversary/SKILL.md"
TRAIL="$REPO/skills/model-invoked/craft-trail/SKILL.md"

# 1. Whips verify section: discovery, command, fallback, NOT VERIFIED.
grep -q 'skills/verify-\*/SKILL.md' "$WHIPS" || fail "whips verify section names no verify-skill discovery"
grep -q 'docs/agents/verifier.md' "$WHIPS" || fail "whips verify section names no verifier.md command"
grep -q '/verify-new' "$WHIPS" || fail "whips verify section names no verify-new fallback"
grep -q 'NOT VERIFIED' "$WHIPS" || fail "whips verify section names no NOT VERIFIED rule"
pass "whips verify section requires proof"

# 2. Opening-a-pr: verify skill in gates, Verification line in body.
grep -q 'skills/verify-\*/SKILL.md' "$OPENING" || fail "opening-a-pr step 3 names no verify skill"
grep -q 'Verification:' "$OPENING" || fail "opening-a-pr step 6 names no Verification line"
grep -q 'NOT VERIFIED' "$OPENING" || fail "opening-a-pr body names no NOT VERIFIED rule"
pass "opening-a-pr gates on verifier evidence"

# 3. No abstract review gate on the critical path. An explicit-ask-only
#    design-pressure call (feature.md step 9) is allowed; a required
#    code-ready/shipping/merge gate on review is not.
for f in "$REPO/skills/user-invoked/whips/playbooks/autopilot-full.md" \
         "$REPO/skills/user-invoked/whips/playbooks/multi-phase-plan.md" \
         "$REPO/skills/user-invoked/whips/playbooks/stage-pipeline.md" \
         "$REPO/skills/user-invoked/whips/playbooks/orchestrate.md"; do
  if grep -Eq 'call the Skill tool with "review-(code|adversary)"' "$f"; then
    fail "$(basename "$f") still gates on a review Skill-tool call"
  fi
done
if grep -Eq 'review-code.*before shipping|before any PR' "$REPO/skills/user-invoked/whips/playbooks/multi-phase-plan.md" \
  || grep -Eq 'review-code.*before shipping|before any PR' "$REPO/skills/user-invoked/whips/playbooks/stage-pipeline.md"; then
  fail "a playbook still lists review-code as a shipping gate"
fi
grep -q 'never a read-only second opinion as a gate' "$WHIPS" \
  || fail "whips triggers still present abstract review as a gate"
grep -q 'never gates code-ready, shipping, or merge' "$REVIEW_CODE" \
  || fail "review-code still reads as a ship gate"
pass "no playbook gates on abstract review"

# 4. High tier stays empirical.
grep -q 'read-only skim never satisfies' "$RISK" || fail "RISK high tier allows a read-only skim"
grep -q 'never a read-only skim' "$LANDING" || fail "landing-policy high lane allows a read-only skim"
pass "high tier is empirical"

# 5. Review skills demoted, trail evidence-bound.
grep -q 'explicit user ask' "$ADVERSARY" || fail "review-adversary not demoted to explicit ask"
grep -Ei -q 'never a default (gate|pre-PR gate)' "$ADVERSARY" || fail "review-adversary still a default pre-PR gate"
grep -q 'missing or weak verification evidence' "$TRAIL" || fail "craft-trail Attention not evidence-bound"
pass "review skills demoted, trail evidence-bound"

# 6. Setup later means pending verifier.
grep -q 'pending: run /verify-new' "$SETUP" || fail "setup-repo Section I records no pending verifier"
grep -q 'pending: run /verify-new' "$SETUP_VERIFIER" || fail "verifier template names no pending state"
pass "setup-repo later is a pending verifier"

echo "verify-proof stub: all 6 scenarios green"
