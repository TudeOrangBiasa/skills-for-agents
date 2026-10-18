---
description: "Periodic upkeep for a project's verification skill: source wave plus live pass per feature, at most one PR of proven corrections. Use to audit the verify skill."
disable-model-invocation: true
name: maintain-verification
---
# Maintain verification

Periodic pass keeping a project's verification skill and feature map honest (built by `/create-verification` or equivalent). The unit of rigor is the feature: cover every feature from source and live, without terminalising every bullet. Outcomes: `clean` (covered, nothing to ship, no branch or PR), `changed` (one PR of proven corrections), `blocked` (coverage unfinished or unsafe to ship, with the exact blocker).

Edit scope: the verification skill's own directory only (its SKILL.md, features, owned harness scripts). Never product code: behavior the map describes but the app no longer does is doc drift (fix the map) or a product regression (report it, never paper it over).

## Pass

0. **Locate.** The project-local skill with launch/drive sections and a feature map. Several candidates means asking which; none means stopping and pointing at `/create-verification`.
1. **Index hygiene.** Map README against its files: missing, extra, duplicate, dead entries fixed lightly.
2. **Source wave.** One read-only investigator per feature file, concurrent: how the feature works from source, likely drift with citations, one live-verification recipe each. No driving, no edits.
3. **Reconcile.** Merge recipes into the fewest app states practical; spot-check cited drift; sweep recent churn for user-facing surfaces missing from the map (concrete source path required to call one missing).
4. **Live pass, always.** Even with clean source. One driver for servers and UIs (serial, long-lived instance) or isolated sessions per drive for short-lived CLIs, per the skill's own launch model. Hold throughout: doctor before first drive and after any failed drive (reset or relaunch past what doctor can see); captured evidence re-checked at its named location after every cleanup; nothing started outlives its drive (residue cleaned even on stuck, exited, or shared sessions). Doctor failures from skill drift mean fixing under edit scope and retrying once. Unreachable features are `verified-unreachable` only with the concrete prerequisite and route attempted; a map omitting it is drift. Harness fixes get re-driven live before shipping. Teardown after the last drive, evidence stays.
5. **Triage.** Wrong or missing user-POV description is doc drift (fix). Drivable-but-undrivable behavior is a harness gap (fix; helpers stay executable with documented invocation). Actually broken app behavior is a product gap (record for the user, out of this PR).
6. **Ship or stop.** Changed: one PR of proven corrections, every changed file re-read first. Clean or blocked: no PR, honest coverage report. Concise run notes live in worktree scratch, never committed.
