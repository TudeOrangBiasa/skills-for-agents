---
title: Jakub Krehel skills distilled
description: Distilasi repo jakubkrehel/skills, fokus pada variant, break, dan lapisan review interface.
tags: [jakub-krehel, variant, review, accessibility]
---

# Repo Jakub Krehel, distilasi

Sumber: https://github.com/jakubkrehel/skills (README di-fetch 2026-10-05 via scrapling). Skill yang dibaca penuh: `variant`, `break`, `interface-review`, `better-interface`, `explain-interface`. Sisanya (`better-ui`, `better-typography`, `better-colors`, `better-accessibility`, `better-layout`, `better-writing`) baru dari deskripsi README, jangan kutip aturannya sebelum baca langsung. File ini distilasi beropini, bukan salinan. Teks verbatim tetap di sumbernya.

## Arsitektur koleksinya

Satu ide organisasi yang rapi: enam skill domain (`better-*`: accessibility, layout, writing, typography, colors, UI), satu orkestrator (`better-interface` menggabung semuanya jadi satu review), satu reviewer perubahan (`interface-review`), dua skill generatif (`variant` untuk kandidat desain, `break` untuk stress test), satu skill penjelas (`explain-interface` untuk membedah cara animasi atau UI web dibangun).

Install: `npx skills add jakubkrehel/skills`. Ada juga Claude Code plugin.

## variant (dibaca penuh, parafrase)

Bangun tiga versi yang beda secara sengaja dari satu potong UI, di balik picker di halaman asli, lalu serahkan keputusan ke user. Skill lain menilai, skill ini memproduksi kandidat.

- Beda jawaban, bukan beda tint. Tiga varian yang cuma beda warna aksen tidak mengajarkan apa pun.
- Tiap varian beda pada satu primary axis milik koleksi: Structure (better-layout: grouping, order, kolom, collapse), Density (spacing, hit area, muat berapa), Emphasis (better-colors: warna filled di mana, apa yang mundur), Type (better-typography: scale, weight, measure), Voice (better-writing: label, tone, jumlah copy). Pilih satu axis primer, tiap varian menempati posisi beda. Pilihan sekunder mengikuti axis itu, bukan variasi sendiri. Mengubah semua axis sekaligus menghasilkan tiga hasil yang tidak bisa diatribusikan: kamu tahu mana yang disuka, tapi tidak tahu apa yang membuatnya bekerja.
- Floor yang wajib dilewati tiap varian: escalation trigger dari better-interface (nama aksesibel tiap kontrol, keyboard menjangkau semua yang bisa pointer, fokus terlihat, tidak clip di 320px, makna tidak dibawa warna saja). Floor ini identik di semua varian, bukan axis, tidak bisa ditawar. Arah yang cuma bisa hidup dengan melanggarnya, dibuang dan dinyatakan.
- Scope satu potong per run, nyatakan ulang brief satu kalimat. Recon: styling system, component library, motion library, tokens, density dan voice produk, lalu konteks render. Tanpa proyek: abu netral, satu aksen, system font, dan nyatakan itu.
- Axis dinamai sebelum coding. Default tiga varian, lima kalau ruangnya memang lebar. Selesai kalau tidak ada dua varian berbagi posisi dan tiap axis bisa dinyatakan dalam satu frasa.
- Varian tinggal di halaman yang akan memuat potong itu, dengan chrome asli dan data realistis. Pilih via param URL (`?variant=quiet`) agar tiap varian adalah link yang bisa dikirim. Satu varian full size per waktu, bukan thumbnail. Tanpa halaman penampung, satu file HTML self-contained dengan picker sama.
- Konten nyata: copy seukuran produk, nama dan jumlah item yang realistis. Lorem ipsum bikin semua struktur terlihat bagus.
- Handoff berupa tabel tradeoff lalu berhenti: varian, posisi axis, tepat kapan, harganya apa. Jangan tandai favorit di tabel. Kalau ditanya langsung, jawab dari frekuensi potongan itu dilihat dan personality produk, bukan dari mana yang seru dibangun.
- Promote satu, hapus sisanya plus harness. Ronde lanjutan mengambil posisi baru di sekitar arah yang dipilih. Sampai promosi, harness tidak import dari production dan sebaliknya.

## break (dibaca penuh, parafrase)

Render satu komponen di halaman sementara dalam semua state dan skenario yang bisa mencapainya. Deliverable-nya halaman itu sendiri: laporan visual yang di-scroll, semua state berdampingan, yang rusak ditandai. Komponen yang dibangun dari satu happy path terlihat selesai sampai konten nyata datang.

- Mengamati, bukan menilai. Temuan di sini adalah yang visibly broke, dinamai dengan kosakata domain skill pemilik perbaikan. Review kode adalah kerja interface-review, eksplorasi alternatif adalah kerja variant.
- Isolasi di sini disengaja, kebalikan dari variant yang menuntut halaman asli. Yang diuji apakah komponen membela diri saat konten worst-case.
- Satu run itu build, lihat sekali, lapor: hitungan menit, bukan sesi. Tidak perlu instrumentasi atau debugging browser.
- Scope satu komponen per run. Skenario disimpulkan dari komponennya (props, slot, state, data): hanya axis yang cue-nya cocok yang dipakai. Tulis skenario yang kept plus yang dropped dan kenapanya dalam satu baris, agar inferensi salah murah ditangkap.
- Halaman harness: satu kolom, tiap instans dengan label teks pendek, komponen asli diimpor tanpa diubah, di route scratch dalam app agar layout dan font ikut gratis. Tidak ada font atau style milik halaman, tidak ada tema simulasi. Width adalah skenario: render kasus lebar di container fixed-width di samping full-width agar satu load menunjukkan semua. Harness tidak import production state dan tidak wire ke live data.

## interface-review dan better-interface (dibaca penuh, parafrase)

Pembagian kerja yang tegas: `interface-review` hanya memiliki scope (menyelesaikan target review: PR, branch, range, atau working tree kotor, plus klasifikasi temuan), aturan domain milik skill `better-*`, severity dan verdict milik `better-interface`. Correctness, test, security, performance milik general code review proyek, disebut sekali lalu lewat.

- Review perubahan, bukan codebase. Pertanyaannya "apakah saya membuatnya lebih buruk". Temuan pre-existing maksimal tiga sebagai courtesy, selebihnya itu review lain yang tidak diminta.
- Urutan scope resolution penting: merge-base range dulu, lalu working tree kotor, kalau tidak ada perubahan berhenti dan tanya, jangan inventarisasi `HEAD~1` sendiri. Exclude lockfile, snapshot, generated, vendor, binari, dan sebutkan yang diexclude.
- `better-interface` merute ke tiap skill domain sesuai urutan fondasi dulu: accessibility, layout, writing, typography, colors, UI. Skill yang tidak tersedia ditandai Not reviewed, aturannya tidak direka dari memori.
- Tiap temuan butuh evidence berupa path dan baris plus implementasi saat ini. Satu severity bersama: HIGH untuk yang memblokir task, menyesatkan, menyembunyikan konten, risiko data loss, atau failure sistemik; MEDIUM untuk harm ke comprehension dan efisiensi; LOW untuk polish terisolasi. Dalam severity yang sama, rangking dari jangkauan dan murahnya satu fix (fix token atau shared component menang).
- Escalation trigger: begitu skill pemilik mengonfirmasi salah satunya, ia HIGH saat itu juga. Daftarnya antara lain kontrol tanpa accessible name, tanpa focus indicator, tidak reachable keyboard, motion mengabaikan prefers-reduced-motion, clip di 320px atau zoom 200 persen, kontras gagal, makna dibawa warna saja, destructive action tanpa konfirmasi atau undo, konten terpotong tanpa jalan ke nilai penuh, error tanpa jalan pulih, warna semantik dipakai melawan maknanya, perubahan state dibawa motion saja.
- Cap boleh memendekkan laporan, tidak boleh jadi alasan blocker tidak dilaporkan. Trigger selalu didahulukan saat cap terlampaui.

## explain-interface (sekilas)

Membantu mencari tahu cara animasi, desain, atau potong UI di web dibangun. User-invoked. Isi detail belum didistilasi, baca langsung kalau mau pakai.

## Yang bisa dicuri ke repo ini

- Axis milik koleksi dengan pemilik per axis: ide bahwa tiap sumbu variasi dimiliki satu skill domain. Lokal bisa tiru polanya: axis UI dimiliki skill yang relevan, bukan daftar bebas.
- Floor a11y sebagai prasyarat masuk picker, bukan axis yang bisa ditawar. Ini melengkapi craft bar ala Emil yang fokus ke motion.
- `break` sebagai skill baru yang murah: menit, bukan sesi. Lokal belum punya stress test visual semacam ini. Kandidat adopsi paling ringan dari repo Jakub.
- Disiplin scope interface-review: review perubahan bukan codebase, tanya saat tidak ada perubahan, exclude disebut eksplisit. Berguna kalau `code-review` lokal mau varian khusus UI.
- Urutan review fondasi dulu (a11y, layout, writing, type, color, UI) sebelum polish. Mencegah temuan kosmetik menutupi failure fondasi.
