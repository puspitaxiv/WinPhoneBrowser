Add-Type -AssemblyName System.Drawing
$dir = "D:\WinPhoneBrowser\src\Assets"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

function Make-Png($name, $w, $h) {
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::FromArgb(255, 16, 103, 177))
  $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $size = [Math]::Min($w, $h) * 0.55
  $font = New-Object System.Drawing.Font("Arial", $size, [System.Drawing.FontStyle]::Bold)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $rect = New-Object System.Drawing.RectangleF(0, 0, $w, $h)
  $g.DrawString("W", $font, $brush, $rect, $sf)
  $g.Dispose()
  $bmp.Save((Join-Path $dir $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

Make-Png "Square44x44Logo.scale-100.png" 44 44
Make-Png "Square150x150Logo.scale-100.png" 150 150
Make-Png "Wide310x150Logo.scale-100.png" 310 150
Make-Png "SplashScreen.scale-100.png" 620 300
Make-Png "StoreLogo.png" 50 50
Make-Png "LockScreenLogo.scale-100.png" 200 200
Get-ChildItem $dir | Select-Object Name, Length
