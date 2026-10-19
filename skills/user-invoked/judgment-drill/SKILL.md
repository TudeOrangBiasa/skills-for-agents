---
description: "Train taste with A/B picks: agent builds two versions, you choose with reasons, rubric grades you. Use for code or UI judgment."
disable-model-invocation: true
name: judgment-drill
---
# Judgment drill

Train taste, not throughput. The agent builds, you judge, the rubric grades your judgment. Use for code or UI where "looks fine" is not yet a reliable signal.

## Steps

1. **Two versions.** The agent produces version A and B of one small thing (a function, a component, a paragraph), differing in exactly one design decision it names privately, never in the presentation. Order randomized.
2. **You pick with reasons.** Choose one and state why in two to three sentences: what is better, and what specifically makes it so. "Feels cleaner" without a pointer is not a reason.
3. **Rubric reveal.** The agent opens its rubric (the named decision plus two decoy criteria it also scored), grades your reasons against it, and shows both versions' scores.
4. **Log the miss.** Patterns you miss twice go to future lesson material (`/teach`) or a note in the workspace. A drill that teaches nothing new three times running means the level is wrong: raise the subtlety or stop drilling this axis.

## Rules

- One decision per drill. Two differences means guessing which mattered.
- Small stakes only: drills train judgment, never ship product. Version output stays in the drill, out of branches.
- The agent never hints mid-pick. No leading adjectives, no telling order, no emphasis that leaks the answer.
