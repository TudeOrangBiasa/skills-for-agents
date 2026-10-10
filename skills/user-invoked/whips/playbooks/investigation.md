# Playbook: investigation

A read-only question: how does X work, why was Y built this way, are we sure about Z, should we do X or Y. The deliverable is a cited answer, never code.

1. Frame the question in one sentence plus the decision it informs. A question with no downstream decision gets a short answer, not this playbook.
2. Ground in the target subsystem for the working mental model: parallel read-only explorer subagents plus a synthesizer for spanning questions, a single pass for narrow ones. Questions that hinge on outside docs or APIs: call the Skill tool with "research".
3. Trace lineage when the question is about rationale: git log and blame, linked tickets, docs, ADRs. Keep confidence tiers separated (found, inferred, unknown), and convert the findings into Preserve, Change, Avoid, Risk constraints when a change may follow.
4. Competing hypotheses stay explicit when evidence splits. Never average a divergence; name what would settle it (a measurement, a trace, a prototype) and run it when cheap.
5. Synthesize one cited answer with Sources Consulted, including null results. When a build may follow, tell the user the answer is ready to take into `/discuss-with-docs`, since research feeds thinking rather than replacing it.
