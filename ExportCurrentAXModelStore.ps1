$clientRegistryPath = "HKCU:\SOFTWARE\Microsoft\Dynamics\6.0\Configuration"

$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"

$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")

$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

Get-DefaultParameters
Get-OverrideParameters

Read-AXClientConfiguration
Read-AxServerConfiguration

Export-ModelStore "C:\AX\your_modelstore_II_II.axmodelstore"