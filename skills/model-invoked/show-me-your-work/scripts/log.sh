#!/usr/bin/env bash
# log.sh: append one decision-trail row (show-me-your-work).
# Usage: scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>
# Stamps ISO8601 ts, writes the header on first use, strips tabs/newlines
# inside cells, quotes formula-leading cells, creates parent dirs.
set -euo pipefail

logfile="${1:?usage: log.sh <logfile> <phase> <decision> <why> <evidence> <result>}"
phase="${2:?missing phase}"
decision="${3:?missing decision}"
why="${4:?missing why}"
evidence="${5:?missing evidence}"
result="${6:?missing result}"

mkdir -p "$(dirname "$logfile")"
if [[ ! -s "$logfile" ]]; then
  printf 'ts\tphase\tdecision\twhy\tevidence\tresult\n' > "$logfile"
fi

clean() {
  local c="$1"
  c="${c//$'\t'/ }"
  c="${c//$'\n'/ }"
  case "$c" in
    [=+-@]*) c="'$c" ;;
  esac
  printf '%s' "$c"
}

printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "$(clean "$phase")" "$(clean "$decision")" "$(clean "$why")" \
  "$(clean "$evidence")" "$(clean "$result")" >> "$logfile"
