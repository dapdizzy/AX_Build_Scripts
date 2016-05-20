$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

Get-DefaultParameters

Read-AXClientConfiguration
Read-AxServerConfiguration

$script:scriptName = 'BUILD'

Run-AOTImport "C:\Program Files\Microsoft Dynamics AX\60\Server\LIPS_BUILD\bin\Application\LIPS\VAR Model\Classes\DEV_CreateNewProject.xpo"

$script:axLayer = 'var'
$script:aolCode = 'gR8aYLQYS3Yzj94qIoOUOA=='

Compile-AOTprcoDepsrecursively

#$exclusionList = Remove-OldSourceControlledFiles "C:\Users\pyatkov\Documents\LIPS\TFS Source"

#Merge-AOTprcoLikeFiles "C:\Users\pyatkov\Microsoft\Dynamics Ax\Log"

#Remove-AOTprocoLikeFiles "C:\Users\pyatkov\Microsoft\Dynamics Ax\Log"

Write-Host "Done!" -ForegroundColor Cyan