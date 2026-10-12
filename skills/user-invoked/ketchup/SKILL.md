---
description: Catch up on everything in this chat since your last message, in plain words, with an executive summary for each action item. Use after a long agent run, or mid-conversation inside any other skill.
disable-model-invocation: true
name: ketchup
---
Fire this when the chat ran ahead without you: catch up on everything since your last message, in plain words, with an executive summary for each action item so you can make the call. Assume you remember your last message and nothing after it. Usable mid-conversation, inside any other skill.

## Gather what changed

Keep this turn read-only, except visuals made for the reply from what you already have. No code changes, no apps or jobs started, nothing posted. Collect the agent work since that message, subagent reports, and messages from anyone else in the chat. Check the current state of each PR, CI run, or agent this chat touched. Say which are still running and which could not be checked.

An action item is a decision or step only you can take: a product choice, an approval, an irreversible action, or access the agent lacks. Include any still waiting on you, even one raised before your last message. Work the agent can still do itself is not an action item.

## Write the reply

Open with one sentence: how many action items there are, or none. Nothing happened and nothing waits means saying so and stopping.

Then what happened, most important first, each result with what it means for you. Skip steps that changed nothing. Work left that the agent can do itself gets one line.

Then each action item as a short executive summary: the decision to make, why it matters now, the options and what each costs, the recommendation, and what happens if you do not answer. Unknown parts are stated, never guessed. Link the detail when there is one; the summary decides without opening it.

Show each action item before-and-after side by side: the current state beside each option, options alone when there is no current state. Visible change means screenshots or video; otherwise a table of numbers, a diff, or a diagram. No visual yet means making one; impossible means saying so plainly. Never invent a number, never draw a screen that was not captured, link only artifacts that exist. Tables, Mermaid, and charts beat dense prose.
