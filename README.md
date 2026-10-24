# Browser WP — browser web untuk Windows 10 Mobile (.appx)

Aplikasi UWP sederhana (WebView + address bar) untuk **Windows 10 Mobile** (Lumia 640/650/950/730/830, build 10240 ke atas).
Buka situs web dan layanan seperti PromptHub (`http://IP-PC:8720`) langsung dari HP — **tanpa Store**, dipasang lewat sideload.

> Toko aplikasi resmi Windows Phone **sudah dimatikan Microsoft** (sejak Des 2019 tidak bisa install baru).
> Aplikasi ini justru dibuat supaya HP tetap bisa dipakai browsing tanpa bergantung Store.

## File hasil build (siap pakai)

Build dilakukan otomatis di **GitHub Actions** (repo `puspitaxiv/WinPhoneBrowser`, workflow *Build Browser WP (.appx)*) karena PC lokal tidak punya toolchain UWP lengkap.

| File | Untuk |
|---|---|
| `output\appx\BrowserWP_1.0.0.0_ARM.appx` | aplikasi yang dipasang di HP (sudah ditandatangani) |
| `output\WPMobileBrowser.cer` | sertifikat kepercayaan — **wajib dipasang dulu** di HP |

Cara ambil dari GitHub: tab *Actions* → run hijau terakhir → artefak **BrowserWP-appx**,
atau dari PC:

```
D:\bin\gh.exe run list -R puspitaxiv/WinPhoneBrowser --limit 1
D:\bin\gh.exe run download <RUN_ID> -R puspitaxiv/WinPhoneBrowser -n BrowserWP-appx -D output
```

Build ulang: `git push` ke branch `main`, atau jalankan workflow manual dari tab Actions (*Run workflow*).

## Langkah di HP (Windows 10 Mobile)

1. **Aktifkan Mode Pengembang**: *Pengaturan → Perbarui & keamanan → Untuk pengembang* → nyalakan **Mode pengembang** + **Sideload aplikasi**.
2. Salin **`WPMobileBrowser.cer`** dan **`BrowserWP_1.0.0.0_ARM.appx`** ke kartu SD / penyimpanan HP (melalui kartu, kabel USB, atau kirim via Bluetooth).
3. Di HP, buka **Penjelajah berkas** → tahan (long-press) file `.cer` → **Pasang** → saat ditanya, pilih instal ke **Penyimpanan Sertifikat → Root / Trusted People**.
4. Tahan file `.appx` → **Pasang**. Ikon **Browser WP** muncul di Start.
5. Bila langkah 3-4 tidak memunculkan opsi pasang: HP belum di-*unlock* sideload penuh — beberapa operator/rom memblokir; satu-satunya jalan lain adalah pasang lewat kabel USB dari PC dengan alat komunitas (Interop Tools / G3 IUM), di luar cakupan panduan ini.

### Kode error umum saat pasang

| Kode | Artinya | Solusi |
|---|---|---|
| `0x80073CFB` | versi lama masih terpasang | hapus Browser WP dari HP, pasang lagi |
| `0x800B0109` / `TRUST_E_...` | `.cer` belum dipasang | ulangi langkah 3 (pasang sertifikat dulu) |
| `0x80073D02` | ada dependensi framework kurang | pasang dulu `.appx` framework (VCLibs/NET.Native) dari alat komunitas |

## Keterbatasan jujur

- WebView memakai Edge versi HP (lama). Situs modern berat/ECMA terbaru sering tampil separuh; situs ringan (PromptHub, Bing, DuckDuckGo lite) dirancang kompatibel.
- Build 10240 lama kadang gagal TLS 1.2 ke situs tertentu → pakai HTTP di jaringan lokal (PromptHub) bila perlu.
- Sertifikat self-signed berlaku 5 tahun (sampai 2031); setelah itu build ulang + pasang `.cer` baru.
- Pengembang (developer) baru membuat sertifikat acak setiap build, jadi `.cer` selalu sepasang dengan `.appx` dari **run yang sama**.

## Struktur

```
src\                      proyek UWP C# (App.xaml, MainPage.xaml, Package.appxmanifest, Assets\)
.github\workflows\        build-appx.yml — build cloud 3 tingkat (Build → AppxPackage → makeappx manual)
make-cert.ps1             sertifikat signing lokal (opsional; CI membuat sendiri)
build.ps1                 percobaan build lokal (butuh VS + SDK UWP di PC)
output\                   hasil unduhan (.appx + .cer)
```
