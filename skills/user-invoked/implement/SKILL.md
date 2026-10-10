---
name: implement
description: "Alias for /whips. Build from a spec or tickets through the whips feature and bug playbooks, closing with a draft PR."
disable-model-invocation: true
---

`/implement` is now an alias. Its build loop (test-first slices with before/after proof, mandatory review, a `pr`-shaped body) lives in `/whips`, in the feature and bug playbooks, which close with a draft PR.

A skill cannot start another user-invoked skill, so do no work here. Reply with one line: "`/implement` moved into `/whips`. Run `/whips` with the same spec or ticket." Then stop.
