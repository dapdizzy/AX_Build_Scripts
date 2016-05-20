$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

$folder = "C:\AX\Build\Drop\Lips\1.0.0.16\Logs\Packages"

Get-DefaultParameters

Install-PackagesToGAC $folder