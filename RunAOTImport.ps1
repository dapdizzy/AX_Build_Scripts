$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

Get-DefaultParameters

Read-AXClientConfiguration
Read-AXServerConfiguration

$script:axLayer = "VAR"
$script:aolCode = "gR8aYLQYS3Yzj94qIoOUOA=="

Run-AOTImport "C:\AX\Build\Drop\Lips\1.0.0.16\Logs\Combined.VAR Model_sysTab.xpo"