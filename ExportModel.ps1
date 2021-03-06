#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$dropLocation = 'C:\AX\Build\Drop\DAXSTDR3\1.0.0.18'
$modelName = 'VAR Model'
$modelFile = Join-Path (join-Path $dropLocation "Application\Appl\") ('{0}.axmodel' -f $modelName)
Remove-Item $modelFile -ErrorAction SilentlyContinue
$sqlServer = 'MOW04DEV014'
$sqlModelDatabase = 'MicrosoftDynamicsAX_model'
$SetupRegistryPath = (Set-Parameter "SetupRegistryPath" "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup" )
#Load the AX PS libary
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
$result = Export-AXModel -Model $modelName -File $modelFile -Server $sqlServer -Database $sqlModelDatabase -OutVariable out -Verbose