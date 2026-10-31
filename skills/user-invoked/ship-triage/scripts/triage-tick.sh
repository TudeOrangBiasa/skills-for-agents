#!/usr/bin/env bash
# triage-tick.sh: incremental triage tick for /ship-triage (issues #195, #196).
#
# Reads a local JSON export of issues (the caller lists once per tick; this
# script makes zero list calls itself and zero agent calls), filters to the
# delta set with an incremental cursor, and flags near-duplicate titles with
# a normalized fingerprint map.
#
# Cost: O(delta I) filter work on a steady tick (O(I) on full-rescan
# fallback), O(I) normalize plus O(1) map ops per issue for dedupe.
#
# Cursor path: $RUNNER_STATE_DIR/triage-cursor (default
# ~/.local/state/runner/triage-cursor), the existing runner state dir, never
# a new top-level file. The cursor advances only after the tick succeeds.
#
# Usage:
#   triage-tick.sh --issues FILE [--cursor FILE] [--dry-run] [--fail-before-write]
#   triage-tick.sh --fingerprint "Some title"
set -euo pipefail

DEFAULT_CURSOR="${RUNNER_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/runner}/triage-cursor"

die() { printf 'triage-tick: %s\n' "$*" >&2; exit 2; }
need() { command -v "$1" >/dev/null || die "missing dependency: $1"; }

# Normalize a title to a stable fingerprint hash: lowercase, strip the type
# prefix (colon form like fix(skill): or feat:, else a bare leading type word
# like fix or enhancement), strip punctuation, collapse whitespace, reduce to
# a sorted token set, then hash. One call per title, no pairwise work.
triage_fingerprint() {
  local t="$1" sorted
  t="$(printf '%s' "$t" | tr '[:upper:]' '[:lower:]')"
  t="$(printf '%s' "$t" | sed -E 's/^[[:space:]]+//')"
  t="$(printf '%s' "$t" | sed -E 's/^(fix|enhancement|feat|deprecate)(\([^)]*\))?[[:space:]]*:[[:space:]]*//; t done; s/^(fix|enhancement|feat|deprecate)[[:space:]]+//; :done')"
  t="$(printf '%s' "$t" | sed -E 's/[^a-z0-9 ]/ /g' | tr -s ' ' | sed -E 's/^ //; s/ $//')"
  sorted="$(printf '%s' "$t" | tr ' ' '\n' | { grep -v '^$' || true; } | sort -u | tr '\n' ' ' | sed -E 's/ $//')"
  printf '%s' "$sorted" | sha1sum | cut -d' ' -f1
}

# Load the cursor: prints the timestamp and returns 0 when it is a valid
# ISO-8601 UTC stamp, else prints FULLSCAN:<reason> and returns 1 so the
# caller falls back to a full open-issue rescan.
triage_cursor_load() {
  local f="$1" c
  [[ -f "$f" ]] || { printf 'FULLSCAN:missing\n'; return 1; }
  [[ -r "$f" ]] || { printf 'FULLSCAN:unreadable\n'; return 1; }
  c="$(tr -d ' \t\r\n' <"$f")"
  if [[ "$c" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
    printf '%s\n' "$c"; return 0
  fi
  printf 'FULLSCAN:corrupt\n'; return 1
}

MODE_FP=0; FP_TITLE=""
ISSUES=""; CURSOR="$DEFAULT_CURSOR"; DRY_RUN=0; FAIL_BEFORE_WRITE=0
while (($#)); do
  case "$1" in
    --issues) ISSUES="${2:-}"; shift 2 ;;
    --cursor) CURSOR="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --fail-before-write) FAIL_BEFORE_WRITE=1; shift ;;
    --fingerprint) MODE_FP=1; FP_TITLE="${2:-}"; shift 2 ;;
    *) die "unknown flag: $1" ;;
  esac
done

if ((MODE_FP)); then
  need sha1sum
  triage_fingerprint "$FP_TITLE"
  exit 0
fi

[[ -n "$ISSUES" ]] || die "usage: triage-tick.sh --issues FILE [--cursor FILE] [--dry-run]"
need jq; need sha1sum; need base64
[[ -f "$ISSUES" ]] || die "issues file not found: $ISSUES"

MODE="full-scan"; CURSOR_TS=""; REASON="missing"; LOAD_OUT=""
if LOAD_OUT="$(triage_cursor_load "$CURSOR")"; then
  MODE="delta"; CURSOR_TS="$LOAD_OUT"
else
  REASON="${LOAD_OUT#FULLSCAN:}"
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
if [[ "$MODE" == "delta" ]]; then
  jq -r --arg c "$CURSOR_TS" '(.issues // .) | map(select(.state == "open" and (.updatedAt // "") >= $c)) | sort_by(.number) | .[] | "\(.number)\t\(.updatedAt)\t\(.title // "" | @base64)"' "$ISSUES" >"$TMP/work.tsv"
else
  jq -r '(.issues // .) | map(select(.state == "open")) | sort_by(.number) | .[] | "\(.number)\t\(.updatedAt // "")\t\(.title // "" | @base64)"' "$ISSUES" >"$TMP/work.tsv"
fi

# One-pass fingerprint to first-seen-issue map over the working set: O(I)
# time, O(I) space. A later issue hashing to a known fingerprint reads as a
# duplicate of the survivor, the same action shape as an exact-title hit.
declare -A SEEN=()
considered=0; duplicates=0
n=""; updated=""; tb64=""
while IFS=$'\t' read -r n updated tb64; do
  [[ -n "${n:-}" ]] || continue
  considered=$((considered + 1))
  title="$(printf '%s' "$tb64" | base64 -d)"
  fp="$(triage_fingerprint "$title")"
  if [[ -n "${SEEN[$fp]:-}" ]]; then
    printf 'decision=duplicate-of %s survivor=%s fingerprint=%s\n' "$n" "${SEEN[$fp]}" "${fp:0:12}"
    duplicates=$((duplicates + 1))
  else
    SEEN[$fp]="$n"
  fi
done <"$TMP/work.tsv"

: "$updated"
if [[ "$MODE" == "delta" ]]; then
  printf 'mode=delta cursor=%s working-set=%s duplicates=%s\n' "$CURSOR_TS" "$considered" "$duplicates"
else
  printf 'mode=full-scan reason=%s working-set=%s duplicates=%s\n' "$REASON" "$considered" "$duplicates"
fi

# The cursor moves only after the tick succeeds: a crash before this point
# reprocesses the same delta next time, never skips it. It also never moves
# backwards: the new value is the max of the old cursor and the newest
# updatedAt seen.
if ((DRY_RUN)); then
  printf 'cursor=unchanged (dry-run)\n'
elif ((FAIL_BEFORE_WRITE)); then
  printf 'triage-tick: simulated crash before cursor write\n' >&2
  exit 3
else
  MAX_TS="$(jq -r '[(.issues // .)[] | select(.state == "open") | .updatedAt // empty] | max // empty' "$ISSUES")"
  NEW_TS="$CURSOR_TS"
  if [[ -n "$MAX_TS" ]]; then
    if [[ -z "$NEW_TS" || "$MAX_TS" > "$NEW_TS" ]]; then NEW_TS="$MAX_TS"; fi
  fi
  if [[ -n "$NEW_TS" ]]; then
    mkdir -p "$(dirname "$CURSOR")"
    printf '%s\n' "$NEW_TS" >"$CURSOR.tmp" && mv "$CURSOR.tmp" "$CURSOR"
    printf 'cursor=stored value=%s path=%s\n' "$NEW_TS" "$CURSOR"
  else
    printf 'cursor=unchanged (no open issues)\n'
  fi
fi
