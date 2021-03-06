#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration
# Run AXBuild.exe utility
$arguments = ' xppcompileall /s={0}' -f  $script:aosNumber
$axBuildProcess = Start-Process $script:axBuild -WorkingDirectory $script:serverBinDir -PassThru -ArgumentList $arguments -Verbose
Write-InfoLog $out
Write-InfoLog ("                                                                 ") 
Write-InfoLog ("                                                                 ") 

#do {start-sleep -Milliseconds 5000}
#until ($axBuildProcess.HasExited)

if ($axBuildProcess.WaitForExit(60000*$CompileAllTimeout) -eq $false)
{
    $axBuildProcess.Kill()
    Throw ("Error: AX compile did not complete within {0} minutes" -f $CompileAllTimeout)
}

Write-InfoLog ("End of CompileAll API: {0}" -f (Get-Date))

#Copy-Item -Path (Join-Path $script:serverLogDir AxCompileAll.html) -Destination (join-path $currentLogFolder AxCompileAll_Pass1.html) -Force -ErrorAction SilentlyContinue 