pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.Filename = Notepad.exe
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardInput = $true

$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start()