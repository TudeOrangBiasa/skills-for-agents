# Laziness Protocol

Bias toward deletion and the smallest change that solves the problem. When refactoring, when the diff feels large, or when tempted to add an abstraction, a layer, or signal threading, prefer the lazier move: cut scope, inline the wrapper, pass the plain value.

## Why

Every abstraction is a bet that its generality will pay back its learning cost. Most such bets lose: the second caller never arrives, the layer never varies, and the reader pays the cost forever. Laziness keeps the bet small. The smallest change that solves the problem is also the one easiest to review, revert, and reshape later.

## When it applies

Refactors, diff-size judgments, and any moment an abstraction, layer, or threaded signal tempts you.

In practice:

- Consolidate decisions. Do not repeat the same choice in several places. Put it behind one source of truth and pass the result as a simple flag.
- Minimize the diff. Fewer lines beat elegant boilerplate. The smallest change that solves the problem ships; speculative generality gets cut.

## Where it lives in this repo

Embedded, not a numbered rule: the PRINCIPLES.md header names it as rule 1. The carrier is the subtract-before-you-add file (`./subtract-before-you-add.md`): delete dead code, one-caller wrappers, and redundant checks first, then build the smallest change on the simpler base. Where that leaf sequences removal before construction, this one supplies the judgment inside each step: consolidate the decision, keep the diff minimal.

## Example in this repo

A new trigger row in the `whips` skill entry point tempts a categorization layer: a taxonomy of trigger kinds, a shared renderer, flags threaded through. The lazy move is one more table row behind the existing shape, and a consolidation pass only when the same choice visibly repeats across rows.
