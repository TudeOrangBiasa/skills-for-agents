# Playbook: review

On-ask review only. This playbook never gates code-ready, shipping, or merge: for a ship decision run the repo verifier or deterministic checkers instead, never a read-only second opinion as a gate. Two modes: code review checks a diff on two axes; adversary tries to break a design. A finding a run cannot prove does not survive.

## Code review mode

Two-axis review of the diff between `HEAD` and a fixed point the user supplies. Run only when the user asks to review a branch, a PR, or work since a point.

### 1. Pin the fixed point

Whatever the user said is the fixed point (a commit SHA, branch name, tag, `main`, `HEAD~5`). If they did not specify one, ask for it. Capture `git diff <fixed-point>...HEAD` (three-dot, against the merge base) plus `git log <fixed-point>..HEAD --oneline`. Confirm the ref resolves and the diff is non-empty before going further.

### 2. Identify the spec source

Look for the originating spec, in this order: issue references in commit messages (`#123`, `Closes #45`), fetched via `docs/agents/issue-tracker.md`; a path the user passed; a spec file under `docs/`, `specs/`, or `.scratch/` matching the branch. If nothing is found, ask the user; if they say there is none, the Spec axis reports "no spec available" and skips.

### 3. Identify the standards sources

Anything in the repo that documents how code should be written (`CODING_STANDARDS.md`, `CONTRIBUTING.md`). On top of whatever the repo documents, the Standards axis always carries the smell baseline below: a fixed set of Fowler code smells that applies even when a repo documents nothing. Two rules bind it: a documented repo standard always wins over the baseline, and every smell is a labelled judgement call, never a hard violation. Skip anything tooling already enforces. Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name**: a name that does not reveal what it holds → rename it; if no honest name comes, the design is murky.
- **Duplicated Code**: the same logic shape in more than one hunk → extract the shared shape, call it from both.
- **Feature Envy**: a method reaching into another object's data more than its own → move the method onto the data it envies.
- **Data Clumps**: the same fields travelling together → bundle them into one type.
- **Primitive Obsession**: a primitive standing in for a domain concept → give the concept its own small type.
- **Repeated Switches**: the same `switch`/cascade recurring → replace with polymorphism or one shared map.
- **Shotgun Surgery**: one logical change scattering edits across files → gather what changes together into one module.
- **Divergent Change**: one file edited for unrelated reasons → split so each module changes for one reason.
- **Speculative Generality**: abstraction for needs the spec lacks → delete it until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation → hide the walk behind one method.
- **Middle Man**: a pass-through that only delegates → cut it, call the target direct.
- **Refused Bequest**: a subclass ignoring most of what it inherits → drop the inheritance, use composition.

### 4. Spawn both axes in parallel

Standards sub-agent: the diff command, the commit list, the standards sources found, plus the smell baseline pasted in full. Brief: per file/hunk, (a) every documented-standard breach with file plus rule cited, (b) any baseline smell spotted by name with the hunk quoted; hard violations only for documented breaches, smells always judgement calls; under 400 words. Spec sub-agent: the diff plus the spec. Brief: (a) spec requirements missing or partial, (b) behaviour the spec never asked for, (c) requirements that look implemented but wrong, each quoting the spec line; a finding that claims wrong behavior must cite the exact command run plus the output showing the failure, or it is dropped; under 400 words.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. Do not merge or rerank: a change can pass one axis and fail the other, and reranking hides that. End with a one-line summary: totals per axis and the worst issue within each axis. Guardrails first: failing tests outrank every style finding. For UI findings report each with a status (Present, Partially present, Missing, Not needed, Can't tell) plus one line why it matters.

## Adversary mode

Adversaries try to break a change or a design. Runs on explicit user ask only ("challenge this", "tear this apart"); never a default gate before a PR. A finding survives only when a run proves it. Do not apply fixes; report the findings.

### 1. Scope and intent

The scope is what the user names, otherwise the branch diff from its merge base plus working tree. Package the diff with the context files a reviewer needs. State the intent in one paragraph from the user message, commit messages, PR description, and code; ask when the intent is unclear before spawning anyone.

### 2. Spawn reviewers

One reviewer per available model, all in one round with the same brief (intent, diff, rubric below): the same prompt against different models, agreement is the signal. Models follow the repo model map; with a single model, run two passes (find, then challenge). Give each adversary its own worktree and copy the uncommitted scope into each, so repros stay isolated.

### 3. Break it

Brief every adversary to prove each finding with a run against the real code: a failing test, a repro script, or command output showing the wrong behavior against what the intent requires. Leave out anything not run: style, naming, structure, and risks needing a future change to matter. No findings is a valid result. Lenses: correctness (edge cases, state, concurrency; never flag without the call chain), root cause vs symptom, structural integrity, verification (behavior tests, regression tests), complexity budget (simpler wins unless simpler is wrong), security (input paths, auth gaps, secrets).

### 4. Verify, then judge

Rerun each finding's command. Keep a finding when the output shows the failure and the failure breaks the intent; merge findings that share a root cause. Independently raised by two or more is the highest signal; lone findings weigh less. Bucket every verified finding with a one-line rationale: **Act on** (blocks a real PR), **Consider** (legitimate, cost of acting unclear), **Noted** (valid, not actionable now), **Dismissed** (wrong or nitpicky, with the reason).

### Output

**Intent** (the restatement). **Findings** (per verified finding: command, output, how it breaks the intent, who raised it; "no verified findings" when none survive). **Dropped** (per adversary: count and why). **Buckets** (every verified finding bucketed plus an agreement map of where reviewers agreed and diverged).
