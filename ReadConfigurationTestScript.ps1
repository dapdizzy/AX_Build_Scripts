#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

Write-Host ('AOS Number = {0}' -f  $script:aosNumber)
Write-Host "$script:sqlServer"
Write-Host "$script:sqlDatabase"
Write-Host "$script:sqlModelDatabase"
Write-Host "$script:serverBinDir"
Write-Host "$script:serverLogDir"
Write-Host "$script:serverApplDir"
Write-Host "$script:AxAOSServerName"
Write-Host "$script:axBuild"
Read-Host 'Are you satisfied now?'
#Read-Host ('Current configuration info: AOSName = {0}, AOS Number = {1}, port = {2}, SQL Server name = {3}, Database name = {4}, Model databsse name = {5}' -f $AOSName, $script:aosNumber, $portNumber, $script:sqlServer, $script:sqlDatabase, $script:sqlModelDatabase)