# Harness

Which agent command and model the runner launches in this repo. Written by `runner.sh setup`; re-run setup to change. The runner reads this file on every run, like `repo-mode.md`.

- **Agent command:** `<full non-interactive command; it sees $RUNNER_MODEL, $RUNNER_PROMPT, $RUNNER_PROMPT_FILE>`
- **Model:** `<model id the user confirmed>`
- **PATH probes:** `<optional space separated binary names for runner.sh detect>`

Setup never invents these values: they come from flags, from this file, or from the user's answers in a terminal. The host config (`~/.config/runner/config.sh`) is a thin override; values set there win for that host only.
