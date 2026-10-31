---
description: Turn a UI screen recording into an interactive paint timeline page for motion proof on a PR. Fired by the whips ui playbook when a recording beats stills; otherwise leave it unloaded.
name: craft-ui-timeline
disable-model-invocation: true
---
# UI recording timeline

Turn a screen recording into an interactive paint timeline page (video, paint ticks, change flashes): the motion proof a PR attaches when a recording shows the change better than stills (see the `ship-pr` skill).

Requirements: `ffmpeg`/`ffprobe` and `uv` on PATH. Chrome or Chromium only for `preview`.

Everything needed is in this skill directory: `scripts/timeline.py` (one CLI, all steps; dependencies declared inline, `uv run` installs them) and `assets/template.html` (`build` injects data into it). The whips `ui` playbook points here with an explicit path; nothing else loads this skill.

Below, `T` means `uv run <this skill dir>/scripts/timeline.py`. Define it as a shell function, not a variable: zsh doesn't word-split variables. Use the absolute path of the skill directory:

```bash
T(){ uv run "/abs/path/to/craft-ui-timeline/scripts/timeline.py" "$@"; }
```

No recording yet means making one first with [`agent-browser`](https://agent-browser.dev/): `agent-browser record start <out.mp4> [url]`, drive the flow, `agent-browser record stop`.

`WD` is the output folder. If the project has conventions for where collateral goes, follow them; otherwise put `WD` next to the video as `<video-stem>-timeline/`.

## 1. Extract and find candidate paints

```bash
T extract /path/to/recording.mp4 WD     # copies video, writes meta.json (frame timestamps; VFR is fine)
T candidates WD                         # table of frames that differ from the previous frame
```

Each row has the frame index, time, % changed, kind (`change` / `full` / `cursor?`), and the normalized bbox. Small cursor-like changes are hidden (use `--all` to show them).

## 2. Look at the frames, then decide what counts as a paint

Never label from the table alone. Read the sheet images, always including the frame before each candidate so the change is visible:

```bash
T sheet WD --frames 0,4,14,26,61 --name overview          # labelled contact sheets -> WD/sheets/*.jpg
T sheet WD --frames 18,19 --crop 0,0,0.25,0.15 --name zoom # zoom into a small change
```

- **Is a paint:** a visible content or layout change (skeletons appearing, real content replacing skeletons, navigation to a blank page, a new page's first paint, a label or button-state change, browser chrome signaling load state).
- **Is not a paint:** cursor movement, hover highlights, spinner rotation, caret blink, shimmer on skeletons already there. Tiny regions wandering across consecutive frames are the cursor.
- **Animations:** one multi-frame animation is one paint at its final frame, with `"base"` set to the frame before the animation started.
- **Minor paints:** `minor: true` on small in-place updates (a label, a button state, browser chrome). Shorter ticks, muted text.
- **Phases:** group paints by screen or URL. Phases cover 0 to the recording's duration with no gaps; stretches with no change get `"idle": true` (hatched grey, never trimmed: idle time is real time).
- **Metrics:** the first two appear in the caption, so put the most important first (for example "main content", "visually complete").
- **Caveat:** t=0 is the recording's first frame, not navigation start. A first frame already showing UI goes in `notes`.

## 3. Write `WD/paints.json`

```json
{
  "title": "vercel.com/vercel-labs with an SSO redirect",
  "notes": "Recording starts mid-navigation: the dashboard shell is already on screen at t=0.",
  "metrics": [
    {"value": "6.50 s", "label": "main content"},
    {"value": "8.37 s", "label": "visually complete"},
    {"value": "2.53 s", "label": "on Okta"}
  ],
  "phases": [
    {"start": 0.0,   "end": 0.802,  "name": "Dashboard (unauthenticated)"},
    {"start": 0.802, "end": 2.002,  "name": "Vercel SSO gate"},
    {"start": 2.002, "end": 8.468,  "name": "Okta and back"},
    {"start": 8.468, "end": 10.935,  "name": "Idle", "idle": true}
  ],
  "paints": [
    {"frame": 0,  "label": "Dashboard shell: sidebar nav and header skeleton (recording start)"},
    {"frame": 4,  "label": "Projects and usage skeleton cards"},
    {"frame": 19, "label": "Team switcher changes to \"Select Team\"", "minor": true},
    {"frame": 87, "label": "Okta Verify check badge (animates 2.668 to 3.068 s)", "minor": true, "base": 74}
  ]
}
```

`frame` is the decoded index from `candidates` (times come from real timestamps, never hand-computed). Phase boundaries in seconds use the starting paint's `t` and the `extract` duration for the last one. Labels are short and concrete: what appeared, changed, or disappeared, quoting on-screen text.

## 4. Compute and check the change regions

```bash
T regions WD     # move-aware diff for every paint -> regions.json (run `candidates` first: the cursor is learned, not guessed)
T check WD       # boxes drawn on every paint frame -> WD/sheets/check-*.jpg
```

Look at every check sheet: pink means painted, blue means moved, thin grey shows where content moved from. A wrong box usually means a wrong paint choice (bad `base`, hover state inside the paint frame); check that before tuning the constants atop `compute_regions`.

## 5. Build, preview, and open

```bash
T build WD                    # paint thumbnails + WD/index.html
T preview WD --t 6.502        # headless screenshot with boxes frozen -> WD/preview.png
open WD/index.html
```

Read `preview.png` to verify layout and overlay alignment. Re-run `build` after any change to `paints.json` or `regions.json`; re-run `regions` only when paint frames or bases change.

## 6. Trim for presentation (optional)

The timeline keeps real time, idle included. For the PR attach, a shorter cut is kinder: keep the paints, cut the dead stretches.

```bash
T trim /path/to/recording.mp4 --keep 0-12.5,20-35.2 --out WD/presentation.mp4
T concat a.mp4 b.mp4 --out WD/joined.mp4
```

`trim` re-encodes the kept ranges and joins them, writing `*-trim.json` (source, kept ranges, new duration) beside the output. Attach the cut; keep the full recording and its timeline as the source of truth, and say what was cut. Never cut inside a paint: kept ranges cover whole paints with margin.

Page use: arrows step between paints, space plays, `d` toggles flashes, `l` opens the paint list drawer, `f` fullscreen. `#t=6.502` deep-links a time, `?hold` freezes boxes for screenshots. The folder is portable: `index.html`, `recording.*`, `paints/`, plus inputs and debug output (`meta.json`, `paints.json`, `regions.json`, `sheets/`).

## Reporting back

Summarize phases, key metrics, and notables (blank screens, layout shifts shown as moves, long waits). Give the path to `index.html` for the PR body: it is the motion proof when a recording beats stills. Mention the t=0 caveat; times are accurate to ±1 frame.
