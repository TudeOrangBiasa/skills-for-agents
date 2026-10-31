# Models

Optional. Skills that spawn subagents (`/whips` today) read this file to pick a model per role. A missing file or a missing row means the subagent runs on the parent agent's model. Nothing here is a default: every value is the user's choice.

`# budget: <unlimited | large | medium | small | n/a> (<harness effort label, or n/a when the harness names no effort levels>)`

Budget labels stay the same on every harness: `unlimited` (max), `large` (xhigh), `medium` (high), `small` (medium). A harness with no effort ladder writes `n/a`, and every role runs at its plain model. Re-running `/setup-repo` rewrites this file in full: no duplicated rows, retired roles deleted.

| Role | Model | Effort | Speed | Used for |
| --- | --- | --- | --- | --- |
| `code` | `<model id as your harness names it>` | standard | standard | Routine implementation and mechanical edits |
| `hard-code` | `<model id>` | one step up | standard | Cross-cutting design, concurrency, subtle algorithms |
| `judgment` | `<model id>` | standard | standard | Planning, prose, PR bodies, risk calls |
| `review` | `<model id>` | standard, never below `code` | standard | Second-opinion review; a different model when you have one, otherwise a fresh context with an adversarial brief, reviewers differing by lens never by model |
| `craft-how-explorer` | `<model id>` | standard | standard | One angle of a `craft-how` exploration |
| `craft-how-explainer` | `<model id>` | standard | standard | Synthesizes explorer findings into fixed sections |
| `craft-why-investigator` | `<model id>` | standard | standard | One evidence source for a `craft-why` investigation |
| `craft-why-synthesizer` | `<model id>` | standard | standard | Merges findings into confidence tiers |
| `craft-swarm-worker` | `<model id>` | follows `review` | standard | One parallel worker in a `craft-swarm` fan-out |
| `craft-arena-runner` | `<model id>` | standard | standard | One candidate in an `craft-arena` bakeoff |
| `craft-architect-runner` | `<model id>` | standard | standard | One design sketch in `craft-architect` phase B |
| `review-adversary-reviewer` | `<model id>` | standard, never below `code` | standard | One adversarial reviewer in an `review-adversary` panel |
| `learn-reflect-reviewer` | `<model id>` | standard | standard | One lens reviewer in a `learn-reflect` fan-out |
| `learn-reflect-synthesizer` | `<model id>` | standard | standard | Merges `learn-reflect` findings into Accepted, Rejected, Backlog |

Write `inherit` in the Model column to run that role on the parent model. `inherit` is always valid. Delete a row to get the same result.

Effort and Speed are optional and stay empty unless the harness names effort levels. Leave them blank to run the role's model as-is. When the harness does (a low/medium/high ladder, or model slugs with effort variants), write the level or slug: `/whips` shifts effort one step up for the hardest work and down for routine work, and uses fast speed only for urgent runs. The `review` role stays at standard speed and is never shifted down (whips SKILL.md section 6).

Use the exact id your harness accepts (the string its config or CLI flag takes). Skills copy it through unchanged and never translate it between providers.

## Example: one model, effort per role

Every role on the single confirmed id; effort carries the difference. `review` stays at or above `code`:

`# budget: medium (high)`

| Role | Model | Effort | Speed |
| --- | --- | --- | --- |
| `code` | `<your confirmed id>` | medium | standard |
| `hard-code` | `<your confirmed id>` | large | standard |
| `judgment` | `<your confirmed id>` | medium | standard |
| `review` | `<your confirmed id>` | medium, never below `code` | standard |
| `craft-how-explorer`, `craft-how-explainer` | `inherit` | medium | standard |
| `craft-why-investigator`, `craft-why-synthesizer` | `inherit` | medium | standard |
| `craft-swarm-worker` | `inherit` | medium, follows `review` | standard |
| `craft-arena-runner`, `craft-architect-runner` | `inherit` | medium | standard |
| `review-adversary-reviewer` | `inherit` | medium, never below `code` | standard |
| `learn-reflect-reviewer`, `learn-reflect-synthesizer` | `inherit` | medium | standard |
