$fileName = 'C:\AX\ProblematicProjects.txt'
$contents = Get-Content -Path $fileName
$buffer = @()
foreach ($line in $contents)
{
    $split = $line.Split('`\')
    $buffer += $split[$split.Length - 1].Trim()
}
$buffer | Out-File -FilePath 'C:\AX\ProblematicProjectsNames.txt' -Encoding default