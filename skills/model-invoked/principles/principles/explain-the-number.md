# Explain the Number

Before trusting a measured number, name what bounds it from a profile or counters, never from reading code.

## The rule

List what else the number could be measuring (errors, skipped or cached work, noise, a piece too small to matter) and rule each out with evidence. Keep run count, spread, and limiter with the number.

## Why

An unexplained number is a story waiting to mislead. It may measure errors instead of work, cached instead of fresh runs, the load generator instead of the system, or a piece so small that doubling it moves nothing end to end. Acting on such a number spends real effort chasing noise. Naming the limiter turns the number from anecdote into fact: if you cannot say why the result is not twice as good, you do not know what you measured.

Distinct from Prove It Works, which checks that an output is real. This principle checks that a measurement means what you think.

## When this applies

Use this before you measure, and before you trust, report, or act on any number you measured: a speedup, a regression, a throughput, a latency, or an eval result.

Do not use it to stall a decision the existing evidence already settles, or to demand lab rigor for a rough sizing estimate (but then report it as rough, with the spread).

## How to apply

1. Write the decision before you run: name the result that would change a decision, and the noise floor. Stop when the run-to-run spread is larger than the effect.
2. Ask "why not double?": name the resource or code path that bounds the result, such as a core, a lock, the disk, the network, or the load generator itself. Get it from a profile or from system counters taken during a run, then map it to source. A guess from reading code is not a limiter.
3. List what else the number could be measuring, and rule out each one with evidence: errors, skipped or cached work, code that never ran, an untuned side left on defaults, noise, a piece too small to matter end to end.
4. Keep the evidence with the number: run count, spread, and limiter in the notes or a linked artifact.

For a performance number, run the full procedure with the [verify-bench](../../verify-bench/SKILL.md) skill. For an eval result, ask the same of the trials: did every run do the task, does the gap hold across trials and models, and does the scenario matter.

You skipped this when a run started without the result that would change a decision, when the evidence behind a number has no run count, no spread, or no named limiter, or when the time saved is larger than the time the changed piece took.

## Example in this repo

Before reporting that a rewritten gate script is "twice as fast", record run count and spread across repeated runs, name the limiter from timing data (startup cost, a subprocess call, file I/O), and rule out that the new script simply skips files the old one checked. The speedup claim ships with its evidence or not at all.

## Say it in the reply

Name this principle and the choice it changed: the limiter you named, the alternate readings you ruled out, and the run count and spread you kept.
