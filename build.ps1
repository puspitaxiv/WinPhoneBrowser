$ErrorActionPreference = "Stop"
$vswhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) { throw "vswhere belum ada — instalasi Build Tools belum selesai." }
$msbuild = & $vswhere -latest -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe" | Select-Object -First 1
if (-not $msbuild) { throw "MSBuild tidak ditemukan (workload UWP belum terpasang?)" }
Write-Host "MSBuild: $msbuild"

$proj = "D:\WinPhoneBrowser\src\WPMobileBrowser.csproj"
if (-not (Test-Path "D:\WinPhoneBrowser\src\WPMobileBrowser_TemporaryKey.pfx")) {
  throw "src\WPMobileBrowser_TemporaryKey.pfx belum ada — jalankan make-cert.ps1 lebih dulu."
}

& $msbuild $proj /t:Restore /v:minimal
if ($LASTEXITCODE -ne 0) { throw "restore gagal" }

$plat = if ($args.Count -ge 1) { $args[0] } else { "ARM" }
& $msbuild $proj /t:Build `
  /p:Configuration=Release /p:Platform=$plat /p:UapAppxPackageBuildMode=SideloadOnly `
  /p:AppxBundle=Never /p:AppxSymbolPackageEnabled=false `
  /p:PackageCertificateKeyFile=WPMobileBrowser_TemporaryKey.pfx `
  /p:PackageCertificatePassword=wpmobile `
  /p:AppxPackageDir=D:\WinPhoneBrowser\output\appx `
  /v:minimal
if ($LASTEXITCODE -ne 0) { throw "build gagal (plat $plat)" }
Get-ChildItem "D:\WinPhoneBrowser\output\appx" -Recurse -Filter *.appx | Select-Object FullName, Length
