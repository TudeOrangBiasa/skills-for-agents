# Checklist: creates (wajib per tiket)

Satu kotak gagal berarti tiket gagal. Perbaiki, rebuild, ulangi full checklist tiket itu. Tidak pernah menandai lolos manual.

## Tiket 1: Explore dan route mapping

1. App berjalan dari clean state (seed data, logout kecuali flow butuh auth).
2. `manual-map.json` ada dan valid JSON berisi app, roles, routes, features, rules, edge, demo.
3. Tiap route punya path, user, tujuan, keywords, dan 3 viewport.
4. Tiap journey memuat edge case Normal, Kosong, Pending, Ditolak, Kedaluwarsa, dan Akses Ditolak atau 403.
5. Tiap fitur punya proof (file, route, endpoint, atau id shot) dan status dari daftar tertutup (Selesai, Prototipe, Backend Only, Out of Scope).
6. Tiap aturan bisnis punya enforcement (server, client, manual, atau ops).
7. Blok demo menyebut data contoh, akun uji, dan apa yang tidak bisa dilakukan di mode demo.
8. Tidak ada rute, fitur, atau aturan di luar map yang muncul di tiket berikutnya.

## Tiket 2: Browser drive dan annotated capture

1. Tiap rute punya 3 file gambar: `<route-slug>-mobile.png`, `<route-slug>-tablet.png`, `<route-slug>-desktop.png` di `shots/`.
2. Tiap rute punya `snapshots/<route-slug>.json` dari `agent-browser snapshot -i --json`.
3. Tiap badge angka memakai kotak merah `2.5px solid #DC2626` dari `getBoundingClientRect()`, bukan koordinat tulisan tangan.
4. Tidak ada dua badge yang koordinatnya bertabrakan.
5. Tiap angka di gambar punya pasangan 1 banding 1 dengan poin penjelasan di naskah (tidak ada angka yatim, tidak ada poin tanpa angka).
6. Tiap shot dengan jam live, toast, atau animasi memakai freeze atau hide entry.
7. Tiap viewport sesuai perannya (mobile untuk flow yang user kerjakan di ponsel).

## Tiket 3: Linter gatekeeper

1. `node scripts/lint-manual.mjs --dir <workdir>` keluar dengan kode 0.
2. Bila linter merah, perbaikan hanya lewat 3 jalur (app hook, manifest, capture), tidak pernah lewat pengecualian.
3. Setelah perbaikan, ulangi full pass dari capture, bukan dari langkah yang gagal saja.

## Tiket 4: Drafting dan PDF compilation

1. Naskah mengisi 9 Bagian Dokumen Terkunci secara lengkap dan berurutan (Sampul dan Daftar Isi, Bab 1 sampai Bab 6, Lampiran A, Lampiran B).
2. Bahasa dokumen mengikuti permintaan pengguna atau bahasa antarmuka utama aplikasi (periksa tidak ada bahasa campuran tanpa alasan).
3. Tidak ada bullet point di naskah (hanya angka `1, 2, 3` dan huruf `a, b, c`).
4. Tidak ada em dash di naskah (hanya koma, kurung, atau kata hubung yaitu, yakni, adalah).
5. Tidak ada simbol panah di naskah (hanya urutan nomor langkah atau kata hubung lalu, kemudian, berubah menjadi, menuju ke).
6. Tiap label anotasi mengutip teks yang terlihat di shot-nya.
7. Tiap chapter body hanya menjelaskan langkah yang shot-nya tunjukkan.
8. Tiap tips bisa dijalankan langsung (bukan pujian umum).
9. Tiap baris fitur Selesai punya proof yang eksis, tiap aturan punya enforcement site, tiap baris rute memuat dan tiap demo punya disclosure.
10. PDF render dibaca ulang halaman per halaman: tiap gambar tampil penuh, tiap header tabel berulang, tiap caption menempel pada gambarnya.
11. Sampul mencatat SHA commit app, tanggal, penyusun, dan path sumber UI.
