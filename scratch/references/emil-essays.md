---
title: Emil essays distilled
description: Distilasi dua esai emilkowal.ski yang relevan untuk prototype dan taste, plus daftar bacaan lanjutan.
tags: [emil-kowalski, taste, friction, prototype]
---

# Esai Emil, distilasi

Sumber: https://emilkowal.ski (di-fetch 2026-10-05 via scrapling `--ai-targeted`). File ini distilasi beropini dengan kutipan pendek berattribusi, bukan salinan penuh. Untuk teks lengkap, baca tautan sumbernya.

Daftar tulisan di halaman utama saat fetch: Friction as a Feature, You Do Not Need Animations, Agents with Taste, Building a Toast Component, Developing Taste, The Magic of Clip Path, 7 Practical Animation Tips, Train Your Judgement, Building an animation course, Building a Drawer Component. Dua yang didistilasi di bawah karena paling nyambung ke skill dan prototype.

## Agents with Taste (https://emilkowal.ski/ui/agents-with-taste)

Tesis: engineer hari ini sangat leverage berkat fleet of agents, tapi untuk kerja visual, coding agent belum tahu seperti apa rasa great itu. Solusinya: kalau kamu tahu seperti apa great itu, tulis aturannya, jadikan skill, beri ke agent.

Poin yang bisa dipakai:

- Taste yang matang bukan cuma bisa bilang mana yang lebih enak, tapi bisa bilang kenapa. Contoh yang dipakai: animasi yang benar terasa gentle dan natural karena mulai dari nilai `scale` awal yang lebih tinggi. `scale(0)` terasa salah karena terlihat muncul dari ketiadaan, seperti balon yang bahkan saat kempis pun masih punya bentuk terlihat. Hampir tiap keputusan taste punya alasan logis kalau diperiksa dekat-dekat.
- Kemas taste jadi skill yang strict agar agent tidak perlu menebak: tabel practical tips per skenario (contoh: tombol responsif pakai `scale(0.97)` saat active, elemen muncul mulai dari `scale(0.95)` bukan nol, popover scale dari lokasi trigger), flowchart keputusan easing (masuk atau keluar viewport jadi ease-out, bergerak di layar jadi ease-in-out, hover jadi ease, gerak konstan jadi linear), guideline durasi (mikro 100 sampai 150ms, UI standar 150 sampai 250ms, modal dan drawer 200 sampai 300ms, animasi UI di bawah 300ms, exit boleh sekitar 20 persen lebih cepat dari entrance).
- Pola yang sama berlaku di luar animasi: tipografi (bodi maks sekitar 65ch, tabular-nums untuk kolom harga, loosen letter-spacing untuk label uppercase, underline dicadangkan untuk link), dan prinsip dari proyek open source seperti Sonner.
- Cara membuatnya: tanya ke diri sendiri kenapa keputusan itu diambil, artikulasikan dengan jelas, tetapkan aturan, bersikap strict. Lalu beri ke coding agent, misal minta perbaiki animasi dialog berdasar skill itu, lengkap dengan daftar issue dan tabel before after.

Kutipan pendek berattribusi: tidak ada yang magic, "almost every taste decision has a logical reason if you look close enough". Bagian kreatif tetap milik manusia, tapi tiap yang bisa dipaketkan jadi skill melipatgandakan leverage agent.

## Friction as a Feature (https://emilkowal.ski/ui/friction-as-a-feature)

Tesis: friction diam-diam mengerjakan dua hal. Ia memperlambat, tapi ia juga memaksa berpikir sebelum membangun. Dulu menulis kode itu mahal, jadi biaya membangun memasang ambang seleksi atas ide mana yang layak hidup. AI menghapus biaya itu, ide jadi aplikasi dalam hitungan menit, ambang kelayakan runtuh.

Poin yang bisa dipakai:

- Membangun murah itu sendiri cara berpikir: membangun opsi A dan B lalu membandingkan sering validasi yang lebih baik daripada sekadar teori. Prototyping is thinking. Tapi hanya kalau idenya benar divalidasi. Tidak ada yang menghalangi orang men-ship A dan B sekaligus karena usahanya kecil, friction-nya hilang.
- Itu yang dikeluhkan dari gelombang aplikasi vibe-coded: jarang ada pikiran di baliknya karena tidak ada friction yang memaksa. Hasilnya terasa tidak didesain, hanya ada.
- Kesimpulan: kita tetap butuh friction sebagai filter ide yang tidak layak dibangun dan pemaksa judgement. It is a feature, not a bug.

Nyambung ke repo ini: prototype menjawab satu pertanyaan, keputusan dicatat, sisanya dibuang. Kalau varian tidak pernah dipilih dan tidak pernah dihapus, itu bukan eksplorasi, itu penimbunan opsi.

## Bacaan lanjutan yang disarankan

- 7 Practical Animation Tips: kandidat isi tabel tips kalau skill taste lokal dibuat.
- Train Your Judgement dan Developing Taste: fondasi melatih taste sebelum dipaketkan jadi skill.
- Building a Toast Component dan Building a Drawer Component: studi kasus komponen nyata di balik Sonner dan Vaul.
- You Do Not Need Animations: penyeimbang agar prototype tidak menganimasikan segalanya.
