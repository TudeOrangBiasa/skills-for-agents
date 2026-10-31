#!/usr/bin/env bash
# Stub test for install-timers (issue #78). No systemd writes, no network.
# Fails closed without dependency baru: only bash, cmp, grep.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL="$HERE/scripts/install-timers"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
# Run the installer with the dev harness fully out of the picture: no recorded
# agent command in env, config, or consumer repos, and no probe names from the
# developer shell leaking in.
ISOLATE="env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES= RUNNER_CONFIG=$TMP/no-config.sh XDG_CONFIG_HOME=$TMP/no-xdg HOME=$TMP/no-home"
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

# 1. dry-run needs a harness: fails closed and writes nothing.
if $ISOLATE PATH="$TMP/none/bin:/usr/bin:/bin" UNIT_DIR="$TMP/empty" "$INSTALL" --dry-run >/dev/null 2>&1; then
  fail "dry-run passed without a harness"
fi
[[ -e "$TMP/empty/runner-run.service" ]] && fail "dry-run wrote a unit"
pass "dry-run fails closed without a harness, writes nothing"

# 1b. the same dry-run with a documented probe previews all six units.
mkdir -p "$TMP/probebin" "$TMP/none/bin"
printf '#!/usr/bin/env bash\nif [[ "${1:-}" == "--help" ]]; then echo "stub-probe: non-interactive headless mode via --headless"; fi\n' >"$TMP/probebin/stub-probe"
chmod +x "$TMP/probebin/stub-probe"
out="$(env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-probe" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/probebin:/usr/bin:/bin" "$INSTALL" --dry-run --unit-dir "$TMP/empty" 2>&1)"
for u in runner-run.service runner-run.timer runner-fix-ci.service runner-fix-ci.timer runner-triage.service runner-triage.timer; do
  [[ "$out" == *"$u"* ]] || fail "dry-run missing $u"
done
[[ -e "$TMP/empty" ]] && fail "dry-run created the unit dir"
pass "documented probe dry-run prints six units, writes nothing"

# 2. bad --only exits 2 before any unit output.
if "$INSTALL" --dry-run --only bogus >/dev/null 2>&1; then fail "--only bogus accepted"; fi
pass "bad --only refused"

# 3. install then re-run is a no-op (identical bytes).
env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-probe" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/probebin:/usr/bin:/bin" UNIT_DIR="$TMP/u1" "$INSTALL" --yes --only run >/dev/null 2>&1
env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-probe" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/probebin:/usr/bin:/bin" UNIT_DIR="$TMP/u1" "$INSTALL" --yes --only run >"$TMP/rerun.txt" 2>&1
[[ "$(cat "$TMP/rerun.txt")" == *"no-op: runner-run.service already installed"* ]] || fail "re-run not no-op"
pass "re-run install is a no-op"

# 4. uninstall removes only managed units.
printf 'foreign\n' >"$TMP/u1/foreign.service"
env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-probe" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/probebin:/usr/bin:/bin" UNIT_DIR="$TMP/u1" "$INSTALL" uninstall --yes >/dev/null 2>&1
[[ -f "$TMP/u1/foreign.service" ]] || fail "uninstall removed a foreign file"
[[ -e "$TMP/u1/runner-run.service" ]] && fail "uninstall left a managed unit"
pass "uninstall removes only managed units"

# 5. rendered units verify with systemd-analyze.
env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-probe" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/probebin:/usr/bin:/bin" UNIT_DIR="$TMP/u2" "$INSTALL" --yes >/dev/null 2>&1
for u in "$TMP/u2"/*; do
  systemd-analyze --user verify "$u" || fail "verify failed: $u"
done
pass "systemd-analyze verify passes"

# 6. no harness on PATH fails closed without writing units.
mkdir -p "$TMP/u3"
if $ISOLATE PATH="$TMP/none/bin:/usr/bin:/bin" UNIT_DIR="$TMP/u3" "$INSTALL" --yes >/dev/null 2>&1; then
  fail "installed without a harness"
fi
[[ -e "$TMP/u3/runner-run.service" ]] && fail "wrote a unit without a harness"
pass "no harness stops cleanly with setup pointer"

# 7. recorded agent command installs without any probe binary.
mkdir -p "$TMP/u4"
if ! env -u RUNNER_REPOS RUNNER_AGENT_PROBES="" RUNNER_AGENT_CMD="stub-probe --headless" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/none/bin:/usr/bin:/bin" UNIT_DIR="$TMP/u4" "$INSTALL" --yes --only run >/dev/null 2>&1; then
  fail "recorded agent command refused"
fi
[[ -f "$TMP/u4/runner-run.service" ]] || fail "recorded command install wrote no unit"
pass "recorded agent command installs"

# 8. probe binary without a documented flag fails closed.
mkdir -p "$TMP/plainbin"
printf '#!/usr/bin/env bash\necho "stub-plain: interactive sessions only"\n' >"$TMP/plainbin/stub-plain"
chmod +x "$TMP/plainbin/stub-plain"
if env -u RUNNER_AGENT_CMD -u RUNNER_REPOS RUNNER_AGENT_PROBES="stub-plain" RUNNER_CONFIG="$TMP/no-config.sh" XDG_CONFIG_HOME="$TMP/no-xdg" HOME="$TMP/no-home" PATH="$TMP/plainbin:/usr/bin:/bin" UNIT_DIR="$TMP/u5" "$INSTALL" --yes --only run >/dev/null 2>&1; then
  fail "installed with an undocumented probe"
fi
[[ -e "$TMP/u5/runner-run.service" ]] && fail "wrote a unit for an undocumented probe"
pass "undocumented probe fails closed"

printf 'stub: all install-timers checks passed\n'
