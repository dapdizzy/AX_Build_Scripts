$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
#$combinedXpoFilename = 'C:\AX\CombinedXPOs\Combined.VAR Model.xpo'
#CreateSpecificXPOs $combinedXpoFilename

$script:startupDir = $MyInvocation.MyCommand.Path

Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

#Copy-Item -Path (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "AOTprco.log") -Destination $clientLogDir -Force -ErrorAction SilentlyContinue 
#Copy-PredefinedAOTprco
$currentLogFolder = 'C:\AX\Build\Drop\LIPS\1.0.0.120\Logs'
Create-PackagesConfig
Install-Packages

break

<#
$compileInLayer = 'var'

$aolParm = ''
$compileInLayerParm = ''
if($compileInLayer -ne $null)
{
    $AolCode = Get-AolCode $compileInLayer
    if ($aolCode -ne '') {$aolParm = '-aolCode={0}' -f $aolCode}
    
    $compileInLayerParm = '-aol={0}' -f $compileInLayer
}

$arguments = '{0} {1} -lazyclassloading -lazytableloading -StartupCmd=compilepartial -novsprojcompileall -internal=noModalBoxes' -f $compileInLayerParm,$aolParm
Write-host ("Calling CompilePartial API : {0}" -f (Get-Date)) 
$axProcess = Start-Process $ax32 -WorkingDirectory $clientBinDir -PassThru -WindowStyle minimized -ArgumentList $arguments -OutVariable out
Write-host $out
Write-InfoLog (" ")
Write-InfoLog (" ")
if ($axProcess.WaitForExit(60000*$CompileAllTimeout) -eq $false)
{
    $axProcess.Kill()
    Throw ("Error: AX compile partial did not complete within {0} minutes" -f $CompileAllTimeout)
}#>