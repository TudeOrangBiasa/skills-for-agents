---
title: Emil prototype skill distilled
description: Distilasi struktur skill prototype emilkowalski plus spec picker dan poin yang bisa dicuri.
tags: [emil-kowalski, prototype, picker, divergence]
---

# Skill prototype Emil, distilasi

Sumber: https://github.com/emilkowalski/skills/tree/main/skills/prototype (SKILL.md plus PICKER.md, di-fetch 2026-10-05 via scrapling dari raw.githubusercontent.com). File ini distilasi beropini, bukan salinan. Untuk teks verbatim, baca sumbernya langsung.

## Peran skill

Skill divergen murni dan user-invoked saja (`disable-model-invocation: true`). Satu tugas: ambil deskripsi satu potong UI, bangun beberapa versi yang genuinely different, taruh di balik visual picker agar user bisa flip dan pilih pemenang. Bukan reviewer UI, bukan perencana perbaikan, bukan pemilih library. Tiga skill lain menutup kebutuhan itu.

## Postur operasi

Nilai skill ini seluruhnya ada di divergensi. Tiga tint dari ide yang sama membuang picker karena user tidak belajar apa pun. Tiap varian harus arah yang bisa dibela untuk di-ship sendiri. Divergensi bukan alasan nurunin craft bar: tiap varian wajib memenuhi standar (easing benar, motion di bawah 300ms, `transform-origin` benar, hanya `transform` dan `opacity`, reduced-motion ditangani). Varian sloppy tidak melebarkan eksplorasi, ia cuma kalah di eksekusi.

## Hard rules (para frase)

1. Jangan sentuh production code selama eksplorasi. Semua di permukaan prototype terisolasi. Integrasi hanya untuk varian pemenang.
2. Varian divergen pada axis bernama: layout, density, personality, motion, interaction model. Sebelum bangun, tiap varian harus bisa dinyatakan sumbunya dalam satu frasa. Berbagi token proyek bukan konvergensi, varian justru harus terasa native.
3. Tiap varian fully works: interaksi nyata, motion nyata, konten realistis seukuran produk, tanpa lorem ipsum dan tombol mati.
4. Picker adalah chrome, bukan kontestan. Markup dan perilakunya ikut spec verbatim, tampilannya tidak pernah adaptasi ke proyek.
5. Bersih-bersih setelah pilih: permukaan prototype dihapus kecuali user minta simpan.

## Workflow enam fase (para frase)

1. Scope: satu hal per run. Kalau brief mencakup banyak komponen, pilih satu highest-leverage piece, nyatakan, tawarkan sisanya sebagai run lanjutan. Nyatakan ulang brief dalam satu kalimat.
2. Recon: petakan stack, tokens (warna, radius, spacing, font, variabel easing dan durasi), personality produk (membatasi sejauh apa varian paling berani boleh pergi), dan konteks render. Tanpa proyek, pakai tampilan default restrained.
3. Pilih arah: default 3 varian, maks 5. Sebelum coding, daftar nama plus axis tiap varian. Nama menjelaskan arah, bukan Option A atau B. Dua arah yang bedanya cuma warna aksen atau copy dihitung satu arah, ganti satu dengan alternatif nyata. Kriteria selesai: tiap varian punya nama dan axis, tidak ada dua varian berbagi posisi axis.
4. Bangun picker harness: di proyek ada dev server, pakai isolated route; tanpa proyek, satu file HTML self-contained. Render satu varian full size dalam konteks realistis, jangan thumbnail berdampingan. Switching instant, tanpa animasi, karena flipping adalah aksi frekuensi tinggi.
5. Verifikasi dan handoff: render dan flip semua varian sendiri, pastikan konsol bersih, screenshot kalau tooling ada. Lalu presentasikan dan berhenti, pilihan milik user. Tabel handoff berisi nomor, nama varian, axis, kapan ia pilihan tepat, dan harganya. Tutup dengan lokasi picker dan kunci flip.
6. Promote saat dipilih: integrasikan varian itu ikut konvensi proyek, hapus permukaan prototype. Kalau user mau ronde lagi, divergen di sekitar arah yang ia sukai.

Aturan jawab akhir (para frase): kalau disuruh pilih, jawab dengan alasan dari personality produk dan frekuensi pakai, bukan estetika saja. Kalau dua varian konvergen saat dibangun, potong satu dan katakan. Picker dengan dua arah yang truly distinct lebih baik dari yang digemukkan jadi tiga.

## Spec picker (para frase perilaku)

Pil dark glass mengambang bottom-center, sengaja tidak theme-aware agar terbaca di halaman terang maupun gelap. Highlight aktif bergeser dengan animasi sebagai feedback spasial picker itu sendiri, tapi varian yang di-preview bertukar instant. Satu-satunya modifikasi yang diizinkan: pindah ke atas kalau varian menempati bottom-center. Tombol replay hanya dirender kalau ada varian bermotion yang layak di-trigger ulang. Key `1` sampai `N` dan panah untuk pindah, `R` untuk replay, diabaikan saat fokus di input.

## Yang bisa dicuri ke prototype lokal

- Named axis plus completion criterion (tidak ada dua varian berbagi axis). Lokal bilang structurally different, versi Emil bisa dicek.
- Fase recon eksplisit termasuk personality sebagai batas keberanian.
- Rasional switching instant dari frekuensi aksi.
- Tabel handoff dengan kolom tradeoff dan cost.
- Craft bar per varian sebagai prasyarat, menunjuk ke skill taste yang sudah ada.
- Struktur lokal yang dipertahankan: `?variant=` switcher, sub-shape A (embed di halaman yang sudah ada) sebagai default, cabang logic single HTML.
