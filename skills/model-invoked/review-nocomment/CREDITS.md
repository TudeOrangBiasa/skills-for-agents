# Credits

Guilty-until-proven comment review, root-cause fixes in scope, and constraint-to-encoding offers with approval gates adapted from the pstack `no-comments` skill set by poteto ([Lauren Tan](https://x.com/poteto), MIT). The Comment Sicko spawn persona lives in `agents/comment-sicko.md`, ported from the upstream agent brief with harness pins removed (no `subagent_type`, no model names; models follow the repo model map). Rewritten to this repo conventions: reviewers follow the repo model map with a two-pass fallback, shaping via `craft-vocab`, cross-references point at our principle rules. Copied in, not depended on, so standalone installs keep working without the upstream repo.

Local rename history: `no-comments` became `review-nocomment` in #175 (stage-prefix scheme); upstream source names above are unchanged.
