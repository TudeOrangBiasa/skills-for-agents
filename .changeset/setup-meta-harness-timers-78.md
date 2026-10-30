---
"skills-for-agents": minor
---

feat(setup-meta): opt-in harness timers for the runner plus headless omp preset. Section G offers unattended wake only on request: detect omp from its documented flags, never hardcode a harness, and keep Orca an optional note. New install-timers script renders four systemd user units with verify plus manual probe before enable, supports dry-run, pause, resume, idempotent uninstall, and a cron fallback. Runner gains pause and resume plus an omp preset from omp help. Closes #78.
