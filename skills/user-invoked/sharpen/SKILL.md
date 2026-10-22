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

Answer four questions before touching the prompt:

1. What would a top professional do that was not asked for.
2. What is the rawest material they would start from.
3. Which specific methods and tools they would use.
4. What, besides you or the user, shows the result is right.

Keep the goal and the acceptance criteria, stated briefly. Choices that belong to the user stay visibly open, never silently settled. Push back when the goal itself is wrong: no is an acceptable answer, with the evidence and the alternative.

## Rewrite the prompt

Hand back only the rewritten prompt: goal, context pointers (files, issues, docs read this session), acceptance criteria, out of scope, and the first step. No commentary around it; the prompt itself carries the sharpening, with user-owned choices left marked as choices. Thin fog means a few lines inline; thick fog means a short doc the run reads first.

**Reply:** only the rewritten prompt.
