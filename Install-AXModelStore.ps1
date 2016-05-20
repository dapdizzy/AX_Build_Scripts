$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"

$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")

Get-DefaultParameters

Read-AXClientConfiguration
Read-AxServerConfiguration

Install-ModelStore "C:\AX\Build\Backup\CleanAXR3.axmodelstore"