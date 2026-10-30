# Models

Optional. Skills that spawn subagents (`/whips` today) read this file to pick a model per role. A missing file or a missing row means the subagent runs on the parent agent's model. Nothing here is a default: every value is the user's choice.

`# budget: <unlimited | large | medium | small | n/a> (<harness effort label, or n/a when the harness names no effort levels>)`

Budget labels stay the same on every harness: `unlimited` (max), `large` (xhigh), `medium` (high), `small` (medium). A harness with no effort ladder writes `n/a`, and every role runs at its plain model. Re-running `/setup-meta` rewrites this file in full: no duplicated rows, retired roles deleted.

| Role | Model | Effort | Speed | Used for |
| --- | --- | --- | --- | --- |
| `code` | `<model id as your harness names it>` | standard | standard | Routine implementation and mechanical edits |
| `hard-code` | `<model id>` | one step up | standard | Cross-cutting design, concurrency, subtle algorithms |
| `judgment` | `<model id>` | standard | standard | Planning, prose, PR bodies, risk calls |
| `review` | `<model id>` | standard, never below `code` | standard | Second-opinion review; a different model when you have one, otherwise a fresh context with an adversarial brief, reviewers differing by lens never by model |
| `how-explorer` | `<model id>` | standard | standard | One angle of a `how` exploration |
| `how-explainer` | `<model id>` | standard | standard | Synthesizes explorer findings into fixed sections |
| `why-investigator` | `<model id>` | standard | standard | One evidence source for a `why` investigation |
| `why-synthesizer` | `<model id>` | standard | standard | Merges findings into confidence tiers |
| `swarm-worker` | `<model id>` | follows `review` | standard | One parallel worker in a `swarm` fan-out |
| `arena-runner` | `<model id>` | standard | standard | One candidate in an `arena` bakeoff |
| `architect-runner` | `<model id>` | standard | standard | One design sketch in `architect` phase B |
| `interrogate-reviewer` | `<model id>` | standard, never below `code` | standard | One adversarial reviewer in an `interrogate` panel |
| `reflect-reviewer` | `<model id>` | standard | standard | One lens reviewer in a `reflect` fan-out |
| `reflect-synthesizer` | `<model id>` | standard | standard | Merges `reflect` findings into Accepted, Rejected, Backlog |

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
| `how-explorer`, `how-explainer` | `inherit` | medium | standard |
| `why-investigator`, `why-synthesizer` | `inherit` | medium | standard |
| `swarm-worker` | `inherit` | medium, follows `review` | standard |
| `arena-runner`, `architect-runner` | `inherit` | medium | standard |
| `interrogate-reviewer` | `inherit` | medium, never below `code` | standard |
| `reflect-reviewer`, `reflect-synthesizer` | `inherit` | medium | standard |
