---
name: break
description: Stress-test one component against worst-case content and states on a throwaway page, then report what visibly broke. User-invoked.
disable-model-invocation: true
---
# Break

Render one component on a fresh page under every scenario that can actually reach it. The page is the deliverable: a visual report the user scrolls through, every state side by side, with the breaks marked. A component built against one happy path looks finished right up until real content arrives.

It observes, it does not judge. A finding here is something that visibly broke, stated plainly. Reviewing code against a standard is `code-review`; exploring design alternatives is `prototype`.

Isolation here is deliberate, the opposite of `prototype` (which demands the real page). The question is whether the component defends itself when the content is worst-case.

One run is build, look once, report: minutes, not a session. Nothing in it justifies instrumentation, browser debugging, or a second pass.

## 1. Scope one component

One component per run. "The settings page" is not a component; the profile form's text input is. Where the request spans several, list the candidates and ask which one to test rather than picking on the user's behalf.

Restate what the component is in one sentence: what it accepts, what it renders, and where it will live.

## 2. Infer the scenarios from the component

Stress only what varies. A scenario earns a slot when the component accepts something that can take that shape in production. Read the component first: its props, its slots, its states, and the data it renders.

[SCENARIOS.md](SCENARIOS.md) holds the axes, the cue per axis, and what each scenario catches. Walk it against the component and keep only the axes whose cue matches. Write the kept scenarios down before building, one line each, then state which axes were dropped and why in one line, so a wrong inference is cheap to catch.

## 3. Build the harness page

One throwaway route inside the app, so the real layout, fonts, and global styles come free. The real component imported untouched, rendered once per scenario in a single column with a short text label above each instance.

The page adds labels, container widths, and fixture props, nothing else: no fonts or styles of its own, no simulated themes or token swaps, no probes. A component observed under any of those is a different component.

Widths are scenarios on the page: render the width cases inside fixed-width containers beside the full-width one, so a single load shows every width and nothing ever gets resized.

Feed scenarios as props and fixture data. The harness never imports production state, never wires to live data, and production never imports from the harness. Where the framework splits server from client components, the page itself is client code: fixture props can silently vanish crossing that boundary into an interactive component, and every scenario renders empty.

## 4. Look once and report

Flip through every instance. Mark what visibly broke, each with its scenario label. Foundation breaks (the a11y floor and the content floor from the `prototype` craft bar, plus the applicable file from the checklist bank) are fixed directly. Everything else is stated plainly for the user to decide: non-foundation findings need confirmation before any change.

Delete the harness page when done unless the user asks to keep it.
