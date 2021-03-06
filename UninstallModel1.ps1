$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$modelName = 'VAR Model'
$sqlServer = 'MOW04DEV014'
$sqlModelDatabase = 'MicrosoftDynamicsAX_model'

$Result = Uninstall-AXModel -Model $modelManifest.Name -Details -NoPrompt -Server $sqlServer -Database $sqlModelDatabase -OutVariable out -Verbose