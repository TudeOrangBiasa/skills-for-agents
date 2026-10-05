---
title: Emil Kowalski skills inventory
description: Daftar 14 skill di emilkowalski/skills plus relevansi tiap skill untuk workflow UI lokal.
tags: [emil-kowalski, inventory, prototype, animation]
---

# Emil Kowalski skills inventory

Sumber: https://github.com/emilkowalski/skills (14 skill, 43.3k stars saat fetch 2026-10-05). Daftar diambil via GitHub API lewat scrapling, bukan tebakan.

## Daftar lengkap

- `animate`: bangun animasi dari nol, urutan keputusan lengkap (perlu animasi atau tidak, tujuan, tool, properti, kurva, durasi, interupsi, exit). Ini builder utama untuk web motion.
- `animate-expo`: sama untuk React Native dan Expo (Reanimated, Gesture Handler, Expo Router, haptics).
- `animation-vocabulary`: kamus balik, dari deskripsi vague ke istilah tepat ("efek bouncy saat popover dibuka" menjadi Pop in). Untuk menamai efek, bukan membangunnya.
- `apple-design`: pendekatan Apple untuk interface dan fluid motion di web (spring, gesture, sheet, depth, tipografi, reduced-motion).
- `ask-sonner`: panduan toast library Sonner plus troubleshooting.
- `break-ui`: isi belum di-fetch, jangan jadikan acuan sebelum dibaca langsung dari sumber.
- `emil-design-eng`: filosofi design engineering Emil (sudah ada sebagai skill di mesin ini, lihat perbandingannya di file companion).
- `find-animation-opportunities`: cari tempat yang seharusnya animasi tapi belum, read-only, plus menolak yang tidak perlu.
- `improve-animations`: audit motion satu codebase lalu susun rencana implementasi prioritas.
- `mobile-native`: pola mobile native (detail belum di-fetch).
- `pick-ui-library`: pilih dependency UI (pendamping prototype agar varian tidak salah pilih fondasi).
- `prototype`: bangun beberapa versi UI yang genuinely different di balik visual picker (didistilasi di file companion).
- `review-animations`: kritik motion yang sudah ada (pasangan improve-animations).
- `write-swift`: tulis Swift modern plus concurrency dan performance.

## Relevansi untuk repo ini

Inti yang nyambung ke `prototype` lokal: `prototype` sebagai skill divergen, dikelilingi `review-animations` (kritik), `improve-animations` (audit), `find-animation-opportunities` (cari peluang), `animation-vocabulary` (samakan bahasa), `pick-ui-library` (pilih fondasi). Lokal kita punya builder dan reviewer umum (`implement`, `code-review`) tapi belum punya lapisan kritik dan audit khusus motion. Kalau workflow UI makin sering, keempat skill pendamping itu kandidat adopsi berikutnya, bukan `prototype` itu sendiri yang sudah setara.

Catatan hati-hati: file ini inventaris beropini dari daftar nama plus deskripsi API. Isi tiap skill belum dibaca satu per satu kecuali `prototype`. Jangan kutip aturan dari skill yang belum di-fetch.
