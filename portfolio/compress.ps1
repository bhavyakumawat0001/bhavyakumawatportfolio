Add-Type -AssemblyName System.Drawing
function Compress-Image {
    param($src, $dest, $quality=80)
    Write-Host "Processing $src..."
    $img = [System.Drawing.Image]::FromFile($src)
    
    $newWidth = $img.Width
    $newHeight = $img.Height
    # Downscale super large images to max 1920px width for standard web display
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
    Write-Host "Saved $dest"
}

$dir = "C:\Users\bhavya kumawat\.gemini\antigravity\scratch\bhavya-agency\portfolio\assets"

Compress-Image -src "$dir\vidhani 1.png" -dest "$dir\vidhani 1.jpg"
Compress-Image -src "$dir\vidhani 2png.png" -dest "$dir\vidhani 2.jpg"
Compress-Image -src "$dir\vidhani3.png" -dest "$dir\vidhani 3.jpg"

