# Playbook: runtime forensics

A live process misbehaving with no diagnosis yet. Instrument it, do not theorize from source. Read-only: the deliverable is a cited diagnosis, not a fix.

1. Capture the live signal on the matching surface: a CPU profile for a spinning process, a heap snapshot for a leak, an automated browser trace for a visual glitch. A real artifact, not a guess.
2. Reduce to the smoking gun: the hot-path function, the retainer chain from the leaked object to a GC root, the loop firing without input. Parse large artifacts in a subagent and keep only the reduced finding in this thread (rule 20).
3. Prove the mechanism cheaply before believing it: targeted instrumentation or a live hotfix without reload to confirm the hypothesis.
4. Map back to source: file, symbol, the line that allocates or schedules.
5. Hand back a cited diagnosis, no fix unless asked. Route to `bug.md` (or `diagnose` for a slow path) once the cause is known. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only forensics`.

**Reply:** the signal captured, the reduced finding, how the mechanism was proved, the source location, artifact paths.
