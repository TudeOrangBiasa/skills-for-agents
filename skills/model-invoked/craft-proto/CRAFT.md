# Craft Bar

House rules for prototype variants. Two tiers: floor is non-negotiable, taste is this repo's preference and may be overridden with a stated reason.

## Floor (fix directly when violated)

- UI motion stays under 300ms: micro-interactions 100 to 150ms, standard UI 150 to 250ms, modals and drawers 200 to 300ms. Exit may run about 20 percent faster than entrance.
- Animate `transform` and `opacity` only. Never animate layout properties (width, height, top, left) on live UI.
- Entering elements use ease-out, moving or morphing on screen uses ease-in-out, hover changes use ease, constant motion uses linear. Never ease-in on entrances.
- Elements appear from something, never from nothing: start at scale 0.95 with opacity 0, not scale 0.
- Popovers scale from their trigger point (`transform-origin` at the trigger). Modals stay centered.
- Buttons answer presses: scale 0.97 on active.
- Honor `prefers-reduced-motion`: state changes must also read through color, icon, or label when motion does not run.
- Minimum 44px hit area for small tappable controls (a pseudo-element counts).

## Taste (confirm before enforcing)

- Motion restraint first: do not animate what does not need it. One moving thing per moment.
- Larger elements move slower than smaller ones; duration matches travel distance.
- When something still feels off, prefer a subtle blur under 20px over adding more motion.
- Hover must not flicker: animate the child, not the parent.
- Sequential reveals (tooltips, toasts in a stack) skip delay after the first.

Sources distilled, not copied: Emil Kowalski's animation rules (see `scratch/references/emil-essays.md`), Jakub Krehel's escalation triggers (see `scratch/references/jakub-skills-distilled.md`). Override any taste rule per product by stating the reason in the handoff table.
