# Writing skill content

There is no separate docs tree in this repo: each `SKILL.md` plus its co-located reference files is the single source of truth. Never duplicate skill content into a second location. This file covers how to write the inside of a skill (its body and its reference files). Structure, frontmatter, and invocation mechanics live in [writing-for-agents](./SKILL.md) and [SKILL-MECHANICS.md](./SKILL-MECHANICS.md).

Most skills are **user-invoked**: the agent will never fire them, so *you* are the index that has to remember they exist and when to reach for them. That memory is **cognitive load**. Clear skill content relieves it: a reader who opens the skill can hold it in their head, know when to reach for it, and see where it sits in the system. The folder `README.md` files are collectively a distributed router; each entry is a node.

Act whenever a skill is added, renamed, or has its behaviour changed: update its `SKILL.md`, its folder `README.md` entry, the top-level `README.md` entry, and `guide` if it is user-reachable. A rename moves the folder too (`skills/<invocation>/<old>` → `skills/<invocation>/<new>`).

Links between skills are repo-relative (`[guide](../user-invoked/guide/SKILL.md)` style). Links to outside this repo stay absolute.

## Content structure

Fill the template below, keeping its order. The **fixed frame** (`## What it does`, `## When to reach for it`, `## Where it fits`) appears in every skill body. `## Prerequisites` and the free-form substance sections carry only what this particular skill needs; delete the rest.

Four sections make a skill worth reading: `What it does`, `When to reach for it`, `Common questions`, `It's working if`. The first two orient the reader; the last two are where the skill stops summarising itself and starts answering the reader's own situation. Each of the last two has a bar to clear, below, but treat content that clears neither as unfinished, not as finished-and-short.

**A skill body carries no install commands.** Install wording lives in [the install block](./install-block.md) and the top-level `README.md`, never inside a skill.

<content-template>

## What it does

One or two plain-language paragraphs. Lead with the skill's one-sentence job, then state the **defining constraint**: the single fact that makes this skill behave differently from the obvious default (for `to-spec`: it does not interview the user again, it synthesises what is already known). Write it as a plain declarative sentence, never a labelled aside like "The defining constraint:" or "The key thing:"; the formula reads as filler. This line is the most valuable in the skill; never omit it.

## When to reach for it

How and when you reach for the skill, in two beats that are both effectively always present:

- **Invocation mode.** State whether you type it or the agent fires it. A user-invoked skill: "You invoke this by typing `/<name>`, and the agent won't reach for it on its own." A model-invoked skill: "Type `/<name>`, or the agent reaches for it automatically when a task fits."
- **Trigger boundary.** The index entry: "reach for this when …". Where the skill is confusable with a sibling, add the other half: "for <X> instead, use `<sibling>`," linked repo-relatively.

## Prerequisites

Optional: include only when the skill needs something in place to be functional; omit the heading entirely otherwise. Covers: a **workspace it writes into** (a stateful skill like `discuss-with-docs` writes `CONTEXT.md` and ADRs; `teach` builds a whole directory, so say what it writes and where), **prior setup** (`triage`/`to-spec`/`to-tickets` need `setup-matt-pocock-skills` to have configured an issue tracker), or **repo-specific tooling**. A stateless skill that runs anywhere has no prerequisites, so drop the section.

## <free-form middle>

One to three short sections, in the skill's *own vocabulary*, that make it click. Choose whatever headings fit the skill: the loop it runs, the artifact it produces, the fork it makes, the one anti-pattern it kills. There is no prescribed heading; the skills are too heterogeneous for one.

The single non-negotiable: **surface the skill's leading word / defining idea** (`tight` feedback loop, `deep module`, throwaway-code-answers-a-question, red-green). It pays off twice: the reader learns what the skill *is*, and learns the word they'll later think with to *reach for* it.

## Common questions

The questions readers really ask about this skill, each in bold with the answer in the lines beneath it. No sub-headings.

An observed question always beats an invented one, so go and find them before you write any:

- **This repo's issues.** Search the tracker for the skill name. A question filed twice is a question the skill owes an answer to.
- **`CHANGELOG.md`.** Anything renamed, moved, or behaviourally changed generates a "where did it go?" that the skill has to answer.

Where the hunt comes up thin, the section may also carry a question a reader would plainly ask, but **the count stays honest to the evidence**. A well-discussed skill earns six; an obscure one earns one or two, or none at all. Padding a thin skill out to match a rich one is how the section fills with questions nobody has, and an invented question teaches the reader nothing.

Order them by how often each comes up, sharpest first, and say the unflattering thing where it is true: a very long interview session usually means the scope was too big; a model asked to write its own skill produces something verbose. Omit the heading where there is nothing worth answering.

## It's working if

A few bullets naming what the reader sees when the skill is doing its job. The bar on each is that the reader can check it without opening `SKILL.md`: a signal in their own work, or in the trace in front of them. "The document gets shorter as it gets better" passes; "the library section is byte-identical to `template.sh`" is a compliance check on the skill's internals wearing this section's name. Include it wherever the tells are crisp; omit the heading where they stay vague.

## Where it fits

Always present. Situate the skill in the system in a sentence or two:

- **Role.** Name it: a **chain step** (`discuss-with-docs → to-spec → to-tickets → implement → code-review`), a **run-once setup** (`setup-matt-pocock-skills`), **periodic maintenance** (`improve-codebase-architecture`, "every few days"), or a **reach-for-it-anytime standalone** (`diagnosing-bugs`, `prototype`, `resolving-merge-conflicts`). A standalone's map is one honest sentence, which is far better than omitting the section.
- **Neighbours.** The one or two siblings that matter, each with a because-clause, linked repo-relatively.
- **The map.** Point to `guide`, the router over the whole set, so this skill stays a node and never has to redraw the graph.

</content-template>

## Conventions

- Explain the **why**, not the process. Skill content orients and situates; reference sections never reproduce another skill's steps or template dumps: a human choosing a tool does not need the runbook.
- **Never name the author.** The skill is a technical document, not a record of who said what. A finding from the question hunt is worth keeping; its attribution is not. State the substance as a plain claim about the skill and drop the frame. Quoting a *user* stays fine: "one user reported …" is evidence about the skill in the wild, and stays anonymous.
- Use the skill's **leading words** (_seam_, _deep module_, _tracer bullet_) so the skill and its references speak one language.
- **Branches go in a table or a list, never in a paragraph.** Where the content presents a choice (two artifacts the skill can produce, four situations that trigger it, five options at a boundary), the reader is scanning for the one row that matches their situation. A paragraph makes them read all of it to find out. A short markdown table (condition in the left column, what to do in the right) or a bulleted list gives it back in one glance. This applies wherever the branch appears, most often in `## When to reach for it` and the free-form middle.
- Keep the skill itself low-load. It is documentation *about* low-cognitive-load skills; furniture (spare headings, restated links) is the thing it is arguing against.

## Done when

- The skill lives at `skills/<user-invoked|model-invoked>/<name>/SKILL.md`, matching its frontmatter invocation.
- The skill carries no source link and writes no install command of its own.
- `## What it does` states the defining constraint, as plain prose rather than a labelled aside.
- The skill names no author and quotes no author: every claim stands on its own.
- `## When to reach for it` states invocation mode and the trigger boundary.
- `## Where it fits` names the role and links to `guide`.
- A prerequisite (workspace, prior setup, tooling) is stated where one exists, and the section is absent where none does.
- The middle surfaces the leading word.
- Every multi-way branch is a table or a list, not a paragraph the reader has to read in full.
- The hunt for real questions ran (the issues, the changelog), and `## Common questions` is sized to what it found, not padded to match a richer skill.
- Every `## It's working if` bullet is checkable without opening `SKILL.md`.
- The sections appear in the template's order.
- Every link resolves.
