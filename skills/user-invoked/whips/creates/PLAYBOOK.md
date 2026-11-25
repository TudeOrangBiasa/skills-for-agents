# Playbook: creates (Final System User Manual and Reference Book)

Hasilkan satu buku panduan pengguna plus referensi sistem final (man pages) dari repositori aplikasi web. Standarnya rujukan produksi: tiap klaim terbukti dari perilaku nyata aplikasi, tiap gambar lolos linter, tiap label menunjuk ke teks yang terlihat di layar.

Pemicu: pengguna meminta user manual, panduan pengguna, man pages, atau dokumentasi sistem lengkap dari sebuah repo. Bukan brosur dan bukan ringkasan.

## Alur empat tiket

Kerjakan berurutan, satu tiket per run dengan konteks segar di antaranya. Tiap tiket lolos checklist di `CHECKLIST.md` sebelum lanjut. Satu tiket gagal berarti berhenti dan perbaiki, tidak pernah melompat.

### Tiket 1: Explore dan route mapping

1. Baca kode routing (framework router, daftar rute, guard auth), API spec (OpenAPI, tRPC router, atau GraphQL schema), dan skema state (store, session, peran user).
2. Drive aplikasi yang berjalan sebagai tiap peran user, dari login sampai selesai untuk tiap journey utama (contoh: daftar sampai nilai pertama didapat, checkout sampai lunas, ubah pengaturan sampai tersimpan).
3. Tulis `manual-map.json` sebagai sumber kebenaran tunggal dengan bentuk ini:
   1. `app`: nama, baseUrl, locale, commit.
   2. `roles`: tiap peran user plus cara loginnya.
   3. `routes`: tiap rute berisi path, user, tujuan, keywords (kata yang wajib muncul di DOM), viewports yang diambil, journeys yang melewatinya.
   4. `features`: tiap fitur berisi klaim, proof (file, route, endpoint, atau id shot), dan status (Selesai, Prototipe, Backend Only, Out of Scope).
   5. `rules`: tiap aturan bisnis berisi aturan, cara kerja, dan enforcement (server, client, manual, atau ops).
   6. `edge`: tiap journey wajib memuat edge case Normal, Kosong, Pending, Ditolak, Kedaluwarsa, dan Akses Ditolak atau 403.
   7. `demo`: data contoh, akun uji, dan apa yang tidak bisa dilakukan di mode demo.
4. Aturan keras: tidak ada rute, fitur, atau aturan di tiket berikutnya yang absen dari map ini. Gap berarti drive lagi, tidak pernah inventarisasi dari ingatan.

### Tiket 2: Browser drive dan annotated capture

1. Jalankan aplikasi dari clean state (seed data, logout kecuali flow butuh auth).
2. Untuk tiap rute di `manual-map.json`, potret pada 3 viewport wajib: `390x844` (mobile), `768x1024` (tablet), `1440x900` (desktop), memakai CLI `agent-browser`:
   1. Buka rute di viewport berjalan.
   2. Simpan `agent-browser snapshot -i --json` ke `snapshots/<route-slug>.json` sebagai bukti DOM.
   3. Suntikkan kotak merah (`2.5px solid #DC2626`) dan badge angka bulat berbasis `getBoundingClientRect()` lewat `agent-browser eval`, satu badge per poin penjelasan, tanpa tabrakan koordinat.
   4. Ambil `agent-browser screenshot` ke `shots/<route-slug>-{mobile,tablet,desktop}.png`.
3. Satu badge angka di gambar wajib berpasangan 1 banding 1 dengan satu poin penjelasan di naskah. Tidak ada angka yatim dan tidak ada poin tanpa angka.

### Tiket 3: Linter gatekeeper

1. Jalankan `node scripts/lint-manual.mjs --dir <workdir>` dan capai nol error sebelum menulis satu kalimat naskah pun. Linter memeriksa:
   1. Kelengkapan 3 gambar per rute.
   2. Dimensi piksel tepat per viewport.
   3. Ukuran file di atas 15 KB (anti layar putih).
   4. Kata kunci rute cocok di JSON hasil `agent-browser snapshot`.
   5. Anti tabrakan koordinat badge.
   6. Paritas angka di gambar dibanding poin penjelasan (1 banding 1).
2. Linter merah berarti perbaiki app hook, manifest, atau capture, lalu rebuild dan ulangi full pass. Tidak pernah menandai lolos manual.

### Tiket 4: Drafting dan PDF compilation

1. Isi naskah ke `templates/manual.html` mengikuti 9 Bagian Dokumen Terkunci:
   1. Sampul dan Daftar Isi.
   2. Bab 1 Ringkasan dan Role.
   3. Bab 2 Inventaris Fitur.
   4. Bab 3 End-to-End User Journey dan Error Handling.
   5. Bab 4 Man Pages per Halaman.
   6. Bab 5 Aturan Bisnis dan State Machine.
   7. Bab 6 Status Kesiapan dan Next Steps.
   8. Lampiran A Peta Rute.
   9. Lampiran B Panduan Demo dan Akun Uji.
2. Tulis memakai komponen template (cover, status badge, device showcase, annotation list, callout, data table). Tidak ada komponen baru tanpa alasan tertulis.
3. Kompilasi ke PDF (Chromium headless, kertas A4) dan baca ulang tiap halaman hasil render: tiap gambar tampil penuh, tiap header tabel berulang, tiap caption menempel pada gambarnya.
4. Catat SHA commit app dan path sumber UI di sampul. Wire `manual check` setara ke CI bila repo punya pipeline.

## Aturan penulisan naskah (terkunci)

1. Bahasa dinamis tanpa hardcode: bahasa dokumen final mengikuti bahasa yang diminta pengguna saat tugas dijalankan atau mengikuti bahasa antarmuka utama aplikasi yang didokumentasikan. Template memakai slot yang jelas, bukan satu bahasa yang dikunci.
2. Penomoran anti bullet point: dilarang memakai bullet point (`*`, `-`, atau simbol titik) dalam daftar rincian maupun langkah kerja. Wajib memakai penomoran bertingkat berupa angka (`1, 2, 3`) dan huruf (`a, b, c`).
3. Larangan tanda pisah panjang (em dash): dilarang memakai karakter em dash atau tanda pisah panjang. Ganti fungsinya memakai tanda koma, tanda kurung, atau kata hubung eksplisit (yaitu, yakni, atau adalah).
4. Larangan simbol panah (arrow): dilarang memakai simbol panah atau pola teks panah (seperti `->`, `=>`, atau panah unicode) untuk menjelaskan alur atau perpindahan status. Pakai urutan nomor langkah atau kata hubung seperti lalu, kemudian, berubah menjadi, atau menuju ke.
5. Gaya bahasa simpel dan langsung: tulis penjelasan secara ringkas, langsung pada inti fungsi, dan jujur terhadap kondisi kode tanpa basa-basi pembuka atau kalimat berbunga-bunga.

## Balasan

Serahkan: path PDF final, jumlah rute terdokumentasi, jumlah shot, hasil linter (nol error), daftar edge case per journey yang terbukti lewat screenshot, dan hal yang belum ter-cover plus alasannya.
