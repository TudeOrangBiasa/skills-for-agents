# Playbook: project playbooks

A repository extends a bundled playbook without forking it. One Markdown file per variant in `.agents/playbooks/` (repo scope) or `~/.agents/playbooks/` (every repo on this machine); when both folders hold a match, the home change applies first. A missing folder means no variants: run the bundled playbook as written.

Frontmatter names `extends` (bundled playbook stems, comma-separated or a dash list, empty for standalone) and `when` (one sentence naming the requests it serves). Body changes are list items starting with `**After**`, `**Before**`, `**Replace**`, or `**In**` followed by a straight-quoted run of the bundled step's own words; in a playbook with no numbered steps each paragraph and list item is a step. Stop where the project playbook says to stop.

Before applying a project playbook, run `node skills/user-invoked/whips/scripts/check-playbooks.mjs` from the repo root. It fails when a project playbook extends a playbook this pack lacks, quotes step text that no longer exists, misses its `when` line, or anchors a change on nothing. Report each line it prints and do not guess where an unanchored change belongs: an upgrade that rewrites a bundled step breaks anchors on purpose, and the fix is editing the project file, never force-applying it.

Match order on a task: when the bundled playbook you matched is one a project playbook extends, or the task fits a project playbook's `when`, open that file too. Copy the bundled steps into the todo verbatim, apply each change at the step its quoted text names.
