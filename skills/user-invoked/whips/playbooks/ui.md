# Playbook: UI variant

A UI ticket inside the Walk: diverge, guard, stress, review with evidence, promote one and delete the rest. Runs on top of the feature playbook, never instead of it.

1. Run the feature playbook through step 4 (grounded, shaped, checkpointed). UI work without a data shape and checkpoint is decoration.
2. Diverge: build 2 to 3 `/prototype` variants on a throwaway page. One variant per genuinely different direction, never micro variations of one idea.
3. Guard: each variant meets the a11y floor plus the content floor (worst-case content renders without breakage). A variant that fails a floor is out, no matter how it looks.
4. Stress: run `/break` on the surviving variant. Foundation breaks are fixed directly, the rest is reported for confirmation.
5. Review with evidence: before/after pair per ATTACHMENTS.md (table, native 1x, matched viewport and crop, video when motion matters, never in `<details>`). Promote one variant, delete the rest from the page the same pass.
6. Unslop gate, then PR body, then `playbooks/opening-a-pr.md`. The pair table plus the variant record (base, grafts, rejections) is the evidence section.
