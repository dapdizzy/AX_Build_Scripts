$buffer = @()
$folder = 'C:\Program Files\Microsoft Dynamics AX\60\Server\LIPSDEV\bin\Application\LIPS\VAR Model\Projects'
gci -Path "$folder\*" -include "*.xpo" -Recurse | ForEach-Object {$buffer += $_.Name.Split('.')[0]}
$buffer | Out-File -FilePath 'C:\AX\AllProjects.txt' -Encoding ascii