# Playbook: visual parity

A migration that must stay pixel-identical across implementations. Equivalence is verified by image diff, not by eye. The baseline is the spec and is never touched. Complements `ui.md` (new UI on top of a feature) for migrations matching two implementations.

1. Establish the baseline first, before any migration: screenshot the current components across their states, plus the target when matching two implementations. No baseline, no parity claim; a blocking prerequisite, not a follow-up.
2. Hold the anti-shortcut clauses: no harness modifications, no baseline tampering, no restructuring to make a diff pass. A suspicious baseline means stopping and asking, never editing it.
3. Migrate one component at a time, one owner each (separate worktrees, rule 15). Shared primitives migrate first as a blocking phase.
4. Verify each component against its baseline with an image diff on the matching surface (capture per the `ship-pr` skill). A nonzero diff is a fail: investigate the pixel delta and repeat per component until zero.
5. Open a PR per component or safe batch via `playbooks/opening-a-pr.md`.

**Reply:** components migrated, the diff result for each, the baseline harness location, what is left.
