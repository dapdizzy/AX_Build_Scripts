#Load the AX PS libary
$SetupRegistryPath = "HKLM:\SOFTWARE\Microsoft\Dynamics\6.0\Setup"
$x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
$dstFolder = 'C:\AX\Backup\Modelstore'
$configFileName = 'C:\Users\pyatkov\Documents\AxShortcuts\AxServ\AXTest.axc'
Import-AXModelStore -File "$dstFolder\CleanAX.axmodelstore" -Server "MOW04DEV014" -Database "LIPSDEV_model" -IdConflict "Overwrite" -NoPrompt -Details -OutVariable out -Verbose
Read-Host "We're done. What about you?"