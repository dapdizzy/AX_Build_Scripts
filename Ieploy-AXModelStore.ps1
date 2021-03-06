#Load the AX PS libary
$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"
#$b = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
#$b = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "BuildAX.ps1")
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
#Get-InputVariables(Split-Path -Parent $MyInvocation.MyCommand.Path)
$AxBuildDir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration
Register-SQLSnapIn
$dropLocation = 'C:\AX\Build\Drop\AXTest\DAXSTDR3\1.0.0.81\Application\Appl'
#Install-ModelStore (Get-ChildItem -Path "$dropLocation\*" -Include "*.axmodelstore" | Select-Object -First 1).FullName
$backupModelStoreFolder = 'C:\AX\Backup\Modelstore'
$CleanBackupFileName = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup\MSDAX.bak'
Clean-Build
#Restore-Database $sqlDatabase $CleanBackupFileName
#$item = ($items | Select-Object -First 1)
#$item.FullName | Install-ModelStore
