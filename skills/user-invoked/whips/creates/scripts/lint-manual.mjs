#!/usr/bin/env node
// lint-manual.mjs: gatekeeper linter for the creates playbook workdir.
// Validates annotated screenshots, DOM snapshots, and 1:1 annotation parity.
// Usage:
//   node scripts/lint-manual.mjs --dir <workdir> [--json]
// Workdir layout:
//   manual-map.json (routes with keywords, shots, annotations, points)
//   shots/<route-slug>-{mobile,tablet,desktop}.png
//   snapshots/<route-slug>.json (raw agent-browser snapshot output)
// Exit 0 means the manual may proceed to drafting. Anything else fails.
import fs from "node:fs";
import path from "node:path";

const VIEWPORTS = {
  mobile: { w: 390, h: 844 },
  tablet: { w: 768, h: 1024 },
  desktop: { w: 1440, h: 900 }
};
const MIN_BYTES = 15 * 1024;

function usage() {
  console.error("usage: node lint-manual.mjs --dir <workdir> [--json]");
  process.exit(2);
}

function parseArgs(argv) {
  const out = { dir: null, json: false };
  for (let i = 2; i < argv.length; i = i + 1) {
    const a = argv[i];
    if (a === "--dir") {
      out.dir = argv[i + 1];
      i = i + 1;
    } else if (a === "--json") {
      out.json = true;
    } else {
      usage();
    }
  }
  if (out.dir === null) {
    usage();
  }
  return out;
}

function readPngSize(file) {
  const buf = fs.readFileSync(file);
  if (buf.length < 33) {
    return { ok: false, reason: "too short for PNG header" };
  }
  const sig = [137, 80, 78, 71, 13, 10, 26, 10];
  for (let i = 0; i < sig.length; i = i + 1) {
    if (buf[i] !== sig[i]) {
      return { ok: false, reason: "not a PNG file" };
    }
  }
  const type = buf.toString("ascii", 12, 16);
  if (type !== "IHDR") {
    return { ok: false, reason: "first chunk is not IHDR" };
  }
  return { ok: true, w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
}

function boxesOverlap(a, b) {
  const xOver = a.x < b.x + b.w && b.x < a.x + a.w;
  const yOver = a.y < b.y + b.h && b.y < a.y + a.h;
  return xOver && yOver;
}

function lintRoute(dir, route) {
  const errors = [];
  const slug = route.slug;
  if (typeof slug !== "string" || slug.length === 0) {
    errors.push("route entry missing slug");
    return errors;
  }
  for (const name of Object.keys(VIEWPORTS)) {
    const file = path.join(dir, "shots", slug + "-" + name + ".png");
    if (!fs.existsSync(file)) {
      errors.push("missing shot: shots/" + slug + "-" + name + ".png");
      continue;
    }
    const stat = fs.statSync(file);
    if (stat.size <= MIN_BYTES) {
      errors.push("shot under 15 KB (possible blank screen): shots/" + slug + "-" + name + ".png (" + stat.size + " bytes)");
    }
    const size = readPngSize(file);
    if (!size.ok) {
      errors.push("unreadable PNG shots/" + slug + "-" + name + ".png: " + size.reason);
      continue;
    }
    const want = VIEWPORTS[name];
    if (size.w !== want.w || size.h !== want.h) {
      errors.push("wrong dimensions shots/" + slug + "-" + name + ".png: got " + size.w + "x" + size.h + ", want " + want.w + "x" + want.h);
    }
  }
  const snapFile = path.join(dir, "snapshots", slug + ".json");
  if (!fs.existsSync(snapFile)) {
    errors.push("missing snapshot: snapshots/" + slug + ".json");
  } else {
    const text = fs.readFileSync(snapFile, "utf8").toLowerCase();
    const keywords = Array.isArray(route.keywords) ? route.keywords : [];
    if (keywords.length === 0) {
      errors.push("route " + slug + " lists no keywords to match in its snapshot");
    }
    for (const kw of keywords) {
      if (!text.includes(String(kw).toLowerCase())) {
        errors.push("keyword missing from snapshot " + slug + ".json: " + kw);
      }
    }
  }
  const anns = Array.isArray(route.annotations) ? route.annotations : [];
  for (const a of anns) {
    const nums = [a.x, a.y, a.w, a.h];
    const bad = nums.some(function (v) { return typeof v !== "number" || Number.isNaN(v); });
    if (bad || a.x < 0 || a.y < 0 || a.w <= 0 || a.h <= 0 || a.x + a.w > 1 || a.y + a.h > 1) {
      errors.push("annotation out of 0..1 bounds on route " + slug + ": n=" + a.n);
    }
    if (typeof a.label !== "string" || a.label.length === 0) {
      errors.push("annotation missing label on route " + slug + ": n=" + a.n);
    }
  }
  for (let i = 0; i < anns.length; i = i + 1) {
    for (let j = i + 1; j < anns.length; j = j + 1) {
      if (boxesOverlap(anns[i], anns[j])) {
        errors.push("badge collision on route " + slug + ": n=" + anns[i].n + " overlaps n=" + anns[j].n);
      }
    }
  }
  const points = Array.isArray(route.points) ? route.points : [];
  const ns = anns.map(function (a) { return a.n; }).sort(function (x, y) { return x - y; });
  const wantNs = points.map(function (_, i) { return i + 1; });
  const same = ns.length === wantNs.length && ns.every(function (v, i) { return v === wantNs[i]; });
  if (!same) {
    errors.push("parity mismatch on route " + slug + ": " + anns.length + " annotations vs " + points.length + " explanation points (need n=1..N, 1:1)");
  }
  for (const p of points) {
    if (typeof p !== "string" || p.length === 0) {
      errors.push("empty explanation point on route " + slug);
    }
  }
  return errors;
}

function main() {
  const args = parseArgs(process.argv);
  const dir = args.dir;
  const mapFile = path.join(dir, "manual-map.json");
  if (!fs.existsSync(mapFile)) {
    console.error("missing manual-map.json in " + dir);
    process.exit(2);
  }
  let map;
  try {
    map = JSON.parse(fs.readFileSync(mapFile, "utf8"));
  } catch (e) {
    console.error("manual-map.json is not valid JSON: " + e.message);
    process.exit(2);
  }
  const routes = Array.isArray(map.routes) ? map.routes : [];
  if (routes.length === 0) {
    console.error("manual-map.json lists no routes");
    process.exit(2);
  }
  const report = [];
  for (const r of routes) {
    const errs = lintRoute(dir, r);
    report.push({ route: r.slug || "(missing slug)", errors: errs });
  }
  const total = report.reduce(function (n, r) { return n + r.errors.length; }, 0);
  if (args.json) {
    console.log(JSON.stringify({ routes: report, errors: total }, null, 2));
  } else {
    for (const r of report) {
      if (r.errors.length === 0) {
        console.log("ok " + r.route);
      } else {
        for (const e of r.errors) {
          console.log("FAIL " + r.route + ": " + e);
        }
      }
    }
    console.log(total === 0 ? "lint-manual: all routes green" : "lint-manual: " + total + " errors");
  }
  process.exit(total === 0 ? 0 : 1);
}

main();
