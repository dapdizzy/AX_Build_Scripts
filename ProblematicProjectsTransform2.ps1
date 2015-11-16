$fileName = 'C:\AX\ProblematicProjectsNames.txt'
$problematicProjects = Get-Content -Path $fileName
$fileName = 'C:\AX\Project2FilesMapping.txt'
$mappingLines = Get-Content -Path $fileName
$mapping = @{}
foreach ($line in $mappingLines)
{
    $split = $line.Split(@('<-->'), [System.StringSplitOptions]::None)
    $mapping.Add($split[0].Trim(), $split[1].Trim())
}
$buffer = @()
foreach ($project in $problematicProjects)
{
    $files = $mapping.get_Item($project)
    $buffer += "$project <--> $files"
}
$buffer | Out-File -FilePath 'C:\AX\ProblematicProjectMapping.txt' -Encoding default