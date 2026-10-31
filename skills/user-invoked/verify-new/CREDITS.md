# Credits

Repo interview axes, generated skill sections (launch, doctor, drive, evidence, cleanup, helpers), feature-map seeding, and prove-once handover adapted from the pstack `create-verification-skill` set by poteto ([Lauren Tan](https://x.com/poteto), MIT). The CLI lever checklist (composable API, `--dry-run`, subcommands, guiding errors, `--help`, JSON output) follows her Complete Guide to pstack Pt. 1 section Make it Reproducible. Rewritten to this repo conventions: universal `skills/verify-<app>/` placement with `agents/openai.yaml` instead of Cursor paths, no harness assumptions. Copied in, not depended on, so standalone installs keep working without the upstream repo.

Local rename history: `create-verification` became `verify-new` in #175 (stage-prefix scheme); upstream source names above are unchanged.
