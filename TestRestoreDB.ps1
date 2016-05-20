$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"

Get-DefaultParameters
#Get-OverrideParameters

Read-AXClientConfiguration
Read-AxServerConfiguration

Restore-Database "LIPS_BUILD" "C:\AX\Build\Backup\AXR3.bak"

Write-Host "Done!"