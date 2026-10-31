# Experience First

When implementation convenience conflicts with user delight, delight wins.

## The rule

Ship fewer polished features over more rough ones. Prototype in throwaway form before committing, tighten the core loop, get the details right. The user is whoever consumes the work, including the importing colleague and the next maintainer.

## Why

Implementation convenience compounds into user friction: every rough edge becomes a workaround the user writes, a ticket they file, or a feature they quietly stop using. Delight compounds the other way into trust. A polished experience with three features beats a rough one with ten, because the ten-feature version ships its missing polish as work for the user to do.

Foundational thinking governs the sequence of work. This principle governs the target: what the work is for.

## When this applies

Use this when product, UX, or feature-scope tradeoffs come up: cutting scope, choosing defaults, writing messages, shaping an API. It applies to libraries and internal tools exactly as much as to user interfaces.

Do not use it to gold-plate internals nobody consumes, or to delay a fix the user is already waiting for.

## How to apply

1. Justify every feature, control, and option. Each one must earn its place against the core loop; the ones that do not serve it get cut.
2. Ship less, ship better: cut scope before cutting polish.
3. Prototype before committing: design decisions are cheaper in throwaway form than in production code.
4. Tighten the core loop: every kept feature should serve the central workflow or get out of the way.
5. Get the details right: transitions, alignment, spacing, feedback, error states. The details are the experience.
6. Weigh every consumer as a user: the end user, the colleague who imports the API, the maintainer who reads the code next. Explain impact from their perspective.

## Example in this repo

The docs gate fails with a checklist naming each broken contract and how to fix it, not a bare exit code. The checklist costs the script author an afternoon; it saves every contributor a debugging session. That tradeoff is this principle.

## Say it in the reply

Name this principle and the choice it changed: what scope you cut, what polish you kept, and which user you weighed.
