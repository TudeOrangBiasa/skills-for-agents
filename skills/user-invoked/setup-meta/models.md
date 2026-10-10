# Models

Optional. Skills that spawn subagents (`/whips` today) read this file to pick a model per role. A missing file or a missing row means the subagent runs on the parent agent's model. Nothing here is a default: every value is the user's choice.

| Role | Model | Used for |
| --- | --- | --- |
| `code` | `<model id as your harness names it>` | Routine implementation and mechanical edits |
| `hard-code` | `<model id>` | Cross-cutting design, concurrency, subtle algorithms |
| `judgment` | `<model id>` | Planning, prose, PR bodies, risk calls |
| `review` | `<model id>` | Second-opinion review; pick a different model from `code` so agreement means something |

Write `inherit` in the Model column to run that role on the parent model. Delete a row to get the same result.

Use the exact id your harness accepts (the string its config or CLI flag takes). Skills copy it through unchanged and never translate it between providers.
