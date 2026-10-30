#!/usr/bin/env node
// check-plan-test.mjs: runs check-plan.mjs against the four fixtures (issue #70).
// Deps: node only. Run: node skills/user-invoked/whips/scripts/check-plan-test.mjs
import { execFileSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const lint = path.join(here, "check-plan.mjs");
const fix = (name) => path.join(here, "fixtures", "check-plan", name);

const CASES = [
	{ name: "pass", fixture: "pass.md", want: 0, stderr: [] },
	{ name: "missing-blocks", fixture: "missing-blocks.md", want: 1, stderr: ['lacks "### PR mechanics" in order', "sub-blocks are", "lanes are"] },
	{ name: "box-without-proof", fixture: "box-without-proof.md", want: 1, stderr: ["names no screenshot", "has no pass predicate", "live box is not a lane", "perf boxes are"] },
	{ name: "merge-without-verification", fixture: "merge-without-verification.md", want: 1, stderr: ["names no verdict", 'lacks "video"'] },
];

let pass = 0;
let fail = 0;
for (const c of CASES) {
	let got = 0;
	let err = "";
	try {
		execFileSync(process.execPath, [lint, fix(c.fixture)], { stdio: ["ignore", "ignore", "pipe"] });
	} catch (e) {
		got = e.status ?? 1;
		err = e.stderr?.toString() ?? "";
	}
	const missing = c.stderr.filter((s) => !err.includes(s));
	if (got === c.want && !missing.length) {
		pass += 1;
		console.log(`ok ${c.name}`);
	} else {
		fail += 1;
		console.log(`FAIL ${c.name}: want exit ${c.want} got ${got}${missing.length ? `, missing: ${missing.join(" | ")}` : ""}`);
	}
}
console.log(`${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
