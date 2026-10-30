# Playbook: eval

A variant under test that must earn promotion blind. You own the experiment design: plan, blind, run, synthesize.

Non-negotiables for blinding: no eval, test, judge, rubric, score, compare, benchmark, candidate, or arena words in anything a candidate sees; the candidate prompt reads as an organic user request stating the goal, not the meta; no chain-eliciting cues (ask for design notes generally, grade chain-following from code shape, never self-report); sanitized project-shaped directory and slug names; candidates never learn others exist; the judge sees outputs by sanitized label only, never model names; two variants means one judge scores both sets in a single pass on one scale.

1. Frame: the variant under test, what behavior counts as success, a 3 to 6 criterion rubric for the judge only.
2. Set up sanitized environments: one working dir per candidate with the variant in place, plus the context an organic task would carry.
3. Author one organic prompt: what a user would type, leaking nothing measured.
4. Spawn N parallel candidates with model diversity when the harness offers it (`arena` Phase B), same prompt each, each in its own sanitized dir.
5. Spawn one blinded judge (a different model family when the harness offers one) (`arena` Phase C), rubric and sanitized labels only.
6. Verify the chain from transcripts, never self-report: check which files each candidate actually opened (the harness transcript store, never another workspace's private chats) and grade chain-following from files read plus code shape.
7. Read every output end to end yourself and compare with the judge. Disagreement means model bias or an ambiguous rubric. Synthesize.

**Reply:** variant under test, rubric, per-candidate notes, judge verdict, synthesis, promote-or-not recommendation.
