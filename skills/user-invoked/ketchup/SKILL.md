---
description: Catch up on everything in this chat since your last message, in plain words, with an executive summary for each action item. Use after a long agent run, or mid-conversation inside any other skill.
disable-model-invocation: true
name: ketchup
---
Fire this when the chat ran ahead without you: catch up on everything since your last message, in plain words, with an executive summary for each action item so you can make the call. Your last message is the line; notifications and subagent results are not your messages. Assume you remember your last message and nothing after it. Usable mid-conversation, inside any other skill.

Plain words, short sentences, no jargon, like one person catching up another. Say what changed for you, not how it was done: "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless you need one to act. Call each PR, branch, or agent by a name you would know, not a label invented for the reply. A fact that needs context to make sense gets the context or gets left out.

## Gather what changed

Keep this turn read-only, except visuals made for the reply from what you already have. No code changes, no apps or jobs started, nothing posted. Collect the agent work since that message, subagent reports, and messages from anyone else in the chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number to show against the facts it comes from, and say so when one gets corrected. Say which are still running and which could not be checked.

An action item is a decision or step only you can take: a product choice, an approval, an irreversible action, or access the agent lacks. List every item still waiting on you, even one raised before your last message, so each decision can be made from this reply alone. Work the agent can still do itself is not an action item. Never make up a call to fill the reply. A step nobody asked for and the work does not need is not an action item: unless it is irreversible and waiting on you, in which case it gets one line and no visual.

For each item collect its link, what it changes for you as a user, the evidence behind the pick, its risk, and the pick itself. One call can cover many items, such as each PR in a set awaiting merge. Write "unknown" for a needed fact you do not have; leave out a link you do not have.

## Write the reply

Spend words on the calls, not the story. Keep what happened under 100 words plus pictures, shorter when less happened; give each item about 30 words. The reply grows with the item count: two items need well under 150 words in all plus pictures, thirty need far more. Never cut an item to fit the length: compress each summary instead, and keep every waiting item listed. A link can add depth, but the reply alone must be enough to decide.

Open with one sentence: how many action items there are, or none. The items give the detail. Nothing happened and nothing waits means saying so and stopping.

Then what happened, pictures first: inline the screenshots and videos the work produced, then any diagram that explains a change. Sum up in one short bullet per thing you asked for, most important first: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud ("Search was slow from a missing index"), name any bug found and fixed on the way, keep each line true when read alone. Skip steps that changed nothing. Never mark something done that still waits on you; leave out anything the action items say. Under the summary, at most three short lines that change what you know or must do, then one line for work left that the agent can do itself.

Then list the action items: ask the call you own (merge, approve, pick) and give the pick, including any step to take first and anything irreversible or prerequisite. Give the number or link of each PR, issue, or agent a call is about. Fit the shape to the call. A call about one item is one bullet: the call, the pick, what it changes for you, the evidence, its risk, the item named once. When items share a call, write the call and the pick once, then one bullet per item, riskiest first: link and name, what it changes, the evidence, its risk. Name an item's pick only where it differs from the call's. Give each item's risk even when low ("Low risk: only the colors change"). Say what waiting costs only when it is more than a delay, such as a deadline or lost data. For a call between options, give every option weighed with what it gets you and what it costs plus the current state when there is one; those costs are the risk, so no separate risk line. Show current state beside each option; options alone when there is no current state.

## Visuals

A visual is a picture: a screenshot, a video, a Mermaid diagram, or a chart of numbers. A Markdown table is not a visual, even with before-and-after columns.

Draw what is easier to grasp as a picture than as sentences: how a design or system works, a PR stack or dependency chain with each state, a before-and-after of a fix, options side by side. Never draw a status list, a list of action items, or boxes with nothing connecting them. Never give a fact twice, in text or across visuals. Keep each visual small enough to read at a glance: at most six boxes, at most eight words each, labels in plain words a person would say. A fact needing a sentence belongs in the text, or nowhere.

Embed screenshots and videos inline when the change is visible, not only as links. A visible change with none gets its summary line marked "No screenshot yet", saying what changed on screen. Draw diagrams from facts at hand: Mermaid for connections, a chart for numbers. No visual yet means making one; impossible means saying so plainly. Never invent a number, never draw a screen that was not captured, link only artifacts that exist.
