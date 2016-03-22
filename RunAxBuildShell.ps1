$nodeName = ("{0}-{1}" -f [System.Environment]::MachineName, (Get-Date -DisplayHint DateTime)).Replace(" ", "_").Replace(":", "").Replace(".", "").Replace("/", "").Replace("-", "_")
Write-Host $nodeName
Start-Sleep -s 5
$exp = 'cd "C:\AX\Build\build_client"'
iex $exp
$exp = ('iex.bat --cookie cookie --sname {0} -S mix' -f $nodeName)
iex $exp