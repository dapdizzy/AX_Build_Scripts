$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$AxBuildDir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration
#$tId = 965
Synchronize-AX 'SysUserInfo'