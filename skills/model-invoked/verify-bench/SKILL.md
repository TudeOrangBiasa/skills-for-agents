---
description: Vet a perf measurement (limiter, tuning, limits, errors, repeatability, relevance, did-it-happen) before reporting or acting. Use for benchmarks and speedup claims.
name: verify-bench
---
# Benchmark checklist

Vet a perf measurement before reporting or acting on it: a PR before/after, a regression claim, a hillclimb harness, a library or config choice. Answer each question with run evidence, never a guess about code. `perf-issue` vets its baseline and every later number through this list; `hillclimb` vets its harness before freezing.

Ballpark rule: a quick estimate the user asked for takes one run, still checks errors and did-it-happen, says it is one run, and skips the rest unless the run looks wrong. A choice between options is never a ballpark.

## Before running

Write the claim in shippable words ("export is 30% faster at p50 on the 60k-row dataset"); the questions test that sentence. Read the measurement script: what it times, counts, ignores. Check machine load and cores; a busy machine means interleaving both sides in the same noise and saying so.

## The questions

1. **Why not double?** Name the limiter from a profiling run (not the reported one), map it to source. Watch the load generator: saturated generator means you measured the generator. An unmoved number needs its limiter found before calling the change useless.
2. **Was it tuned?** Every side runs as production does (builds, flags, env, pools, warm caches, versions, data). One side on defaults compares configurations, not implementations. Untunable means no winner from that run.
3. **Did it break limits?** Do the arithmetic (bytes vs bandwidth, ops times cost vs cores, saved time vs piece time). Past a limit measured something else (cache, no-op, bug).
4. **Did it error?** Count failures and wrong outputs, not just present ones. Fast rejections and slow retries both lie; add the count when the script lacks it.
5. **Does it reproduce?** Each side at least 5 runs, alternating, median and range reported. Gaps under run-to-run variation are no measurable difference.
6. **Does it matter?** Next to any micro result, measure the end-to-end waited path at realistic size and concurrency; report micro as a share of the whole.
7. **Did it even happen?** Confirm the work ran inside the timed region (requests reached, rows written, bytes read, results used). Lazy or timed-out work produces numbers for nothing.

## Report

Lead with the verdict (faster, slower, no measurable difference, inconclusive) plus number with unit, run count, range, and limiter. Inconclusive when the limiter is unnamed, a side ran untuned, or errors/happening went unchecked; name the gap. PR bodies carry one primary number; runs, range, and limiter live in a linked artifact.
