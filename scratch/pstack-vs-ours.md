# pstack (poteto) vs skills-for-agents

Kajian perbandingan melawan sumber primer upstream, bukan tulisan orang tentang upstream.
Tanggal kajian: 2026-10-10. Upstream commit `d73344b` (2026-10-09).

## Sumber

- Upstream: `cursor/plugins`, folder `pstack`, oleh Lauren Tan (poteto). Lisensi MIT.
- Salinan kerja saat kajian ada di `/tmp/pstack-upstream` (3.7 MB, tidak masuk git, lihat di bawah cara fetch ulang).
- File kunci yang dibaca penuh: `pstack/skills/poteto-mode/SKILL.md`,
  `pstack/skills/poteto-mode/playbooks/feature.md`,
  `shipping.md`, `opening-a-pr.md`, plus sweep leaf skill
  (`tdd`, `unslop`, `how`, `why`, `interrogate`, `arena`, `swarm`,
  `blast-radius`, `reflect`, 24 `principle-*`, `show-me-your-work`,
  `technical-writing`) dan padanannya di repo kita.
- Kajian sebelumnya yang masih relevan: `scratch/plan-sfa-stack.md`
  (inventaris router dan peta adaptasi), `scratch/decisions-whips.md`.

Cara fetch ulang salinan kerja:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/cursor/plugins.git /tmp/pstack-upstream
git -C /tmp/pstack-upstream sparse-checkout set pstack
```

## Peta isi pstack (ringkas)

- Router `poteto-mode` (user-invoked, `mode: true`) dengan 24 playbook:
  investigation, bug-fix, perf-issue, hillclimb, runtime-forensics,
  trace-forensics, feature, refactoring, prototype, visual-parity,
  authoring-a-skill, eval, babysit, shipping, autonomous-run, orchestrate,
  autopilot-full, autopilot-stack, session-pickup, pause-safely,
  multi-phase-plan, worktree-cleanup, opening-a-pr. Plus `figure-it-out`
  sebagai router cadangan saat tidak ada playbook yang cocok.
- Kitar 60 skill daun, termasuk 24 `principle-*`, dan skill cara:
  `how`, `why`, `architect`, `arena`, `interrogate`, `swarm`,
  `blast-radius`, `tdd`, `unslop`, `reflect`, `recall`, `correct`,
  `no-comments`, `technical-writing`, `show-me-your-work`,
  `benchmark-checklist`, ditambah skill platform (`make-bot-ui`,
  `control-*` dari paket `cursor-team-kit`).
- Otomasi `benny` (triage issue + reproduce-and-fix, draft PR saja,
  fail closed), panduan `docs/guide` 10 bab, persona subagent
  (`poteto-agent`), dan tooling TypeScript ber-test
  (`scripts/orch`, `scripts/watch-pr`, `check-plan.mjs`).

## Beda besar (7 poin)

### 1. Otonomi: mereka merge, kita tidak

Ini beda paling fundamental. Playbook `shipping` upstream memerintahkan
agent memverifikasi tiap PR secara independen (verdict dari agent yang
tidak nulis kodenya, CI hijau bukan verdict), lalu me-landing run
terverifikasi dari bawah dengan squash dan auto-merge, termasuk
`autopilot-full` yang jalan sampai merged. Aturan readiness mereka:
buka setiap PR dalam keadaan ready, jangan draft.

Kita sebaliknya: HIT. Agent tidak pernah merge, tidak pernah mark ready,
PR selalu draft, manusia yang merge (lihat `whips/SKILL.md`,
`opening-a-pr.md`, `ready-check.md`, `nightshift/CONTRACT.md`).
`nightshift` dan `ready-check` kita adalah versi jinak dari
`autopilot` dan `shipping`: antrean dikerjakan agent, keputusan landing
tetap manusia. Konsekuensi: playbook `shipping`, `autopilot-full`,
dan `autopilot-stack` upstream tidak punya padanan di kita, dan itu
disengaja, bukan ketinggalan.

### 2. Cakupan router: 24 vs 14 playbook

`whips` kita mencakup: investigation, bug, feature, refactor, prototype,
ui, upkeep, babysit, ready-check, autonomous-run, pickup, pause,
opening-a-pr, ditambah triage dan wayfinder-handoff. Tidak kita punya:
perf-issue, hillclimb, runtime-forensics, trace-forensics,
visual-parity, authoring-a-skill, eval, multi-phase-plan,
worktree-cleanup, orchestrate. Sebagian diputus sadar di
`plan-sfa-stack.md` (defer orchestrate/autopilot sampai whips terbukti),
sebagian adalah gap nyata: forensik runtime/trace, visual-parity,
dan eval tidak tercakup di mana pun.

### 3. Leaf skill diganti prose: slogan kebawa, method tidak

Upstream punya skill daun beneran untuk `how`, `why`, `architect`,
`interrogate`, `blast-radius`. Kita menghapus acuannya di PR #4 dan
mengganti dengan langkah inline: explorer subagent, git tracing,
`codebase-design`, `code-review` plus second opinion. Bentuk
orkestrasi selamat, tapi yang hilang:

- `how`: template prompt explorer/explainer, kontrak section output,
  triage kompleksitas.
- `why`: fan-out investigator per kategori bukti (Slack, Notion,
  Datadog, Sentry, warehouse lewat MCP), prompt synthesizer,
  panduan epistemics, disiplin skip-justification.
- `interrogate`: reviewer N model dengan rubrik, pembobotan konsensus,
  bucket Act/Consider/Noted/Dismissed. Kita cuma second opinion saat
  desain contested.
- `blast-radius`: tangga bukti 5 anak tangga dan checklist
  where-grep-stops. Kita menyimpan mantranya verbatim di `bug.md`
  ("writeup yang kedengaran benar tidak ada nilainya tanpa run")
  tapi methodnya tidak ikut.
- `arena`/`swarm`: tidak ada padanan sama sekali selain
  design-it-twice dan throughput checkpoint. Risiko shape-lock dan
  mesin coverage/race tidak tercakup.

### 4. Principles: 24 vs 8

24 `principle-*` upstream lawan 8 aturan di `whips/PRINCIPLES.md`
kita, yang isinya 8 dari 24 itu secara verbatim dalam niat:
subtract, root cause, prove-it, verifiable units, model domain,
idempotent, test-behavior, never-block. Tanpa padanan di kita (16):
attack-the-premise, boundary-discipline, build-the-lever,
encode-lessons-in-structure, exhaust-the-design-space,
experience-first, explain-the-number, foundational-thinking,
guard-the-context-window, laziness-protocol,
migrate-callers-then-delete, minimize-reader-load,
outcome-oriented-execution, redesign-from-first-principles,
separate-before-serializing-shared-state, type-system-discipline.
Sebagian tersentuh parsial (design-it-twice menyentuh
exhaust-the-design-space dengan N=2, `codebase-design` menyentuh
foundational-thinking), 12 sisanya tidak ada jejaknya.

### 5. Model: pin vs agnostik

Upstream menamai model konkret per peran (`grok-4.7-xhigh-fast`
untuk code, `claude-opus-5-5-xhigh` untuk judgment) yang dikonfigurasi
lewat `setup-pstack`. Kita sengaja tidak menamai model: peran dibaca
dari `docs/agents/models.md` repo masing-masing, kalau tidak ada ya
pakai model yang sedang jalan. Skill kita jalan di OMP, Orca, atau
harness lain tanpa diubah. Ini deviasi sadar, jangan di-port balik.

### 6. Platform: Cursor vs universal

Upstream terikat Cursor: `AskQuestion`, MCP, `subagent_type`
`poteto-agent`, skill tim `deslop`/`no-comments`/`control-ui` dari
`cursor-team-kit`, Origin CLI sebagai forge alternatif. Kita menarget
universal agents (Codex, pi, oh-my-pi, agy) dengan file skill polos
plus `agents/openai.yaml`, tanpa packaging khusus harness. Harga yang
kita bayar: tidak ada skill kontrol UI/CLI terverifikasi dan tidak ada
tooling TS (orchestrator store, watch-pr CLI ber-test); kita punya
shell script (`nightshift.sh`, `list-skills.sh`, `lint-pr.sh`).

### 7. Gaya reply: sama, jalur beda

Upstream menulis balasan dengan kalimat deklaratif pendek, tanpa long
dash, tanpa colon tengah kalimat, tiap klaim bawa bukti atau labelnya
di kalimat yang sama, dan tidak pernah menyerahkan cek yang bisa
dijalankan sendiri. Kita mengadaptasi ini lewat skill `unslop` plus
section Reply di `whips` (PR #9). Bedanya: aturan dash kita membolehkan
parentheses mengikuti AGENTS.md repo ini, sementara upstream melarang
parentheses juga. Itu deviasi sadar, jangan diseragamkan.

## Detail adaptasi: tdd dan unslop

### tdd: inti dipertahankan, pemicu dilonggarkan

Upstream `tdd` adalah skill sempit khusus regression bug fix yang hanya
boleh jalan saat user eksplisit minta atau test path-nya murah. Kita
menjadikannya referensi TDD umum yang model-invoked. Yang kita bawa:
red-before-green plus confirm-the-red, larangan melemahkan assertion
agar cocok dengan implementasi salah, fokus tanpa fixture churn,
prefer-no-test-over-bad-test, daftar skip-when-impractical yang
hampir verbatim, dan trio bukti failing-before/passing-after. Yang
kita buang: gate pemicu restriktif, klausa flaky-bug
(deterministikkan test flaky dan dokumentasikan sinyalnya, ini hole
nyata di kita), dan larangan scaffolding test dari nol demi workflow.
Yang kita tambah: kontrak seams, undefined check, katalog anti-pattern,
pemisahan refactor ke tahap review, grounding GLOSSARY/ADR.

### unslop: katalog dipadatkan, 4 aturan hilang

Upstream 33 id stabil, kita 24 aturan hasil trim dan renumber. Yang
hilang tanpa padanan: false ranges (`from X to Y` tanpa skala
bermakna), inline-header lists (uji restatement plus pengecualiannya),
sycophantic tone sebagai kategori sendiri, mannered prose
(aforisme, fragmen retoris, kode yang dipersonifikasi), plus
pemangkasan wordlist (AI-vocab dan metaphor nouns yang dibuang
tercantum di kajian). Kita menambah aturan 24 (no phase-narrating
comments) yang tidak ada di upstream.

## Kandidat port balik (spesifik, prioritas menurun)

1. Klausa flaky-test untuk `tdd`: satu bullet di Rules of the loop.
2. Aturan false ranges untuk `unslop`: presisi tinggi, murah.
3. Uji restatement inline-header lists untuk `unslop` (beserta
   pengecualiannya), karena aturan bold kita belum menangkap tell ini.
4. Tangga bukti blast-radius plus aturan kejujuran (search kosong tetap
   jawaban, jangan mengarang caller, tandai proven/unproven) sebagai
   dua kalimat tambahan di `bug.md` langkah 3.
5. Backfill wordlist `unslop`: `enduring`, `interplay`,
   `gold-plating`, `ratchet`, `evacuate`, `endgame`, yang semuanya
   sudah punya pengganti konkret di upstream.

## Catatan repo

- Repo ini belum punya direktori `references/`. Kajian ini tinggal di
  `scratch/` mengikuti konvensi catatan kerja yang ada
  (`plan-sfa-stack.md`, `decisions-whips.md`). Kalau mau bank riset
  yang terstruktur, buat `references/` terpisah dari `scratch/`.
- Salinan upstream tidak di-vendor ke git (3.7 MB). Fetch ulang dengan
  perintah di bagian Sumber.
