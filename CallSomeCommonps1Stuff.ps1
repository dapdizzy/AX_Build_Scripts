$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$combinedXpoFilename = 'C:\AX\CombinedXPOs\Combined.VAR Model.xpo'
CreateSpecificXPOs $combinedXpoFilename