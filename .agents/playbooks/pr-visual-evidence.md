---
extends: [opening-a-pr]
when: A ticket that changes UI surface, where the PR body must carry visual proof.
---

- **After** "Body: a one-minute briefing under 40 lines with these `##` headings in order, dropping empty ones" add: for a UI ticket, append `## Evidence` after `## Verification` and never drop it: a before/after table, native 1x screenshots at matched viewport and crop, video when motion matters. A UI PR body without images is incomplete, so the PR is not ready to open until they are attached.
