# Buat sertifikat self-signed untuk menandatangani .appx (sekali saja).
$ErrorActionPreference = "Stop"
$src = "D:\WinPhoneBrowser\src"
$out = "D:\WinPhoneBrowser\output"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$existing = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object { $_.Subject -eq "CN=WPMobileBrowser" } | Select-Object -First 1
if ($existing) {
  $cert = $existing
  Write-Host "Sertifikat sudah ada: $($cert.Thumbprint)"
} else {
  $cert = New-SelfSignedCertificate -Subject "CN=WPMobileBrowser" `
    -CertStoreLocation Cert:\CurrentUser\My -Type Custom `
    -KeyExportPolicy Exportable -HashAlgorithm Sha256 -KeyLength 2048 `
    -NotAfter (Get-Date).AddYears(5) -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")
  Write-Host "Sertifikat baru dibuat: $($cert.Thumbprint)"
}

$pwd = ConvertTo-SecureString -String "wpmobile" -Force -AsPlainText
Remove-Item "$src\WPMobileBrowser_TemporaryKey.pfx" -ErrorAction SilentlyContinue
Export-PfxCertificate -Cert $cert -FilePath "$src\WPMobileBrowser_TemporaryKey.pfx" -Password $pwd | Out-Null
Export-Certificate -Cert $cert -FilePath "$out\WPMobileBrowser.cer" | Out-Null
Write-Host "OK: pfx -> src, cer -> output (salin .cer ke HP untuk trust)"
