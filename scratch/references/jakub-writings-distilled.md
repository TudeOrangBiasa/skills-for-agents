---
title: Jakub Krehel writings distilled
description: Distilasi esai Using AI as a design engineer plus daftar tulisan jakub.kr dan interfaces.dev.
tags: [jakub-krehel, ai-workflow, design-engineering]
---

# Tulisan Jakub Krehel, distilasi

Sumber: https://jakub.kr (daftar tulisan dan esai Using AI as a design engineer, di-fetch 2026-10-05 via scrapling `--ai-targeted`). File ini distilasi beropini, bukan salinan. Teks lengkap baca di tautannya.

## Using AI as a design engineer (https://jakub.kr/work/using-ai-as-a-design-engineer)

Tesis: design engineering adalah craft, thoughtfulness, dan kreativitas, hal yang secara definisi bukan kekuatan AI. Tapi ia tetap menikmatinya karena AI mempercepat trial and error menuju momen this feels right. Pembedanya: ia tidak memakai AI untuk menghasilkan ide atau menggantikan berpikir, melainkan untuk mengakselerasi workflow. Dan user yang memegang kendali, bukan sebaliknya. Jangan ikuti buta apa pun yang diberi agent, pahami apa yang agent lakukan.

Poin yang bisa dipakai:

- Setup dulu: aturan codebase yang pendek dan menunjuk file lain (contoh: animation-performance, react-compiler, cn-util, design-system, animation-rules). Aturan menghemat waktu karena tidak perlu dijelaskan tiap prompt. Peringatan: jangan copy aturan orang tanpa paham isinya.
- Asumsikan agent tidak punya konteks. Manusia mengingat konteks lintas percakapan, agent tidak. Memulai dengan asumsi nol konteks memberi hasil terbaik.
- Aturan a11y selalu ikut (contoh: icon-only button perlu aria-label, form perlu label, elemen interaktif perlu keyboard handler, button untuk aksi dan link untuk navigasi, img perlu alt, ikon dekoratif aria-hidden, update async perlu aria-live polite).
- Aturan motion dan performance dirujuk dari sumber yang dipercaya (ui-skills, Vercel Web Interface Guidelines, Motion docs, Tailwind sponsor rules).
- Pola kerja: plan dulu, beri konteks dengan @, perintah dengan slash. Eksperimen cepat, buang yang tidak terasa benar dalam hitungan menit, bukan jam.

Nyambung ke repo ini: setup-meta lokal sudah sejalan (aturan pendek plus pointer, bukan dokumen gemuk). Ide nol konteks memperkuat aturan tulis Map dan Guardrail eksplisit di tiap ticket: agent implement tidak boleh diasumsikan ingat sesi discuss.

## Daftar tulisan lain (belum didistilasi)

- The invisible side of design engineering, Less is more more or less, Details that make interfaces feel better: kandidat isi craft bar.
- Using gestures in Motion, Drag gestures on the web, How I use shared layout animations: kandidat isi motion rules.
- Understanding gradients, What are OKLCH colors: kandidat isi color skill.
- Majalah interfaces.dev dan proyek loading.dev serta oklch.fyi: sumber lanjutan untuk desain dan warna.

Bacaan yang disarankan berikutnya kalau mau: Details that make interfaces feel better untuk melengkapi floor variant, lalu salah satu tulisan animasi untuk melengkapi craft bar motion.
