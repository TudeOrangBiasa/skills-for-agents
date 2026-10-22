---
description: "Sharpen a task, issue, or prompt before work starts: make it deeper, not bigger, then rewrite it. Use when a request is foggy, a ticket brief is thin, or a prompt needs a second pass before /whips runs it."
disable-model-invocation: true
name: sharpen
---
# Sharpen

A task deserves one sharp pass before anyone runs it. Sharpening makes the request deeper, not bigger: same scope, clearer goal, testable acceptance, surfaced assumptions. Then it rewrites the prompt so the run starts clean. Sharpening never executes the task itself; it hands back a prompt ready to run.

## Read the raw material

The task text plus whatever backs it: the issue, the thread, the brief, the linked docs. Quote nothing at length; extract the goal, the constraints already stated, and the parts that are vague or assumed.

## Sharpen, don't widen

1. Name the real goal in one sentence, in your own words.
2. List the acceptance criteria a run must satisfy to count as done. Testable, each one checkable on the real artifact.
3. Surface the hidden assumptions: what the request takes for granted that could be wrong. Mark each as holds, verify-first, or ask-the-human.
4. State what is out of scope, explicitly. Sharpening adds depth (criteria, constraints, edge cases), never breadth (new features, new areas).
5. Push back when the goal itself is wrong: no is an acceptable answer, with the evidence and the alternative.

## Rewrite the prompt

Hand back the sharpened prompt: goal, context pointers (files, issues, docs read this session), acceptance criteria, out of scope, and the first step. Written so a fresh agent can run it with no extra questions, unless a marked ambiguity genuinely needs the human.

Thin fog means a few lines inline; thick fog means a short doc the run reads first.

**Reply:** the sharpened prompt, what got sharper versus the original, and any ambiguity that still needs a human.
