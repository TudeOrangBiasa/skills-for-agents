# Playbook: refactor

A behavior-preserving change to structure: rename, extract, inline, dedupe, move. The structure changes, the behavior does not. A cleanup that reveals a missing feature or a real bug splits it out: ship the structural change first against the pinned behavior, then route the rest to feature or bug.

1. Pin the behavior first. Ground in the affected code, then write a characterization test, snapshot, or before/after output diff that captures what it does today. No coverage means you write the pin before any structure moves. A type check or lint pass is not a pin.
2. Name the shape the code is missing: call the Skill tool with "codebase-design". The reshape must delete branches, invalid states, or layers, never add indirection. Code whose shape is already clear and local stays as it is.
3. Subtract before you add: dead code, one-caller wrappers, duplicate validation, orphan references go first, in their own commit.
4. Move in small steps, each keeping the pin green. Reshaping an internal API means migrating every caller and deleting the old one in the same wave: no shims, no parallel old and new paths. Grep every rename across code, strings, config, and docs. Delegate the mechanical edits per section 6 with the file paths, the names moving, and the pin to keep green.
5. Prove behavior is unchanged on the real artifact: the pin, the full test suite, and one run of the real surface (the page, the endpoint, the command).
6. Keep it only if a reader now has less to trace: fewer layers, fewer branches, less hidden state. No measurable drop means revert.
7. Order the commits: subtraction, then the reshape, then follow-on cleanup. Unslop gate, then PR body with the pin and its result as evidence, then `playbooks/opening-a-pr.md`.

**Reply:** the structure that changed, the pin you held it against, the proof, what got simpler for the next reader, and what you reverted. No new behavior.
