---
title: aihero.dev skills vs local diff
description: Hasil scrape aihero.dev/skills plus changelog v1.1 dan v1.2, dibanding skill lokal untuk cari yang missing.
tags: [aihero, diff, changelog, skills]
---

# aihero.dev vs lokal: apa yang missing

Metode: scrape pakai `scrapling extract get --ai-targeted`, sesuai aturan repo (scraping via scrapling, bukan curl improvisasi). File mentah di `/tmp`, bukan di repo: `aihero-skills.md`, `aihero-v12.md`, `aihero-v11.md`, `aihero-wizard.md`.

Sumber upstream yang dibaca:
- https://www.aihero.dev/skills (daftar 25 skill, grup Getting Started, Main Flow, Shaping, Upkeep, Productivity, Reference)
- https://www.aihero.dev/skills/skills-changelog-v12-wait-what-writing-for-agents-claude-code-plugin-and-more
- https://www.aihero.dev/skills/skills-changelog-v1-1-wayfinder-to-spec-to-tickets-grilling-improvements
- https://www.aihero.dev/skills-wizard

Tanggal fetch: 2026-10-05. Angka hiasan di halaman: 276.162 stars, 25 skills, MIT.

## 1. Inventaris upstream vs lokal

Upstream (nama asli): setup-matt-pocock-skills, ask-matt, grill-with-docs, to-spec, to-tickets, implement, code-review, wayfinder, prototype, research, improve-codebase-architecture, diagnosing-bugs, resolving-merge-conflicts, triage, wizard, grill-me, handoff, to-questionnaire, teach, wait-what, writing-for-agents, codebase-design, domain-modeling, grilling, tdd.

Lokal (nama sudah diganti): setup-meta, guide (pengganti ask-matt), discuss-with-docs (pengganti grill-with-docs), to-spec, to-tickets, implement (hasil merge, TDD before after wajib per slice), code-review, wayfinder, prototype, research, improve-codebase-architecture, diagnosing-bugs, resolving-merge-conflicts, triage, wizard, discuss (pengganti grill-me), teach, wait-what (revisi visual), writing-for-agents, codebase-design, domain-modeling, interview (pengganti grilling), tdd, pr, setup-pre-commit, retro, setup-ts-deep-modules, loop-me.

Yang lokal hapus dengan sengaja (lihat scratch/plan.md): handoff, to-questionnaire, scaffold exercises, migrate-to-shoehorn, git-guardrails-claude-code, writing betas dan fragments. Yang lokal tambah sendiri: pr, retro, loop-me, setup-ts-deep-modules, setup-pre-commit sebagai skill.

## 2. Yang ternyata sudah sinkron, tidak perlu kerja

- `agents/openai.yaml` di tiap skill, termasuk `policy.allow_implicit_invocation: false` untuk user-invoked. Lokal sudah punya di semua skill.
- `interview` sudah pakai ronde frontier, format Q1 plus rekomendasi, fakta oleh subagent, keputusan oleh user, gate konfirmasi sebelum act. Ini sama dengan perbaikan grilling di v1.1 dan v1.2.
- `wizard` sudah model-invoked, template.sh fixed library di atas marker STAGES, idempotent env upsert, gh secret dan variable writes, cross-platform URL termasuk WSL. Sama dengan v1.2.
- `prototype` logic branch sudah single HTML shareable, free-play plus guided walkthrough, capture di branch `prototype/<name>` dengan pointer. Sama dengan v1.2.
- `wayfinder` sudah decision tickets, bukan implementation tickets. Istilah ini yang ditekankan v1.2.
- `writing-for-agents` sudah punya istilah cache untuk environment as source of truth, plus SKILL-MECHANICS.md. Sama dengan rename writing-great-skills di v1.2.
- `codebase-design` sudah memuat DESIGN-IT-TWICE.md. Ini pengganti design-an-interface yang dihapus upstream.
- `improve-codebase-architecture` sudah punya filter YAGNI berbasis area yang baru berubah. Sama dengan small items v1.2.
- Rename to-spec dan to-tickets sebagai tracer bullet plus blocking edges sudah dipakai lokal.

## 3. Gap nyata, diurut prioritas

### P1: Pola docs upstream belum ada di lokal
Tiap halaman skill upstream punya section Common questions (dari wiki pertanyaan asli) dan It is working if. Plus tiap istilah pertama link ke AI Coding Dictionary (contoh: ticket). Lokal belum punya pola ini di SKILL.md mana pun. Dampak: skill lokal susah dipelajari user baru, padahal isi teknisnya setara. Saran: tambah dua section mini itu ke `guide`, `discuss-with-docs`, `to-spec`, `to-tickets`, `implement` dulu, jangan ke semua skill sekaligus.

### P2: wait-what melenceng dari desain upstream
Upstream: tiga baris, ASD-STE100 Simplified Technical English plus ubiquitous language dari CONTEXT.md, menamai state listener (bukan output seperti tldr atau no-fluff), memperbaiki satu pesan saja, pencegahannya tetap shared language di depan via grill-with-docs. Lokal: repitch visual terkecil plus potongan kode plus follow-up plus next task, katalog show-me di-pack. Risiko: skill concision yang gemuk justru gagal bikin model ringkas, persis yang diperingatkan upstream. Saran: kembalikan inti tiga baris dan STE100, jadikan visual sebagai opsi fallback saja, bukan default.

### P3: to-questionnaire dihapus, tapi upstream kasih alasan ia ada
Upstream memindahkannya ke Productivity dengan definisi tajam: ia menggrill soal pengiriman (send), bukan soal topik, untuk responden yang bukan kamu (contoh garden office: yang ditanya istri, via Google Doc). Lokal menghapusnya karena tidak relate dengan workflow. Itu sah, tapi gap-nya perlu dicatat: kalau suatu saat wayfinder mentok karena penjawabnya orang lain, tidak ada jalan resmi. Saran: tetap hapus, tapi tulis satu paragraf di `guide` atau `wayfinder`: kalau responden bukan kamu, tulis questionnaire tangan sebagai portable note.

### P4: Handoff dipertahankan upstream, lokal membuangnya
Upstream v1.2 menegaskan handoff itu sempit: hanya saat sesuatu harus travel (harness baru, direktori baru, kolega, fork side task mid-phase). Compact jadi default paling bawah, continue diutamakan karena menjaga primary source. Lokal menghapus handoff dan mengganti dengan portable note tulisan tangan plus fork session. Fase boundary di lokal: Continue, clear, portable note, subagent, compact. Ini divergensi sadar dan konsisten dengan plan, tapi dua detail upstream layak dicuri: tulis aturan continue dulu sebelum compact, dan tegaskan compact di bawah pohon, bukan reach pertama. Smart zone lokal juga perlu cek: upstream pindah 120k ke 150k.

### P5: Research paralel untuk wayfinder research tickets
Upstream v1.2: research tetap tipe tiket karena blocker bersama, tapi charting tidak berhenti. Tiap research ticket ditembak sebagai subagent research paralel, hasil di branch `research/<name>` dengan pointer. Perlu cek apakah `wayfinder` lokal sudah memuat pola tembak paralel ini atau masih parkir research untuk sesi terpisah ala v1.1. Kalau belum, ini tambahan kecil bernilai besar.

### P6: Routing wayfinder yang dua kesalahan umum
Upstream menambahkan dua larangan di router: jangan over-reach wayfinder untuk feature yang muat satu sesi (pakai discuss-with-docs), dan saat map clear jangan loop ke implement langsung, tapi merge di to-spec yang meruntuhkan linked decisions jadi buildable plan. Lokal sudah punya kalimat mirip di guide, tapi belum setegas ini. Saran: copy dua kalimat larangan itu verbatim ke `guide`.

### P7: Setup skill lebih ramah
Upstream setup-matt-pocock-skills: label triage hanya ditanya kalau triage diinstal (satu pertanyaan recommended-yes), external PR default off tanpa ditanya, domain docs single-context kecuali sinyal monorepo, tiket local-markdown satu file per tiket di `.scratch/<feature>/issues/<NN>-<slug>.md` plus `spec.md`. Lokal setup-meta paket penuh (DESIGN.md Stitch, coding standards, commit dan PR format, husky). Perlu cek apakah tujuh default kecil upstream itu ikut, karena ini mengurangi friksi setup.

### P8: AGENTS.md vs CLAUDE.md symlink
Upstream: AGENTS.md symlink ke CLAUDE.md agar Codex baca instruksi sama. Lokal: CLAUDE.md dihapus, AGENTS.md file nyata (lihat plan DONE). Untuk Codex murni ini bisa jadi gap baca. Saran: cek apakah Codex di sini membaca AGENTS.md langsung. Kalau tidak, kembalikan symlink atau duplikat pointer.

## 4. Yang sengaja beda dan tidak disarankan untuk disamakan

- Nama discuss, discuss-with-docs, interview, guide tanpa nama orang. Ini keputusan lokal yang bagus, upstream masih grill-me, grill-with-docs, grilling, ask-matt.
- Implement lokal yang mewajibkan TDD before after per slice plus code-review plus PR body pr. Upstream implement sengaja tipis dan mengandalkan priors. Versi lokal lebih ketat dan cocok dengan HIT loop plan.
- Tambahan lokal pr, retro, loop-me, setup-ts-deep-modules. Tidak ada di upstream 25 skill, tapi mengisi kebutuhan repo sendiri.
- Prototype lokal punya cabang UI (variasi radikal via URL param plus floating bar). Upstream v1.2 hanya mengatur cabang logic ke single HTML. Cabang UI lokal dipertahankan.

## 5. Langkah berikut yang disarankan

1. Tambah Common questions dan It is working if ke lima skill main flow.
2. Rampingkan wait-what kembali ke tiga baris plus STE100, visual jadi fallback.
3. Tambah satu paragraf questionnaire tangan di wayfinder sebagai pengganti to-questionnaire.
4. Selaraskan phase boundaries: continue dulu, compact paling bawah, smart zone 150k.
5. Verifikasi research paralel dan tujuh default setup, lalu tutup.
