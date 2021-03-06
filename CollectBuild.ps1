#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

$script:droplocation = 'C:\AX\Build\Drop\AXTest\DAXSTDR3\1.0.0.35'

$model = gi -Path 'C:\Program Files\Microsoft Dynamics AX\60\Server\AXTest\bin\Application\DAXSTDR3\VAR Model\Model.xml'

$models = @($model)

#Load the AX PS libary
$x = . (join-path 'C:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities' "Microsoft.Dynamics.ManagementUtilities.ps1")

Collect-Build $models
