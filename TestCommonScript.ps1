#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

Write-InfoLog ("CommandPath = {0}" -f $MyInvocation.MyCommand.Path)