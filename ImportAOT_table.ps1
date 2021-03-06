$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
#Get-InputVariables(Split-Path -Parent $MyInvocation.MyCommand.Path)
$AxBuildDir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

$xpoFileName = 'C:\AX\CombinedXPOs\Combined.VAR Model_sysTab.xpo'
#$xpoFileName = 'C:\AX\Build\Drop\LIPS\1.0.0.106\Logs\Combined.VAR Model_sysTab.xpo'

$arguments = ('-lazyclassloading -lazytableloading "-StartupCmd=aotimport_{0}" -internal=noModalBoxes' -f $xpoFileName)
$axProcess = Start-Process $ax32 -WorkingDirectory $clientBinDir -PassThru -WindowStyle minimized -ArgumentList $arguments -OutVariable out
Write-Host $out
if ($axProcess.WaitForExit(60000*10) -eq $false)
{
    Write-Host("Error: AX AOT import did not complete within {0} minutes" -f 10)
	$axProcess.Kill()
}