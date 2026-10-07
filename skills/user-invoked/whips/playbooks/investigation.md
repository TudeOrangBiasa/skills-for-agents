# Playbook: investigation

A read-only question: how does X work, why was Y built this way, are we sure about Z, should we do X or Y. The deliverable is a cited answer, never code.

1. Frame the question in one sentence plus the decision it informs. A question with no downstream decision gets a short answer, not this playbook.
2. `how` over the target subsystem for the working mental model (parallel explorers plus synthesizer for spanning questions, single pass for narrow ones).
3. `why` for lineage when the question is about rationale: trace git plus tickets plus docs plus chat, keep confidence tiers separated (found, inferred, unknown), and convert the findings into Preserve, Change, Avoid, Risk constraints when a change may follow.
4. Competing hypotheses stay explicit when evidence splits. Never average a divergence; name what would settle it (a measurement, a trace, a prototype) and run it when cheap.
5. Synthesize one cited answer with Sources Consulted, including null results. The file it lands in feeds `/discuss-with-docs`, since research feeds thinking rather than replacing it.
