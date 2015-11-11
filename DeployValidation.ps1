$path  = 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSDEV\bin\Application\LIPS\VAR Model'
#Write-Host $path -ForegroundColor Cyan
$axObjects = @()
$files = gci -Path $path -File -Recurse -ErrorAction SilentlyContinue

foreach ($file in $files)
{
    $axObjects += $file.FullName.Remove(0, $path.Length)
}

$axObjects | Out-File -FilePath 'C:\AX\AOTObjects.txt' -Encoding default

Write-Host Done -ForegroundColor Cyan