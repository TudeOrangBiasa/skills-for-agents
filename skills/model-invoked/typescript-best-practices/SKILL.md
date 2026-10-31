---
description: TypeScript best practices. Use when reading or editing any .ts or .tsx file.
name: typescript-best-practices
paths:
  - '**/*.ts'
  - '**/*.tsx'
---

# TypeScript best practices

Apply the [type-system-discipline](../principles/principles/type-system-discipline.md) principle (`principles` skill) first.

| Rule | Summary |
|------|---------|
| Discriminated unions | Model variants with a `kind` literal discriminant so impossible states can't be represented. No optional-field bags. |
| Branded types | Brand primitives with `& { readonly __brand: "X" }` so they can't be mixed up. Validate once at the boundary. A brand comes from a verifying type guard (`input is AgentId`), never from `as`. |
| Constructive modeling | Build the shape so the illegal value can't be constructed. `[T, ...T[]]` for non-empty, `[T, T][]` for even length, `start` plus `duration` for a range. Not a runtime guard. |
| Simplest total type | Keep `T[]` while every operation on it stays total. Strengthen only where the loose type forces `!`, a cast, or a "should never happen" throw. |
| `unknown` over `any` | External data is `unknown`. |
| Schemas before guards | Before hand-writing a property-by-property guard, use the repo runtime schema library and infer the type from the schema. |
| No `as` casts | Every `as` is a runtime crash waiting. Cast only after validation. |
| Narrowing hierarchy | Discriminant switch, then `in` operator, then `typeof`/`instanceof`, then user-defined guard, last `as`. |
| Type guards | Must verify the claim. A lying guard is worse than `as`. Name them `isX` or `hasX`. |
| Exhaustiveness | Inline `const _exhaustive: never = x;` in default arms so the compiler errors when a new variant is added. |
| `satisfies` over `as` | Validates the value without widening literal types. |
| Boundary validation | Parse where data crosses in, into a named domain type. Trust types inside. See the [boundary-discipline](../principles/principles/boundary-discipline.md) principle (`principles` skill). |
| Schema-derived types | Reach for `Pick`/`Omit`/`Parameters`/`ReturnType`/`Awaited`/`typeof` before declaring a new interface. |
| Object args | Pass objects, not positional, so argument order is self-documenting. Skip on hot paths. |
| Real tests | Do not mock what you can run. Prefer the real test primitives of the repo. |

This is guidance for the agent, not a linter replacement.
