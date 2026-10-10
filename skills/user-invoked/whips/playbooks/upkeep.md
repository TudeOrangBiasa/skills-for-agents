# Playbook: upkeep

Codebase health on a spare moment, not feature work. Survey for deepening opportunities, design the chosen one on the bench, feed it back as an idea.

1. Survey: call the Skill tool with "codebase-design" and list deepening opportunities (shallow modules, leaky seams, logic spread across callers) with file pointers. This step only finds candidates; it changes nothing. When the user wants the visual HTML report, tell them to run `/deepen` instead.
2. Discuss through the one the user picks. An opportunity nobody will defend is dropped, not parked.
3. Design the chosen one with the `codebase-design` vocabulary: module, interface, depth, seam, adapter, leverage, locality. A lot of behavior behind a small interface at a clean seam, or it is not deep.
4. The design becomes an idea: when it earns a build, tell the user to take it into `/discuss-with-docs` with the survey plus the design attached as its map.
5. Small, safe shapings found along the way land directly with tests plus review through `playbooks/opening-a-pr.md`, never smuggled inside an unrelated diff.
