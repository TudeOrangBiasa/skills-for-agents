# Playbook: prototype

A throwaway sketch that settles a decision by observation instead of a question to the user: which layout, which flow, which query, which approach is faster. You own the decision, not the code. The real build follows feature. The one playbook where rule 1's smallest change and the verify bar invert: speed over polish, code quality does not matter, no planning. The rigor is picking the right design cheaply, so propose variations the user never asked for and throw an approach away to try another.

1. Name the decision in one sentence and the options on the table. No decision means no prototype; route to feature.
2. When the design space is open, gather references first: search prior art, summarize a moodboard of themes, palettes, and layouts, and let the user pick directions before building. Skip this when the direction is set.
3. Call the Skill tool with "prototype" and build throwaway in its own scratch directory or `prototype/<name>` branch, never in production source. The lightest stack that shows the idea: a static page for a layout, a script for a query or timing question. No production framework, no tests, no abstractions.
4. Build each real option, not micro variations of one. Put visual options behind one switcher, each variant labeled, so they compare side by side.
5. Observe the thing you are deciding: screenshot each variant and drive the interaction for a visual choice, printed output or timings for a behavioral one. The observation is the test here.
6. Decide. Recommend one option with the evidence and the tradeoff you accept. A product or taste call the evidence cannot settle goes to the user with the options shown.
7. Hand the chosen direction to `playbooks/feature.md` for the real build, or to "architect" first when the shape of the build is still open. The prototype itself opens no PR; its branch or path is linked from the feature PR or issue.

**Reply:** the decision, the options built, the evidence, the tradeoffs, the recommendation, and the scratch path. Say plainly that the prototype is throwaway.
