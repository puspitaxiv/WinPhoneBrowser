# Browser WP — browser web untuk Windows 10 Mobile (.appx)

Aplikasi UWP sederhana (WebView + address bar) untuk **Windows 10 Mobile** (Lumia 640/650/950/730/830, build 10240 ke atas).
Buka situs web dan layanan seperti PromptHub (`http://IP-PC:8720`) langsung dari HP — **tanpa Store**, dipasang lewat sideload.

> Toko aplikasi resmi Windows Phone **sudah dimatikan Microsoft** (sejak Des 2019 tidak bisa install baru).
> Aplikasi ini justru dibuat supaya HP tetap bisa dipakai browsing tanpa bergantung Store.

## File hasil build

| File | Untuk |
|---|---|
| `output\appx\...\WPMobileBrowser_1.0.0.0_ARM.appxbundle/.appx` | aplikasi yang dipasang di HP |
| `output\WPMobileBrowser.cer` | sertifikat kepercayaan — **wajib dipasang dulu** di HP |

## Langkah di PC (sudah diotomatiskan skrip)

```
powershell -ExecutionPolicy Bypass -File D:\WinPhoneBrowser\make-cert.ps1   # sekali: buat sertifikat
powershell -ExecutionPolicy Bypass -File D:\WinPhoneBrowser\build.ps1       # build ARM .appx
```

## Langkah di HP (Windows 10 Mobile)

1. **Aktifkan Mode Pengembang**: *Pengaturan → Perbarui & keamanan → Untuk pengembang* → nyalakan **Mode pengembang** + **Sideload aplikasi**.
2. Salin **`WPMobileBrowser.cer`** dan **`.appx`** ke kartu SD / penyimpanan HP (melalui kartu, kabel USB, atau kirim via Bluetooth).
3. Di HP, buka **Penjelajah berkas** → tahan (long-press) file `.cer` → **Pasang** → saat ditanya, pilih instal ke **Penyimpanan Sertifikat → Root / Trusted People**.
4. Tahan file `.appx` → **Pasang**. Ikon **Browser WP** muncul di Start.
5. Bila langkah 3-4 tidak memunculkan opsi pasang: HP belum di-*unlock* sideload penuh — beberapa operator/rom memblokir; satu-satunya jalan lain adalah pasang lewat kabel USB dari PC dengan alat komunitas (Interop Tools / G3 IUM), di luar cakupan panduan ini.

## Keterbatasan jujur

- WebView memakai Edge versi HP (lama). Situs modern berat/ECMA terbaru sering tampil separuh; situs ringan (PromptHub, Bing, DuckDuckGo lite) dirancang kompatibel.
- Build 10240 lama kadang gagal TLS 1.2 ke situs tertentu → pakai HTTP di jaringan lokal (PromptHub) bila perlu.
- Sertifikat self-signed berlaku 5 tahun; setelah itu build ulang + pasang .cer baru.

## Struktur

```
src\        proyek UWP C# (App.xaml, MainPage.xaml, Package.appxmanifest, Assets\)
make-cert.ps1   sertifikat signing
build.ps1       msbuild Release|ARM → appx
output\     hasil (.appx + .cer)
```
