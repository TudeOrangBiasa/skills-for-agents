# Nightshift adapters

Each adapter only decides when `scripts/nightshift.sh run` is called. All of them share the same config, lock, and history, so you can switch adapters or run two at once (the lock keeps runs from overlapping). Below, `NS` stands for the absolute path to `scripts/nightshift.sh` in your installed copy of this skill.

Run `NS setup` in a terminal before any adapter. A scheduled run never asks questions; with no config it fails and its log says to run setup.

## Manual

```bash
NS check     # is anything eligible?
NS run       # do it now
NS status 20 # last 20 outcomes
```

## systemd user timer (Linux)

Survives a closed laptop: `Persistent=true` makes systemd start a missed run right after the next boot or resume ([systemd.timer](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html)). Pair it with `NIGHTSHIFT_WINDOW` if a catch-up run at 09:00 on campus is not wanted.

`~/.config/systemd/user/nightshift.service`:

```ini
[Unit]
Description=nightshift: ready issues to draft PRs

[Service]
Type=oneshot
ExecStart=/bin/bash -lc 'NS run'
```

`~/.config/systemd/user/nightshift.timer`:

```ini
[Unit]
Description=nightshift schedule

[Timer]
OnCalendar=*-*-* 23:30
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
systemctl --user daemon-reload
systemctl --user enable --now nightshift.timer
loginctl enable-linger "$USER"   # keep user timers running while logged out
journalctl --user -u nightshift  # the run summary lands here
```

`bash -l` loads your login environment, so provider keys exported in `~/.bash_profile` reach the agent. Keys set only in an interactive shell rc file do not.

## cron

```cron
30 23 * * * /bin/bash -lc 'NS run' >> "$HOME/.local/state/nightshift/cron.log" 2>&1
@reboot sleep 300 && /bin/bash -lc 'NS run' >> "$HOME/.local/state/nightshift/cron.log" 2>&1
```

Plain cron does not catch up a missed night; the `@reboot` line does it on the next boot. A run with nothing eligible costs one `gh` call per repo.

## Orca automation

Orca here means the agent development environment by Stably ([onorca.dev](https://www.onorca.dev/), [stablyai/orca](https://github.com/stablyai/orca)), not the GNOME screen reader. On Linux its CLI is `orca-ide`, because the screen reader owns `/usr/bin/orca` ([CLI overview](https://www.onorca.dev/docs/cli/overview)).

### What is verified

From the docs and source as of October 2026:

- Triggers are time based only: presets `hourly`, `daily`, `weekdays`, `weekly`, a 5-field cron expression, or an RRULE, with `--timezone` ([Scheduled automations](https://www.onorca.dev/docs/cli/automations), [`src/cli/specs/automations.ts`](https://github.com/stablyai/orca/blob/main/src/cli/specs/automations.ts)). A run is either `scheduled` or `manual`; there is no GitHub label or issue event trigger ([`src/shared/automations-types.ts`](https://github.com/stablyai/orca/blob/main/src/shared/automations-types.ts)).
- An automation launches an agent with a prompt, not a shell command. `--provider` picks the agent (OpenCode is `opencode`).
- `--precheck <command>` runs before each scheduled run; exit 0 continues, anything else records `skipped_precheck`. Manual runs skip it. Default timeout 60 s, maximum 600 s ([Scheduled automations](https://www.onorca.dev/docs/cli/automations), [PR #3266](https://github.com/stablyai/orca/pull/3266), [`src/shared/automation-precheck.ts`](https://github.com/stablyai/orca/blob/main/src/shared/automation-precheck.ts)).
- Orca has to be running. The scheduler ticks every 60 s and dispatches to the desktop window or to a headless `orca serve` runtime; with neither, the run is `skipped_unavailable` ([`src/main/automations/service.ts`](https://github.com/stablyai/orca/blob/main/src/main/automations/service.ts)).
- Missed runs: one catch-up run if Orca comes back within the grace window, else `skipped_missed`. The default grace is 720 minutes; change it with `--missed-run-grace-minutes` ([Scheduled automations](https://www.onorca.dev/docs/cli/automations), [`automation-definition-operations.ts`](https://github.com/stablyai/orca/blob/main/src/main/persistence/scheduling-automations/automation-definition-operations.ts)).
- Worktrees: `--repo` creates a new worktree per run; `--workspace <selector>` runs in an existing worktree, and `--reuse-session` continues the previous live session there ([Scheduled automations](https://www.onorca.dev/docs/cli/automations)).
- Results: run history with status, output snapshot, and precheck output, in the Automations page and via `orca-ide automations runs --id <id> --json` ([Scheduled automations](https://www.onorca.dev/docs/cli/automations)).
- Model: an automation has no model field. `--extra-agent-args="--model ..."` exists but accepts only Claude, Codex, CodeBuddy, Cursor, Grok, and OMP ([`src/shared/automation-extra-agent-args.ts`](https://github.com/stablyai/orca/blob/main/src/shared/automation-extra-agent-args.ts)). For other agents, the agent runs on its default arguments from **Settings → Agents** ([Supported agents](https://www.onorca.dev/docs/agents/supported)). A per-automation `--model` is requested in [issue #13843](https://github.com/stablyai/orca/issues/13843) and proposed in [PR #21811](https://github.com/stablyai/orca/pull/21811), both still open.
- Concurrency: no per-automation overlap guard was found in the automation service. Nightshift's own lock covers it.

### Recipe

Orca launches an agent, so the Orca agent is a thin caller: its only job is to run `NS run` and report the summary line. The real work runs in nightshift's own worktrees with the agent and model from your nightshift config.

1. In Orca, add any local checkout as a project (the skills repo works). Note a worktree selector for it, for example `path:/home/you/code/skills-for-agents`.
2. Set the caller agent's model in **Settings → Agents → OpenCode → default arguments** (or whichever agent you pick), for example `-m <your-model>`. This setting applies to every Orca session of that agent.
3. Create the automation disabled, run it once, then enable it:

```bash
orca-ide automations create \
  --name "nightshift" \
  --trigger "30 23 * * *" \
  --timezone Asia/Makassar \
  --provider opencode \
  --workspace path:/home/you/code/skills-for-agents \
  --precheck "NS check" --precheck-timeout 120 \
  --prompt "Run this shell command and nothing else: NS run. Then reply with its last line verbatim. Do not edit files, open PRs, or run other commands." \
  --disabled --json
orca-ide automations run <id> --json
orca-ide automations runs --id <id> --json
orca-ide automations edit <id> --enabled --missed-run-grace-minutes 600 --json
```

The precheck makes a night with nothing eligible a `skipped_precheck` row that spends no agent tokens.

### Orca gaps to know

- Laptop off or Orca quit at the scheduled time: nothing runs until Orca is open again, then one catch-up within the grace window. If Orca stays closed past the grace window the night is `skipped_missed`, and the systemd timer is the more reliable choice.
- The caller agent's model comes from a global Orca setting, not the automation, until #13843 lands.
- The caller agent needs permission to run the shell command unattended. Check its default arguments or permission mode in Orca.
