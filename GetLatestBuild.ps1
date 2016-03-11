$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

$folder = $args[0]

Write-Output (Get-LatestBuildFolder $folder).Name
Write-Output (Get-LastSuccessfulBuild $folder).Name