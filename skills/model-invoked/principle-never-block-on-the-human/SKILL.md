---
description: Proceed on reversible work and let the human correct course. Use when tempted to ask permission instead of doing the work and showing the result.
name: principle-never-block-on-the-human
disable-model-invocation: true
---
# Never block on the human

The human supervises asynchronously; the agent stays unblocked. Make reasonable decisions, proceed, show the result, and let the human correct course after the fact. Code changes are reversible and reviewable, so a wrong decision usually costs less than blocking.

Why: each "should I do X" parks the work until the human answers, while a shown result lets the human judge reality instead of a proposal. Momentum compounds; waiting does not.

## The line

- **Proceed, then present.** Do the work, show the result. Never ask "should I do X"; do X and explain why.
- **Reversible work never blocks.** Write code, edit notes, split tasks, run checks. When you spot a problem, log it and fix it in the next round so the system heals itself.
- **Irreversible actions still ask.** Force-push, deleting production data, sending external messages: confirm first.
- **Product direction comes from the human.** Execution never blocks, but calls no experiment can settle belong to the human.

## In this repo

In whips runs, reserve questions for the pause list in `skills/user-invoked/whips/SKILL.md` section 5 and for product calls no experiment can settle. For everything else, proceed and record what you chose in the pause note and run log, so pickup and the human can correct course from evidence.

**Reply:** what you decided without asking and why proceeding was safe, plus anything held for the human and why.
