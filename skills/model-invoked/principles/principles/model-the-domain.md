# Model the Domain

Name the data shape before logic: a state machine, a typed model, a table or registry. Encode the real domain in a data structure instead of scattering it across conditionals. A structure that matches the domain makes invalid states unrepresentable and deletes branches. Choosing it at write time is cheap; recovering it later reads as a refactor and gets deferred.

## Why

Scattered conditionals that repeat one assumption mean the shape is missing. Every branch is a place the assumption can drift, and no single edit can change the domain because the domain lives nowhere. One structure that matches the domain deletes the branches instead of growing them.

## When it applies

When writing stateful logic, or when code branches a lot or repeats a shape assumption across files. Reach for:

- A state machine instead of scattered booleans, phases, or lifecycle checks.
- A typed model instead of loose parameters or repeated shape assumptions.
- A map, registry, lookup table, or discriminated union instead of branching spread across files.
- A reducer or command/event model instead of ad hoc state mutations.
- A module organized around one body of domain knowledge instead of a sequence such as load, validate, transform, and save. Execution order is not ownership.
- A small module boundary that gathers repeated behavior, ownership, or invariants.
- A queue, cache, index, graph, tree, or normalized collection where the access pattern calls for it.
- Any other structure that fits. When none fits, work out what the code must never allow and how the data gets read, then find the structure that encodes exactly that.

Do not force an abstraction. Prefer boring code if the current shape is already clear, local, and unlikely to grow. Be skeptical of an abstraction that adds indirection without removing branches, duplicated rules, invalid states, or lifecycle risk.

The sign that you skipped this is a new feature that grows an existing if/else chain by one more branch, or a second boolean that must stay in sync with the first. Temporal decomposition is another sign: phase-named modules repeat the same domain rules across steps.

## Example in this repo

Skill metadata is a typed shape with one owner each: SKILL.md frontmatter carries the name and description, `agents/openai.yaml` carries the display contract, and `scripts/check-docs.sh` enforces the name-matches-folder invariant in one place. The alternative is per-skill conditionals scattered across scripts ("if this skill, the name lives here"), each repeating the same layout assumption. When a new check needs skill metadata, it reads the same shape; it does not add another branch that guesses where things live.
