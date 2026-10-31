# Playbook: authoring a skill

Writing or changing a skill (SKILL.md plus its folder). This repo is skills, so this is the most common real work here; it routes here, not to `feature`. A skill that keeps getting worked around in runs is the signal: propose the change instead of routing around it.

1. Draft with the authoring skills: call the Skill tool with "craft-agent-docs" for structure and "review-unslop" for prose. One skill, one job; prose that does not change a decision gets deleted. Point at structural sources instead of restating them, and delegate to other skills by path instead of copying their text.
2. Validate before any commit, with commands, not eyeballing:
   - Frontmatter carries `name` and `description`, and `name` equals the folder name. Check one skill: `f=skills/<bucket>/<name>/SKILL.md; grep -m1 '^name:' "$f"` must print the folder name. The docs gate enforces this tree-wide.
   - Every file the skill references exists in the folder; every link between skills resolves. Run the full gate: `scripts/check-docs.sh origin/main` (exit 0, all checks ok).
   - `agents/openai.yaml` matches the repo pattern (`display_name`, `short_description`).
   - New skill: registered in `skills/<bucket>/README.md` and the top-level `README.md` (the docs gate enforces this), plus the `guide` when a user-reachable flow changes.
   - Changed skill that alters agent behavior: run the Eval playbook (`playbooks/eval.md`) on the change before promoting it.
3. Ship the metadata with the skill: `CREDITS.md` naming the source when adapted, a changeset file, and README counts kept in sync.
4. Close via `playbooks/opening-a-pr.md`: always ready, landing per risk tier. Opening a PR does not start a babysit.

**Reply:** what changed in the skill and why, validation commands run with outcomes, and what still waits on the human.
