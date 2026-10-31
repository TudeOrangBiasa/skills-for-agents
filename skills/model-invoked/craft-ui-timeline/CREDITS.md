# Credits

Workflow (extract, candidates, contact sheets, paint rules, paints.json, move-aware regions, build, preview), the timeline page, and the vendored `scripts/timeline.py` plus `assets/template.html` from `ui-recording-timeline` by [rauchg](https://www.skills.sh/rauchg/skills/ui-recording-timeline). Rewritten to this repo conventions: recording via `agent-browser record start/stop`, output wired to the `ship-pr` skill as motion proof, no harness assumptions. Local addition (not upstream): `trim` and `concat` subcommands for presentation cuts, tested against ffmpeg-generated fixtures. Copied in, not depended on, so standalone installs keep working without the upstream source.

Security review (skillspector, static, 2026-10-12): MEDIUM 22/100, four findings, all reviewed. Three subprocess calls use argument lists without shell, targeting only the static `ffmpeg`/`ffprobe`/browser binaries the skill exists to drive; the video path comes from the agent's own CLI argument. No declared-permissions field is our repo's normal skill shape; requirements (`ffmpeg`, `ffprobe`, `uv`) are stated in SKILL.md. Accepted with that note.

Local rename history: `ui-recording-timeline` became `craft-ui-timeline` in #175 (stage-prefix scheme); upstream source names above are unchanged.
