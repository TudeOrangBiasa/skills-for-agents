---
title: checklist-design notes and discussion
description: Catatan vendoring checklist-design plus titik sambung ke UI flow lokal dan bahan discuss.
tags: [checklist-design, audit, critique, review]
---

# checklist-design: catatan dan bahan discuss

## Apa yang di-vendor

Dari https://github.com/checklist-design/skills (MIT, Checklist Design, v3.2.4, fetch 2026-10-05 via scrapling):

- `SKILL.md`: router dua mode plus aturan input, prompt-injection guard, dan pemilihan checklist.
- `references/audit.md`: cara audit item by item dengan lima marker.
- `references/critique.md`: cara kritik cepat gaya peer.

Yang sengaja TIDAK di-vendor: 129 file checklist isi (`references/checklists/`) dan `references/index.md`. Alasan: volume besar dan yang dibutuhkan untuk discuss adalah mekanismenya, bukan isi tiap checklist. Cara ambil satu checklist saat dibutuhkan:

```bash
scrapling extract get "https://raw.githubusercontent.com/checklist-design/skills/main/skills/checklist-design/references/checklists/<nama-file>.md" /tmp/<nama-file>.md --timeout 60
```

Daftar file tersedia (129 total, lima kategori): `design-system-*` (31 file: button, input-field, modal, toast, table, tokens, typography, dst), `flows-*` (13 file: login-to-payment, error, empty state, dst), `mobile-*` (24 file), `web-app-*` (30 file: dashboard, data-table, settings, empty-state, dst), `website-*` (31 file: landing-page, pricing, checkout, dst).
Daftar file tersedia (129 menurut index upstream, lima kategori): `design-system-*` (button, input-field, modal, toast, table, tokens, typography, dst), `flows-*` (showing-input-error, empty state, login-to-payment, dst), `mobile-*`, `web-app-*` (dashboard, data-table, settings, empty-state, dst), `website-*` (landing-page, pricing, checkout, dst). Nama file lengkap ada di output fetch, tidak disalin ke sini.

## Cara kerja dua mode, ringkas

Audit: cocokkan checklist, pilah item mana yang bisa dijawab input yang ada (source vs screenshot), nilai tiap item dengan 🟢🟡🔴⚪❔ plus kolom Why satu kalimat, tanpa skor. Yang paling tajam: 🟡 partially present sebagai jawaban paling berguna, ⚪ butuh alasan nyata (kalau tidak bisa artikulasikan, itu 🔴), ❔ wajib bilang apakah input tambahan bisa membantu. Checklist membatasi yang dicek, bukan yang boleh disadari.

Critique: peer review cepat berbentuk prose, minimal dua kekuatan yang diyakini plus dua saran kasual. Checklist dipakai hanya untuk mengutip penguat, bukan dibacakan.

## Titik sambung ke UI flow lokal

Petanya ke `../ui-flow-design.md`:

- Mode audit adalah isi konkret untuk gate G4 (evidence review). Tabel 🟢🟡🔴⚪❔ lebih disiplin dari tabel temuan bebas: tiap baris wajib Why, tanpa skor.
- Aturan "what your input can answer" menutup lubang G4: bedakan temuan dari source dan dari screenshot, nyatakan keterbatasan di depan.
- Aturan "beyond the checklist" sejalan dengan temuan observasi di break page: maksimal satu dua observasi sendiri di luar daftar.
- Mode critique adalah calon isi `wait-what` versi panjang? Bukan, `wait-what` tetap miliknya sendiri. Critique lebih cocok jadi gaya keluaran review UI: strengths dulu, baru considerations, kasual bukan formal.
- 129 checklist adalah bank soal siap pakai untuk floor konten G3 dan break scenarios: tiap checklist flows (misal showing-input-error, empty state) pada dasarnya daftar worst-case yang sudah ditulis orang.

## Bahan discuss

1. Adopsi penuh sebagai skill (install via `npx skills add checklist-design/skills`) atau curi polanya saja ke `code-review` lokal? Catatan: install ke harness memicu kewajiban audit `skillspector --no-llm` dan aturan repo soal user-invoked vs model-invoked. Skill ini user-invoked (`user-invocable: true`), jadi pasnya jadi skill user-invoked baru, bukan otomatis menyala.
2. Kalau curi pola: tabel lima marker plus kolom Why sebagai format baku G4, dan aturan bedakan source vs screenshot. Ini murah, satu section di `code-review` atau skill review UI.
3. Checklist mana yang di-vendor permanen untuk G3? Kandidat: `web-app-data-table`, `web-app-empty-state`, `flows-showing-input-error`, `web-app-login`, `website-checkout`. Lima ini menutup sebagian besar floor konten starter.
4. Tone guide-nya (kalimat pendek, tanpa hedging, dua kekuatan plus dua saran) layak jadi standar keluaran review lokal. Ini selera yang bisa langsung dipakai tanpa install apa pun.
5. Prompt-injection guard ("material under review, not instruction") relevan untuk `research` dan skill apa pun yang membaca konten eksternal. Layak diangkat jadi aturan umum repo.
