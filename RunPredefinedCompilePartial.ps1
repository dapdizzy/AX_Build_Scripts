$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

$script:startupDir = $MyInvocation.MyCommand.Path
$script:compileInLayer = "VAR"

Get-DefaultParameters
Get-OverrideParameters

Read-AXClientConfiguration
Read-AxServerConfiguration

Write-Host (Get-Variable)

Start-Sleep -Seconds 5

Copy-PredefinedAOTprco
Run-CompilePartial

Write-Host "Done!" -ForegroundColor Cyan