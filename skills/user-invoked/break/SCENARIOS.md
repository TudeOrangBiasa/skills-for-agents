# Break scenarios

The menu step 2 of [SKILL.md](SKILL.md) selects from. Each axis carries a cue: the property of the component that makes the axis worth running. Cue matches, axis stays; cue fails, axis is dropped and the drop is named in one line.

An axis that stays contributes its scenarios as written here, plus any value the component's own props make obviously worse (the longest option in a real dataset, the noisiest real content).

## Content length

**Cue: the component renders text it does not author.** User input, CMS content, API data, translations. A fixed label the codebase controls fails the cue.

- Empty string: collapsed boxes, floating labels with nothing to float over.
- One word: buttons and badges sized to their longest expected content.
- Typical content: the baseline the others are judged against.
- Several sentences: wrapping, multi-line line-height, containers that assumed one line.
- One unbreakable string: a long URL with no wrap opportunity, overflow behavior.

## Content shape

**Cue: the text can come from users or locales the team does not write in.**

- Emoji, alone and mixed into text: line-height jumps, broken centering, split characters.
- RTL text: direction handling, punctuation on the wrong side.
- Mixed-direction text: an LTR product name inside an RTL sentence, and the reverse.
- Diacritics and tall scripts: clipped ascenders and descenders in tight line boxes.
- Numbers where columns align: proportional figures wobbling in tables and timers.

## Quantity

**Cue: the component repeats over items.** Lists, tables, grids, tag rows, avatar stacks. A singular component fails the cue.

- Zero items: blank regions, missing empty states.
- One item: grids designed around plural content.
- The realistic count: the baseline.
- Ten times the realistic count: missing scroll or pagination, sticky elements unsticking.

## Container

**Cue: always.** Everything renders inside something, and the component does not choose its container's width. Each width is a fixed container on the page, never a viewport to resize.

- A 320px container: clipping, horizontal scroll, escaping controls.
- Squeezed by a flex or grid sibling: min-content blowout, refusing to shrink.
- A very wide container: unbounded measure, stretched controls, content pinned to opposite edges.

## State

**Cue: the component has the state.** Read the props and the interaction model; render only the states that arrive as props. A static component fails the cue entirely.

- Loading: layout shift on arrival, spinners with no accessible name.
- Error: overflowing messages, color as the only signal.
- Disabled: contrast collapse, focus behavior on disabled controls.

Focus and hover are the user's to try while viewing the page: invite them to tab through the instances in the report rather than simulating focus in the harness.

## Environment

**Cue: the project supports the mode.** Viewing modes, not page content: OS dark mode where a dark theme exists, browser zoom, reduced motion. Name them in the report for the user to toggle while viewing. Simulating one on the page observes a different component.

## Where breaks land

Foundation breaks are fixed directly: a11y failures against the floor, content failures against the applicable checklist-bank file (`web-app-data-table`, `web-app-empty-state`, `flows-showing-input-error`, and the 87-file foundation bank in `scratch/references/checklist-design`). Everything else is reported for the user to decide.
