#!/usr/bin/env bash
# Stub test for runner setup detect-or-ask (issue #188). No network, no gh auth.
# Covers: flag path persists without presets, harness doc feeds a second
# setup, refusal without a terminal and without values, and a grep gate
# proving no preset table or harness command templates ship.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
RUNNER="$HERE/scripts/runner.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass() { printf 'stub ok: %s\n' "$1"; }
fail() { printf 'stub FAIL: %s\n' "$1" >&2; exit 1; }

mkclone() { # name -> path of a fresh local clone
  git init --quiet "$TMP/$1"
  git -C "$TMP/$1" config user.email t@t.t
  git -C "$TMP/$1" config user.name t
  git -C "$TMP/$1" commit --quiet --allow-empty -m init
  printf '%s' "$TMP/$1"
}
REPO_A="$(mkclone repo-a)"
REPO_B="$(mkclone repo-b)"
export RUNNER_STATE_DIR="$TMP/state" RUNNER_WORK_DIR="$TMP/work"
CONF="$TMP/conf.sh"
export RUNNER_CONFIG="$CONF"

g() { env -u RUNNER_AGENT_CMD -u RUNNER_MODEL -u RUNNER_REPOS -u RUNNER_MODEL_ALLOWLIST -u RUNNER_MAX_ISSUES \
  RUNNER_CONFIG="$CONF" RUNNER_STATE_DIR="$TMP/state" RUNNER_WORK_DIR="$TMP/work" bash "$RUNNER" "$@"; }

# ---------- 1. flag path persists without any preset table ----------

g setup --agent-cmd 'myagent run -m "$RUNNER_MODEL" "$RUNNER_PROMPT"' --model 'stub/model-1' --repos "$REPO_A $REPO_B" </dev/null >/dev/null
for repo in "$REPO_A" "$REPO_B"; do
  h="$repo/docs/agents/harness.md"
  [[ -f "$h" ]] || fail "missing $h"
  grep -qF -- '- **Agent command:** myagent run -m "$RUNNER_MODEL" "$RUNNER_PROMPT"' "$h" || fail "agent command not persisted in $h"
  grep -qF -- '- **Model:** stub/model-1' "$h" || fail "model not persisted in $h"
done
grep -qF "RUNNER_AGENT_CMD=" "$CONF" || fail "flag agent command missing from thin config"
grep -qF "RUNNER_MODEL=" "$CONF" || fail "flag model missing from thin config"
pass "flag path persists consumer harness docs plus thin override"

# ---------- 2. consumer harness doc feeds a bare setup ----------

rm -f "$CONF"
printf 'RUNNER_REPOS=%s\nRUNNER_MAX_ISSUES=1\n' "$REPO_A" >"$CONF"
g setup </dev/null >/dev/null
grep -qF "RUNNER_AGENT_CMD=" "$CONF" && fail "bare setup should not invent an override command"
[[ "$(g status | sed -n 's/^agent:  //p')" == 'myagent run -m "$RUNNER_MODEL" "$RUNNER_PROMPT"' ]] || fail "status does not resolve command from harness.md"
[[ "$(g status | sed -n 's/^model:  //p')" == 'stub/model-1' ]] || fail "status does not resolve model from harness.md"
pass "bare setup reuses the consumer harness doc, override stays thin"

# ---------- 3. refuse when neither detect nor ask can fill values ----------

REPO_C="$(mkclone repo-c)"
rm -f "$CONF"
if g setup --repos "$REPO_C" </dev/null >/dev/null 2>&1; then fail "setup without terminal or values should refuse"; fi
[[ -f "$REPO_C/docs/agents/harness.md" ]] && fail "refused setup must not write a harness doc"
[[ -f "$CONF" ]] && fail "refused setup must not write a config"
pass "setup refuses with no terminal, no flags, and no harness doc"

# ---------- 4. interactive detect-or-ask via pty, then refuse on empty ----------

if python3 -c 'import pty, select, sys; sys.exit(0)' 2>/dev/null; then
  REPO_D="$(mkclone repo-d)"
  rm -f "$CONF"
  printf 'RUNNER_REPOS=%s\nRUNNER_MAX_ISSUES=1\n' "$REPO_D" >"$CONF"
  PTY_OUT="$TMP/pty-out.txt"
  PTY_LOG="$TMP/pty-log.txt"
  python3 - "$RUNNER" "$CONF" "$TMP/state" "$TMP/work" "$PTY_OUT" "$PTY_LOG" <<'PY'
import os, pty, select, sys, time
runner, conf, state, work, out, logpath = sys.argv[1:7]
env = {k: v for k, v in os.environ.items()
       if k not in ("RUNNER_AGENT_CMD", "RUNNER_MODEL", "RUNNER_REPOS",
                    "RUNNER_MODEL_ALLOWLIST", "RUNNER_MAX_ISSUES")}
env.update({"RUNNER_CONFIG": conf, "RUNNER_STATE_DIR": state,
            "RUNNER_WORK_DIR": work, "TERM": "dumb"})
# agent command, model menu (1 = only option, manual), manual model,
# empty allowlist, default issues per run.
answers = [b"ptyagent run \"$RUNNER_PROMPT\"\n", b"1\n", b"ptymodel/1\n", b"\n", b"\n"]
pid, fd = pty.fork()
if pid == 0:
    os.execve("/usr/bin/env", ["bash", runner, "setup"], env)
log = open(logpath, "wb")
def drain(sec):
    end = time.time() + sec
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.5)
        if not r:
            continue
        try:
            chunk = os.read(fd, 4096)
        except OSError:
            return False
        if not chunk:
            return False
        log.write(chunk)
    log.flush()
    return True
drain(3)
for a in answers:
    os.write(fd, a)
    drain(2)
drain(4)
os.close(fd)
_, status = os.waitpid(pid, 0)
log.close()
code = os.waitstatus_to_exitcode(status)
with open(out, "w") as f:
    f.write("code=%d\n" % code)
PY
  [[ "$(sed -n 's/^code=\([0-9]*\)/\1/p' "$PTY_OUT")" == "0" ]] || fail "pty setup exited nonzero, transcript: $(cat "$PTY_LOG")"
  grep -q "No preset table ships" "$PTY_LOG" || fail "pty setup never showed the ask path"
  grep -qF -- '- **Agent command:** ptyagent run "$RUNNER_PROMPT"' "$REPO_D/docs/agents/harness.md" || fail "pty agent command not persisted"
  grep -qF -- '- **Model:** ptymodel/1' "$REPO_D/docs/agents/harness.md" || fail "pty manual model not persisted"
  grep -qF "RUNNER_AGENT_CMD=" "$CONF" && fail "pty setup should not write an override command"
  pass "interactive detect-or-ask persists typed values"
else
  pass "pty unavailable, interactive scenario skipped"
fi

# ---------- 5. no preset table or harness templates ship ----------

if grep -rn --include='*.sh' --include='*.md' -E 'preset_cmd|AGENTS=' "$HERE" | grep -v test-detect-ask; then
  fail "preset table remains in the skill tree"
fi
if grep -rni --include='runner.sh' -E 'opencode|codex|claude|\bmp\b|\bpi\b|\bamp\b|gemini|grok|goose|droid|kimi|qwen|crush|cursor-agent' "$HERE/scripts/runner.sh"; then
  fail "harness command templates remain in runner.sh"
fi
if grep -rn --include='runner.sh' -E 'settings\.json|config\.toml|opencode\.json|\.codex/|\.claude/|\.pi/|\.omp/|opencode models' "$HERE/scripts/runner.sh"; then
  fail "harness-owned config paths remain in runner.sh"
fi
if grep -rni --include='CONTRACT.md' -E 'preset' "$HERE/CONTRACT.md" | grep -vi 'no preset table ships'; then
  fail "CONTRACT.md still documents a preset"
fi
if grep -rni --include='CONTRACT.md' -E 'opencode|codex|claude' "$HERE/CONTRACT.md"; then
  fail "CONTRACT.md still names a harness default"
fi
pass "no preset table, harness templates, or harness config paths ship"
printf 'stub: all runner detect-ask #188 checks passed\n'
