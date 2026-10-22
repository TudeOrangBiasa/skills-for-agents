---
"skills-for-agents": patch
---

Fix `user-manual` against a real browser review: viewport presets use Playwright `width`/`height`, images resolve under `shots/`, built HTML fails the build when an image does not load, annotation boxes subtract the target origin (measured before the screenshot on one scroll position), the blank-band gate measures leading/trailing edges inside the content box so deliberate padding never fails the build, PDFs get an empty header template plus timestamp normalization for byte-identical rebuilds, and `manual verify` re-checks every box against live selectors with the same visibility treatment. New `user-manual-e2e` CI job builds the fixture twice and asserts determinism, image loading, gate, overlap (including a 40px shift), missing-selector failure, and freshness.
