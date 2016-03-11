$c = . C:\AX\BuildScripts\Common.ps1
$model1 = Get-Item -Path "C:\Program Files\Microsoft Dynamics AX\60\Server\AXTest\bin\Application\FAX\VAR Model\Model.xml"
$AxBuildDir = "C:\AX\BuildScripts"
$currentLogFolder = "C:\Logs"
$RldLanguage = "en-us"
$logFolder = "C:\Logs\Bin"
$msBuildPath = "C:\Program Files (x86)\MSBuild\12.0\Bin"
$CompileCILTimeout = 60
Create-CurrentLogFolder
$r = Compile-VisualStudioProjects $model1
$r