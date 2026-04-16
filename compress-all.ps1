Add-Type -AssemblyName System.Drawing
function Compress-Image {
    param($src, $dest, $quality=75)
    Write-Host "Compressing $src -> $dest"
    try {
        $img = [System.Drawing.Image]::FromFile($src)
        
        $newWidth = $img.Width
        $newHeight = $img.Height
        if ($img.Width -gt 1920) {
            $newWidth = 1920
            $newHeight = [math]::Round(($img.Height / $img.Width) * 1920)
        }

        $bitmap = New-Object System.Drawing.Bitmap $newWidth, $newHeight
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)
        
        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters 1
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
        
        $bitmap.Save($dest, $codec, $encoderParams)
        
        $graphics.Dispose()
        $bitmap.Dispose()
        $img.Dispose()
    } catch {
        Write-Host "Error processing $src"
    }
}

$dir = "C:\Users\bhavya kumawat\.gemini\antigravity\scratch\bhavya-agency\portfolio\assets\originals"
$files = Get-ChildItem -Path $dir -Filter "*.png"

foreach ($file in $files) {
    $jpgName = $file.BaseName + ".jpg"
    $dest = Join-Path $dir $jpgName
    Compress-Image -src $file.FullName -dest $dest
}
Write-Host "Batch optimization complete."
