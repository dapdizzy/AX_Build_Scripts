$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")

#$combinedXpoFilename = 'C:\AX\CombinedXPOs\Combined.VAR Model.xpo'
#CreateSpecificXPOs $combinedXpoFilename

#Write-ErrorLog 'Some error message here...'
#return

$script:startupDir = $MyInvocation.MyCommand.Path

Get-OverrideParameters
Read-AXClientConfiguration
Read-AxServerConfiguration

Ensure-AOTObjectsImported

break

#Create-AOTObjectsTxt (Get-Item 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSDEV\bin\Application\LIPS\VAR Model\Model.xml')

#break

Verify-AOTObjectsImported

break

<#$applicationSourceDir = 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSAX\bin\Application\LIPS'

Import-MissedObjects

break#>

<#Create-AOTObjectsTxt (Get-Item -Path 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSAX\bin\Application\LIPS\VAR Model\Model.xml')
break#>

$arguments = "-StartupCmd=verifyAOTObjects"
$axProcess = Start-Process $ax32 -WorkingDirectory $clientBinDir -PassThru -WindowStyle minimized -ArgumentList $arguments -OutVariable out
Write-host $out
Write-InfoLog (" ")
Write-InfoLog (" ")
if ($axProcess.WaitForExit(60000*5) -eq $false)
{
    $axProcess.Kill()
    Throw ("Error: AX AOT objects verification did not complete within {0} minutes" -f 5)
}

Write-Host 'Done!' -ForegroundColor Cyan

break


$currentLogFolder = 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSAX\bin\Application\LIPS\VAR Model\Projects\Shared'

<#$projectFilesMap = @{}
$projectList = @()

$projectContents = Get-Content -Path 'C:\AX\Projects.txt'
foreach ($line in $projectContents)
{
    if ($projectFilesMap.ContainsKey($line) -eq $true)
    {
        Write-Host "Duplicate project $line" -ForegroundColor Red -BackgroundColor Black
        continue
    }
    $projectFilesMap.Add($line, @())
    $projectList += $line
}

$files = gci -Path "$currentLogFolder\*" -include 'Combined.VAR Model_prj(*).xpo' | Where-Object {$_.Name -match 'Combined.VAR Model_prj\([0-9]+\)\.xpo'}

foreach ($projectName in $projectList)
{
    Write-Host "Looking for project $projectName" -ForegroundColor Cyan
    $filesList = $projectFilesMap.get_Item($projectName)
    foreach ($file in $files)
    {
        Write-Host "Searching in file $($file.Name)" -ForegroundColor Green
        $contents = Get-Content -Path $file.FullName
        foreach ($line in $contents)
        {
            if ($line -match "Microsoft Dynamics AX Project[ :]+$projectName\b")
            {
                $filesList += $file.Name
                break
            }
        }
    }
    $projectFilesMap.set_Item($projectName, $filesList)
}

$lines = @()
foreach ($projectName in $projectFilesMap)
{
    $filesList = $projectFilesMap.get_Item($projectName)
    $line = "$projectName <--> $([string]::Join(', ', $filesList))"
    $lines += $line
}
$lines | Out-File -FilePath 'C:\AX\Project2FilesMapping.txt' -Encoding default

break#>

<#$fileName = 'C:\AX\Projects.txt'
$proj2FileMap = @{}
$contents = Get-Content -Path $filePath
foreach ($line in $contents)
{
    if ($line -match 'Microsoft Dynamics AX Project[ :]+(?<projectName>[a-zA-Z0-9_]+)\b')
    {
        $projectName = $matches['projectName']
        if ($proj2FileMap.ContainsKey($projectName) -ne $true)
        {
            $projFiles = @()
        }
        else
        {
            $projFiles = $proj2FileMap.Get_Item($projectName)
        }
        $projFiles += 
    }
}#>

$axLayer = 'var'

$aolCode = 'gR8aYLQYS3Yzj94qIoOUOA=='

$Model = Get-Item -Path 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSAX\bin\Application\LIPS\VAR Model\Model.xml'

Import-XPO 'MMS_FormInfo.xpo'

break

$fileProjectsMap =@{}
$counter = 0
$files = gci -Path "$currentLogFolder\*" -include 'Combined.VAR Model_prj(*).xpo' | Where-Object {$_.Name -match 'Combined.VAR Model_prj\([0-9]+\)\.xpo'}
foreach ($file in $files)
{
    $contents = Get-Content $file
    $projects = @()
    foreach ($line in $contents)
    {
        if ($line -match 'Microsoft Dynamics AX Project[ :]+(?<projectName>[a-zA-Z0-9_]+)\b')
        {
            $projects += $matches['projectName']
        }
    }
    $fileProjectsMap.Add($file.Name, $projects)
}

$fileProjectsMap | Out-File -Path 'C:\AX\FileProjectsMap.txt' -Encoding default
break

<#$filePath = Join-Path $currentLogFolder 'Combined.VAR Model.xpo'
if ((Test-Path -Path $filePath) -ne $true)
{
    Write-Host "Seems like $filePath does not exist" -ForegroundColor Red -BackgroundColor Black
    break
}#>

#$nlines = 0
#select-string -pattern 'Microsoft Dynamics AX Project[ :]+(?<projectName>[a-zA-Z0-9_]+)\b' -path $filePath | % { $projects += $_.Matches.Captures['projectName'] }


<#$contents = Get-Content -Path $filePath
foreach ($line in $contents)
{
    if ($line -match 'Microsoft Dynamics AX Project[ :]+(?<projectName>[a-zA-Z0-9_]+)\b')
    {
        $projects += $matches['projectName']
    }
}
#>

$projects | Out-File -FilePath 'C:\AX\Projects_I.txt' -Encoding default

break

$items = gci -Path "$currentLogFolder\*" -Include 'Combined.VAR Model_prj*.xpo'
foreach ($item in $items)
{
    $contents = Get-Content $items
    foreach ($line in $content)
    {
        if ($line -match 'MMS_811_SourceSistemUpd')
        {
            Write-Host $file.Name -ForegroundColor Cyan
        }
    }
    #Import-XPO $item.Name # 'Combined.VAR Model_prj.xpo'
}

#CreateSpecificXPOs 'C:\AX\Build\Drop\LIPS\1.0.0.184\Logs\Combined.VAR Model.xpo'

break

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