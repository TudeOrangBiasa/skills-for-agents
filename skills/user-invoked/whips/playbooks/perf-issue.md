# Playbook: perf issue

A slow path with numbers to prove. You own the measurement story: plan, review, verify the numbers. Every fix ties to a measurement; never read source instead of measuring.

1. Capture a baseline trace on the matching surface (profiler, automated browser trace, query log). Vet the baseline, and every later number, by rule 19: name what bounds it from a profile or counters, rule out what else it could be measuring, keep run count, spread, and limiter with the number.
2. Ground hypotheses with `how`; never claim a ceiling without running it first. Try the performance mantras in order, cheapest first: don't do it (stop work whose result nothing uses); do it, but not again; do it less; do it later; do it when they're not looking; do it concurrently; do it cheaper. When an earlier mantra meets the target, stop.
3. Plan the fix from the trace. Crosses a function boundary means `codebase-design` first. Delegate implementation per section 6, review the diff rather than typing it, verify each attempt before trying the next (rule 4), and capture a post-fix trace.
4. Compare the artifacts (parse to queryable form, diff). Inconclusive or wrong-surface is not a pass. Flag it.
5. Cite the measurement in the PR (before, after, delta with units). For sustained improvement against a metric rather than a one-off fix, use `hillclimb.md`.
6. Close via `playbooks/opening-a-pr.md`.

**Reply:** baseline number, post-fix number, delta, artifact path.
