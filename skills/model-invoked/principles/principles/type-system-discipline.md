# Type System Discipline

Make the compiler reject what cannot happen, so the code never has to check for it at runtime.

The rule: sum types over bags of optional fields, branded primitives over bare strings, exhaustive matches the compiler verifies. Parse external data into the typed model at every boundary (see `boundary-discipline` for where the boundary sits); never cast past the compiler, push the check up into the type instead. A runtime "should never happen" marks the place a type is too weak.

## Why

Every impossible state the type allows is a case every reader must consider and every future edit must preserve. A handler for a case that cannot happen still needs tests, still shows up in reviews, still breaks when someone refactors around it. Deleting the case from the type deletes all of that work at once. The compiler checks every call site on every build; a comment asking callers to be careful checks none of them.

## When it applies

- Designing a new type, reviewing a function signature, or choosing how to represent a state machine or config shape.
- Two arguments share a primitive type but mean different things (`userId` vs `orderId` as bare strings). Brand them so swapping them fails to compile. Validate once at creation, trust the type downstream.
- Reading untrusted input: RPC payloads, JSON, CLI args, config files, env vars, database rows. Each boundary gets a parse function that turns unstructured input into the typed model; code past the boundary trusts the type.
- A hand-rolled type drifts from the file that owns the shape (protobuf, OpenAPI spec, GraphQL schema, migration, token file). Derive from the authoritative schema instead of keeping a parallel copy.

## Example in this repo

Skill identity is a typed model, not a bare string. A skill is named by its path (`model-invoked/how`), never by a bare word (`how`), so two buckets can hold the same leaf name without collision: the branded-primitive move. `scripts/check-docs.sh` parses the path once at the boundary into bucket and skill name, and every check downstream uses those derived values instead of re-parsing text at each use.
