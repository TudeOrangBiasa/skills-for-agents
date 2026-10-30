#!/usr/bin/env node
// check-plan.mjs: lint a multi-phase-plan.md plan (issue #70).
// Adapted from pstack poteto-mode check-plan.mjs: same skeleton contract,
// repo markers (scheduled audit wake, needs-human gate, verdict in Merge).
// Usage: node check-plan.mjs <plan.md>
// Exit 0 when the plan holds, 1 with one fix line per problem, 2 on misuse.
import fs from "node:fs";
import process from "node:process";

const RULE = "Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.";
const LANES = /Ten lanes on `[^`<>]+` at the PR head/;
const SUB_BLOCKS = ["Depends on.", "Files.", "Build.", "You see.", "Verify, unit.", "Verify, live.", "Verify, perf.", "Review gate.", "Merge."];
const PROGRAM_H3 = ["Arm the program", "Spawn owners", "PR mechanics", "Verdict and merge", "Boot recipe"];
const PROGRAM_MARKERS = ["git show origin/main:", "audit wake", "status message"];
const HOW_TO_READ_MARKERS = ["One box is one unit of work", "names the evidence", "Check a box only when its evidence exists", "playbooks/", RULE];
const PERF_ITEMS = ["Metric.", "Probe.", "Baseline.", "Rule."];
const NEED_BOX = ["Files.", "Build.", "You see.", "Verify, unit.", "Merge."];
const RULE_BLOCKS = ["Verify, unit.", "Verify, live.", "Verify, perf."];
const BOX = /^\s*- \[[ x]\] (.*)$/;

const file = process.argv[2];
if (!file) {
	console.error("Usage: node check-plan.mjs <plan.md>");
	process.exit(2);
}
let raw;
try {
	raw = fs.readFileSync(file, "utf8").split(/\r?\n/);
} catch {
	console.error(`check-plan: cannot read ${file}`);
	process.exit(2);
}
const problems = [];
const fail = (line, message) => problems.push(`${file}:${line}: ${message}`);

let start = 0;
if (raw[0] === "---") start = raw.indexOf("---", 1) + 1;
const lines = [];
let fence = null;
const openFence = (text) => {
	const m = text.match(/^ {0,3}(`{3,}|~{3,})(.*)$/);
	if (!m || (m[1][0] === "`" && m[2].includes("`"))) return null;
	return { char: m[1][0], len: m[1].length };
};
const closeFence = (text, opening) => {
	const m = text.match(/^ {0,3}(`+|~+)[ \t]*$/);
	return Boolean(m && m[1][0] === opening.char && m[1].length >= opening.len);
};
for (let i = start; i < raw.length; i++) {
	const text = raw[i];
	const n = i + 1;
	let code = Boolean(fence);
	if (fence && closeFence(text, fence)) {
		code = false;
		fence = null;
	} else if (!fence) {
		fence = openFence(text);
		code = Boolean(fence);
	}
	lines.push({ n, text, code });
	if (code) continue;
	const prose = text
		.replace(/(?<!`)(`+)(?!`)(.*?)(?<!`)\1(?!`)/g, "`")
		.replace(/!\[[^\]]*\]\([^)]*\)/g, "")
		.replace(/\]\([^)]*\)/g, "]");
	if (/[—–]/.test(prose)) fail(n, "long dash; rewrite with a comma, a colon, or a period");
	if (/[‘’“”]/.test(prose)) fail(n, "curly quote; use a straight quote");
	if (/: \S/.test(prose)) fail(n, "mid-sentence colon; end the sentence or start a list");
}

const sections = [];
for (const l of lines) {
	if (!l.code && l.text.startsWith("## ")) sections.push({ title: l.text.slice(3).trim(), n: l.n, body: [] });
	else if (sections.length) sections.at(-1).body.push(l);
}
const find = (title) => sections.find((s) => s.title === title);
const textOf = (s) => s.body.map((l) => l.text).join("\n");
const boxesOf = (ls) => ls.filter((l) => !l.code && BOX.test(l.text)).map((l) => ({ n: l.n, text: l.text.match(BOX)[1] }));

const h1 = lines.findIndex((l) => !l.code && l.text.startsWith("# "));
if (h1 === -1) fail(1, "no H1 title; start the plan with `# <Program> plan`");
const howToRead = find("How to read this");
if (!howToRead) fail(1, 'no "## How to read this" section; copy the skeleton from playbooks/multi-phase-plan.md');
if (h1 !== -1 && howToRead) {
	const intro = lines.slice(h1 + 1).filter((l) => l.n < howToRead.n && l.text.trim() !== "");
	if (intro.length >= 10) fail(lines[h1].n, `intro is ${intro.length} lines; cut it to under ten`);
	for (const m of HOW_TO_READ_MARKERS) {
		if (!textOf(howToRead).includes(m)) fail(howToRead.n, `How to read this lacks "${m}"; restore the skeleton paragraph`);
	}
}

const program = find("Program checklist");
if (!program) fail(1, 'no "## Program checklist" section; copy the skeleton from playbooks/multi-phase-plan.md');
else {
	const h3s = program.body.filter((l) => !l.code && l.text.startsWith("### ")).map((l) => l.text.slice(4).trim());
	let cursor = 0;
	for (const name of PROGRAM_H3) {
		const at = h3s.findIndex((t, i) => i >= cursor && t.startsWith(name));
		if (at === -1) fail(program.n, `Program checklist lacks "### ${name}" in order; restore the skeleton`);
		else cursor = at + 1;
	}
	for (const m of PROGRAM_MARKERS) {
		if (!textOf(program).includes(m)) fail(program.n, `Program checklist lacks "${m}"; restore the skeleton box`);
	}
}

const close = find("Close the program");
if (!close) fail(1, 'no "## Close the program" section; append it after the last PR');
const pi = sections.indexOf(program);
const ci = sections.indexOf(close);
const prs = pi === -1 || ci === -1 ? [] : sections.slice(pi + 1, ci);
if (!prs.length) fail(1, "no PR sections between Program checklist and Close the program; add one `## <Task> (<PR id>)` per PR");

const report = [];
for (const pr of prs) {
	const heads = [];
	for (const l of pr.body) {
		if (l.code) continue;
		const m = l.text.match(/^\*\*([^*]+)\*\*(.*)$/);
		if (m && SUB_BLOCKS.includes(m[1])) heads.push({ name: m[1], n: l.n, rest: m[2].trim(), lines: [] });
		else if (heads.length) heads.at(-1).lines.push(l);
	}
	const names = heads.map((h) => h.name);
	if (names.join("|") !== SUB_BLOCKS.join("|")) {
		fail(pr.n, `${pr.title}: sub-blocks are [${names.join(", ")}], expected [${SUB_BLOCKS.join(", ")}]; restore the missing block in skeleton order`);
	}
	const block = (name) => heads.find((h) => h.name === name);
	const counts = Object.fromEntries(heads.map((h) => [h.name, boxesOf(h.lines).length]));
	const depends = block("Depends on.");
	if (depends && !depends.rest) fail(depends.n, `${pr.title}: Depends on names nothing; write the parent PR id or None`);
	for (const name of NEED_BOX) {
		const b = block(name);
		if (b && !boxesOf(b.lines).length) fail(b.n, `${pr.title}: ${name} has no box; add one box per unit of work`);
	}
	for (const name of RULE_BLOCKS) {
		const b = block(name);
		if (b && !b.rest.startsWith(RULE)) fail(b.n, `${pr.title}: ${name} does not open with the rule; paste "${RULE}" first`);
	}
	const live = block("Verify, live.");
	if (live) {
		if (!LANES.test(live.rest)) {
			fail(live.n, `${pr.title}: Verify, live lacks "Ten lanes on \`<model role>\` at the PR head" with the role filled in`);
		}
		const lanes = boxesOf(live.lines).map((b) => ({ ...b, m: b.text.match(/^Lane (\d+)\. /) }));
		const nums = lanes.filter((b) => b.m).map((b) => Number(b.m[1])).sort((a, b) => a - b);
		if (nums.join(",") !== "1,2,3,4,5,6,7,8,9,10") {
			fail(live.n, `${pr.title}: lanes are [${nums.join(",")}], expected 1 to 10; number every lane box \`Lane <n>.\``);
		}
		for (const lane of lanes) {
			if (!lane.m) fail(lane.n, `${pr.title}: live box is not a lane; start it with \`Lane <n>.\``);
			else if (!/Save `[^`]+`/.test(lane.text)) fail(lane.n, `${pr.title}: lane ${lane.m[1]} names no screenshot; add \`Save \`<slug>.png\`\``);
			else if (!lane.text.includes("Pass when")) fail(lane.n, `${pr.title}: lane ${lane.m[1]} has no pass predicate; add \`Pass when <predicate>\``);
		}
	}
	const perf = block("Verify, perf.");
	if (perf) {
		const items = boxesOf(perf.lines).map((b) => b.text.split(" ")[0]);
		if (items.join("|") !== PERF_ITEMS.join("|")) {
			fail(perf.n, `${pr.title}: perf boxes are [${items.join(", ")}], expected [${PERF_ITEMS.join(", ")}]; restore the four boxes in order`);
		}
	}
	const gate = block("Review gate.");
	if (gate) {
		const gateBoxes = boxesOf(gate.lines);
		if (gate.rest.startsWith("None.")) {
			if (gateBoxes.length) fail(gate.n, `${pr.title}: Review gate says None but has boxes; delete the boxes or write the gate`);
		} else {
			if (!gateBoxes.length) {
				fail(gate.n, `${pr.title}: Review gate has no box; add the screenshot, video, and needs-human boxes, or write \`None. <PR id> is not review-gated.\``);
			}
			const text = gate.lines.map((l) => l.text).join("\n");
			for (const w of ["screenshot", "video", "human"]) {
				if (!text.includes(w)) fail(gate.n, `${pr.title}: Review gate lacks "${w}"; restore the skeleton gate`);
			}
		}
	}
	const merge = block("Merge.");
	if (merge) {
		const text = `${merge.rest}\n${merge.lines.map((l) => l.text).join("\n")}`;
		if (!text.includes("verdict")) fail(merge.n, `${pr.title}: Merge names no verdict; add the ready-check verdict box first`);
	}
	const total = boxesOf(pr.body).length;
	const cells = SUB_BLOCKS.filter((s) => s !== "Depends on.").map(
		(s) => `${s.replace(/[ ,.]+/g, "-").replace(/-$/, "").toLowerCase()}=${counts[s] ?? 0}`,
	);
	report.push(`${pr.title}  boxes=${total}  ${cells.join(" ")}`);
}

if (ci !== -1) {
	const tail = sections.slice(ci + 1);
	for (const s of tail) {
		if (!s.title.startsWith("Appendix")) fail(s.n, `"## ${s.title}" after Close the program is not an appendix; move it before Close or rename it`);
	}
	if (!tail.some((s) => s.title.includes("Prototype evidence"))) {
		fail(close.n, 'no "## Appendix ... Prototype evidence" section; append it after Close the program');
	}
}

for (const line of report) console.log(line);
console.log(`${prs.length} PR sections, ${problems.length} problems`);
for (const p of problems) console.error(p);
process.exit(problems.length ? 1 : 0);
