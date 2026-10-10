# Playbook: prototype

A throwaway sketch that settles a decision by observation instead of a question to the user: which layout, which flow, which query, which approach is faster. You own the decision, not the code. The real build follows feature.

1. Name the decision in one sentence and the options on the table. No decision means no prototype; route to feature.
2. Call the Skill tool with "prototype" and build throwaway in its own scratch directory or `prototype/<name>` branch, never in production source. The lightest stack that shows the idea: a static page for a layout, a script for a query or timing question.
3. Build each real option, not micro variations of one. Put visual options behind one switcher so they compare side by side.
4. Observe the thing you are deciding: screenshots for a visual choice, printed output or timings for a behavioral one. The observation is the test here.
5. Decide. Recommend one option with the evidence and the tradeoff you accept. A product or taste call the evidence cannot settle goes to the user with the options shown.
6. Hand the chosen direction to `playbooks/feature.md` for the real build. The prototype itself opens no PR; its branch or path is linked from the feature PR or issue.

**Reply:** the decision, the options built, the evidence, the recommendation, and the scratch path. Say plainly that the prototype is throwaway.
