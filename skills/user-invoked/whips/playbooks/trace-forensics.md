# Playbook: trace forensics

A captured trace or dump with no diagnosis yet. The capture already exists: a fixed dataset to read, not a run to repeat. Read-only, no fix unless asked. Distinct from `runtime-forensics.md`, which instruments the live process.

1. Identify the format and load it with the right tool: a trace parser for cpuprofile and `.json.gz`, a text editor for a spindump, heap tooling for a heapsnapshot. Keep tooling generic so the playbook stays portable. Parse large artifacts in a subagent and keep the reduced finding here (rule 20).
2. Make it queryable before reading it: dump the trace or snapshot into sqlite, one row per sample, frame, or node.
3. Narrow to the cause: frames holding the most time, walked to the hot path; the retainer chain from the leaked object to a GC root; the stuck or blocked thread and its wait reason in a spindump.
4. Attribute to source via the artifact's own symbols: file, symbol, line. A frame with no source mapping is not yet a diagnosis; resolve the symbols or say plainly the artifact does not carry them.
5. Confirm with a paired capture when one exists (diff before vs after). Without one, mark the finding the strongest hypothesis the artifact supports, not a confirmed cause.
6. Hand back a cited diagnosis. Route to `bug.md` (or `diagnose`) once the cause is known. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only forensics`.

**Reply:** the artifact and format, the reduced finding, the source location, artifact paths, whether a paired capture confirmed it.
