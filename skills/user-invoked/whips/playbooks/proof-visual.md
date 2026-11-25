# Playbook: proof-visual

Motion and manual proof for a PR when stills fall short. Two modes: timeline turns a screen recording into an interactive paint timeline page; manual builds a user manual from a running web app. Tooling lives in `../scripts/proof-visual/`.

## Timeline mode

Turn a screen recording into an interactive paint timeline page (video, paint ticks, change flashes): the motion proof a PR attaches when a recording shows the change better than stills.

Requirements: `ffmpeg`/`ffprobe` and `uv` on PATH. Chrome or Chromium only for `preview`.

Define once per shell (zsh does not word-split variables, so a function, not a variable):

```bash
T(){ uv run "<repo>/skills/user-invoked/whips/scripts/proof-visual/timeline-scripts/timeline.py" "$@"; }
```

`WD` is the output folder (next to the video as `<video-stem>-timeline/` unless the project names collateral elsewhere). No recording yet means making one first (`agent-browser record start <out.mp4> [url]`, drive the flow, `agent-browser record stop`).

### 1. Extract and find candidate paints

```bash
T extract /path/to/recording.mp4 WD
T candidates WD
```

Each row has frame index, time, % changed, kind (`change` / `full` / `cursor?`), and bbox. Small cursor-like changes hide by default (`--all` shows them).

### 2. Look at the frames, then decide what counts as a paint

Never label from the table alone. Read the sheet images, always including the frame before each candidate:

```bash
T sheet WD --frames 0,4,14,26,61 --name overview
T sheet WD --frames 18,19 --crop 0,0,0.25,0.15 --name zoom
```

A paint is a visible content or layout change (skeletons appearing, content replacing skeletons, navigation, label or button-state change, load chrome). Not a paint: cursor movement, hover, spinner rotation, caret blink, shimmer on existing skeletons. One multi-frame animation is one paint at its final frame, with `"base"` set to the frame before it started. Minor in-place updates get `minor: true`. Group paints into gapless phases (idle stretches stay, hatched grey). Times are accurate to ±1 frame; t=0 is the recording's first frame, not navigation start, so a UI-visible first frame goes in `notes`.

### 3. Write `WD/paints.json`, compute regions, build, preview

Write the title, notes, metrics (most important first; first two caption the page), phases, and paints (frame, label of what appeared/changed/disappeared, `base`/`minor` where they apply). Then:

```bash
T regions WD     # move-aware diff per paint -> regions.json
T check WD       # boxes on every paint frame -> WD/sheets/check-*.jpg
```

Look at every check sheet: pink painted, blue moved, thin grey moved-from. A wrong box usually means a wrong paint choice (bad `base`, hover state inside the paint frame); check that before tuning constants.

```bash
T build WD                    # thumbnails + WD/index.html
T preview WD --t 6.502        # headless screenshot -> WD/preview.png
```

Read `preview.png` for layout and overlay alignment. Re-run `build` after any `paints.json`/`regions.json` change; re-run `regions` only when paint frames or bases change. Optional trim for the PR attach keeps whole paints with margin; say what was cut, keep the full recording as source of truth. Report phases, key metrics, notables (blank screens, layout shifts, long waits), the `index.html` path, and the t=0 caveat.

### 4. Timeline checklist

- The recording drives the real user flow end to end, no staged clicks for the camera. `ffmpeg`, `ffprobe`, `uv` on PATH before starting.
- Phases cover 0 to the recording duration with no gaps; idle stretches stay, hatched grey, never trimmed.
- Every paint verified on a check sheet; every label quotes text visible on screen.
- Notes state the t=0 caveat when the first frame already shows UI. Metrics list the two most important first.
- Slop check: no paint for cursor, hover, spinner, or caret; no label the sheet cannot show; no invented load sequence.

## Manual mode

Generate a user manual (guide book, panduan pengguna) from a running web app: deterministic content-cropped screenshots, selector annotations, HTML plus PDF that fails instead of shipping blanks or slop. One command regenerates everything: `../scripts/proof-visual/manual-scripts/manual build` (fixture selftest: `node ../scripts/proof-visual/manual-scripts/manual selftest`, no browser needed). A manual is project work, not a single prompt: split it into tickets (explore, map, capture, verify) and land one per `/whips` run.

### 1. Explore

Drive the running app end to end as each user role would, and read the route table from code. Produce the inventory in a scratch note: every route with its user and purpose, every feature with the behaviour it gives the user, every user journey (login to done, signup to first value, settings change), every business rule with where it is enforced, and what is demo-only (sample data, offline paths, undoable actions). Nothing in the later map may name a route, feature, or rule missing from this inventory; a gap means driving again, never inventing.

### 2. Map

Turn the inventory into the manual map and confirm it before any capture: chapters per user role or journey, steps per chapter with the shot each step needs, the shot list (id, route, target, viewport), and which content blocks the manual carries (feature tables, business rules, route appendix, demo disclosure). Present the map as one page: chapters, shots, blocks. The user approves the map or cuts scope; capture never starts on an unapproved map.

### 3. Manifest

Never write the manifest from scratch: copy `../scripts/proof-visual/manual-fixture/manual.json` as the starter, then fill it from the approved map. A shot names a content target, never a viewport dump: id, route, target selector, viewport (`mobile` 390x844, `desktop` 1440x900), hidden elements, numbered selector annotations. File names equal shot ids. Actions are Playwright ops (`goto`, `click`, `fill`, `select`, `press`, `wait`, `waitFor`, `eval`, `scroll`); a shot with a live clock takes `freezeClock` so two builds byte-match. Shots reused across steps declare `"reuse": true`. Prove the toolchain first with the fixture (`node ../scripts/proof-visual/manual-scripts/manual selftest`, no browser needed), not with your manifest.

### 4. Pre-flight checklist

Run these before the first capture, in order: the app serves at the manifest `baseUrl` from a clean state (seeded data, logged out unless the flow needs auth); every route in the manifest loads without console errors; every annotation selector exists in the DOM on a stable hook (`data-manual` preferred over classes or nth-child); every shot with motion, clocks, or toasts sets `freezeClock` or a `hide` entry; locale chosen (`id` or `en`); one viewport per shot, mobile for flows users do on phones. A missing hook means adding it to the app first, never weakening the selector to a guess.

### 5. Capture and QA

Each shot runs in a fresh browser context (`reducedMotion`, DPR 2); the target selector is captured, never the full viewport. Trim uniform edges to a 16px margin, then fail the build on: a content edge band over 15 percent of content height, a missing annotation selector or a box outside the crop, an image failing to load, a figure taller than a print page, a print page under 40 percent full that is not a chapter end (warning), undeclared shot reuse, output over budget (PDF over 15 MB), or `manual check` finding commits touching the configured UI paths after the capture SHA (stale captures listed per shot). Locales `id` and `en` switch template labels.

### 6. Content blocks

Screenshots prove the clicks; four blocks prove the product: feature tables (one row per feature with claim, proof, closed status label; a Selesai row without proof fails), business rules (rule, how it works, enforcement site; server enforced beats client claimed), route appendix (one row per route from the app route table), demo disclosure (what is sample data, offline, undoable in demo). Each block carries one QA rule: unknown labels, unenforced rules, missing routes, and undisclosed demos fail the build.

### 7. Verify pass

The linter pass that proves the agent screenshotted the right thing. Run all of it, in order, before calling the manual done: `manual check` passes on the capture SHA (no stale captures); `manual verify` re-checks every annotation box against the live app (IoU >= 0.5, same viewport and visibility); every annotation selector resolves to a visible element right now; every feature-table proof (file, route, endpoint) exists; every route in the appendix loads; every chapter step names a shot that built. A single miss stops the pass: fix the app hook, the manifest, or the capture, rebuild, and re-run the full pass.

### 8. Review

Open `review.html`: every final shot with blank ratio and print page, worst first, plus the must-watch list. The agent views the must-watch shots before calling the manual done. The manifest records the app commit SHA and UI source paths; wire `manual check` into CI. Two runs at the same commit produce the same file set.

### 9. Slop gates

Prose slop fails the manual the same way blank screenshots do. Reject and rewrite when any holds: a label that does not quote text visible in its shot; a chapter body describing a step the shots never show; a tips line that is not actionable; a feature row whose proof (file, route, endpoint) does not exist; an annotation whose label names the implementation instead of the user's words; a business rule with no enforcement site. After the rewrite, rebuild and re-open `review.html`: the agent reads every changed shot before calling the manual done.
