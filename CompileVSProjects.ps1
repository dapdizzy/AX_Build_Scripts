#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

$script:axLayer = 'VAR'
$script:msBuildPath = 'C:\Program Files (x86)\MSBuild\12.0\Bin'
$script:AxBuildDir = 'C:\AX\BuildScripts'
$script:currentLogFolder = 'C:\AX\Build\Drop\AXTest\DAXSTDR3\1.0.0.43\Logs'
$script:CompileCILTimeout = 10

$model = gi -Path 'C:\Program Files\Microsoft Dynamics AX\60\Server\AXTest\bin\Application\DAXSTDR3\VAR Model\Model.xml'
Compile-VisualStudioProjects $model