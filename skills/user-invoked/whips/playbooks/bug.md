# Playbook: bug

A reported defect, reproduced first, root-caused, fixed with runtime evidence.

1. Reproduce first on the same surface the report used. No repro means no fix, only a diagnosis note with the closest failing signal found.
2. Trace to root cause: call the Skill tool with "diagnose". One tight feedback loop that already goes red on this bug, then ask why until the cause, not the symptom. Resist guards that silence the crash.
3. Blast radius: name the one safety fact the fix depends on (who else calls this, what data it touches) and prove it by running code. A writeup that sounds right is worthless without the run.
4. When the test path is cheap, call the Skill tool with "tdd": failing test first, then the fix, and the regression test stays.
5. Spanning workstreams means delegate per the feature throughput checkpoint, else implement directly against the brief.
6. Verify the original repro plus the new test on the real artifact, never a proxy.
7. Unslop gate, then PR body with before/after proof of the fixed behavior (pair table plus video when motion matters), then `playbooks/opening-a-pr.md`.
