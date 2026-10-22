---
description: "Generate a user manual from a running web app: content-cropped screenshots, selector annotations, HTML plus PDF build with QA gates. Use for user manual, guide book, panduan pengguna, end-user docs with screenshots, PDF guide."
name: user-manual
---
# User manual

Generate a user manual (guide book, panduan pengguna) from a running web app: deterministic screenshots cropped to content, selector-based annotations, and an HTML plus PDF build that fails on blank screenshots, orphan captions, or stale captures. Use when asked for a user manual, guide book, end-user documentation with screenshots, or a PDF guide.

One command regenerates everything: `scripts/manual build`. The build fails (nonzero exit plus the shot id, page, and percentage) instead of shipping a manual with long blank areas.

## Manifest

One `manual.json` defines chapters, steps, and shots. A shot names a content target, never a viewport dump:

```json
{
  "app": { "name": "Shop", "baseUrl": "http://localhost:3000", "locale": "id" },
  "shots": [
    {
      "id": "c10-done", "route": "/checkout/done", "target": "main",
      "viewport": "mobile", "hide": ["header.site", ".toast"],
      "annotations": [{ "n": 1, "selector": "[data-manual=receipt]", "label": "Nomor struk" }]
    }
  ],
  "chapters": [{ "title": "Pelanggan", "steps": [{ "n": 1, "title": "Selesai", "body": "...", "shot": "c10-done" }] }]
}
```

File names equal shot ids, no combined suffixes. A `sequence` id groups shots that run in manifest order on one page: later shots inherit earlier state unless they set their own `route`. `--only <id>` rebuilds one shot. Actions are Playwright ops (`goto`, `click`, `fill`, `select`, `press`, `wait`, `waitFor`, `eval`, `scroll`); a shot with a live clock takes `freezeClock` (ISO time) so two builds byte-match.

## Capture

The target selector is captured (`locator.screenshot()` or the union clip of visible boxes inside it), never the full viewport or full page. Each shot runs in a fresh browser context (clean localStorage), `reducedMotion`, DPR 2; shots in one `sequence` share a context and run in order instead. Exploration may use `agent-browser`; regeneration always runs the bundled script, or two runs would never match. Presets: `mobile` (390x844), `desktop` (1440x900). Elements with `position: fixed` or `sticky` outside the target are hidden unless listed in `keep`; dialogs capture with their scrim, cropped to dialog plus margin.

## Trim and QA gates

After capture, uniform edge rows and columns are trimmed to a fixed 16px CSS margin; the background color is read from the edge pixels, never hardcoded. Then the blank band is measured inside the content box (union of visible descendants, clipped to the target), not the target padding: padding owned by the target is a design decision, interior gaps are normal typography, and the gate hunts the leading or trailing canvas dump. The build fails when:

- A content edge band exceeds 15 percent of content height (`allowBlank` per shot with a written reason overrides).
- An annotation selector is missing or its box falls outside the crop.
- Any image in the built HTML fails to load (shot id reported).
- A figure taller than a print page (checked in Chromium with print media). Print CSS caps figure art at 225mm so whole figures ride to the next page instead of splitting; `break-inside: avoid` keeps each caption with its figure.
- A print page under 40 percent full that is not a chapter end (warning, with page number and coverage).
- A shot reused without `"reuse": true` on the step (declared reuse is reported, silent duplication fails).
- Any output exceeds its budget (PDF over 15 MB).
- `manual check` finds commits touching the configured UI paths after the capture SHA (stale captures listed per shot).

## Annotations

Boxes are `{ n, selector, label, pad? }` resolved with `boundingBox()` at capture time, stored relative to the crop in a sidecar JSON. Boxes are measured before the screenshot on the same scroll position, and the screenshot origin (the target box) is subtracted, so boxes track their selectors. No hand-written pixel coordinates in the manifest, ever. `manual verify` re-checks every box against the live app (IoU >= 0.5, same viewport and visibility as capture), so drifted boxes fail instead of shipping.

## Build

HTML frames follow the cropped image (phone frame for mobile, desktop frame for desktop), never a forced viewport ratio. Figures keep captions together (`break-inside: avoid`). Locales `id` and `en` switch template labels (Langkah, Tips, page X of Y, contents). Shots reused across steps declare `"reuse": true` on the reusing step. Two runs at the same commit produce the same file set. Every figure carries an `<!-- SHOT id | route | actions -->` trace comment.

## Freshness

The manifest records the app commit SHA and the UI source paths at capture. `manual check` fails when any commit touches those paths after the SHA and names the affected shots. Wire it into CI.

## Review

After the build, open `review.html`: every final shot with its blank ratio and print page, sorted worst first, plus the must-watch list (top blank ratios, most annotations, shots changed since the last build). The agent views the must-watch shots before calling the manual done. Gate numbers alone are never enough.

**Reply:** what was built (page count, shot count, locales), the QA numbers that passed, the must-watch pages reviewed, and anything waiting on the human (stale shots, overridden blanks with reasons).
