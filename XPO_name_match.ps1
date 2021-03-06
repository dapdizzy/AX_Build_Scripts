$path = 'C:\PROGRAM FILES\MICROSOFT DYNAMICS AX\60\SERVER\LIPSAX\BIN\APPLICATION\LIPS\'
$result = ''
foreach ($file in (gci -Path "$path\*" -Include "*.xpo" -ErrorAction SilentlyContinue -Recurse))
{
    Write-Host ("{0} `n" -f $file.FullName)
    $contents = Get-Content $file.FullName
    if ($contents -match 'MMS_MemberContractDataAttribute' -or $contents -match 'MMS_DataUnpackProcessing')
    {
        $result += $file.FullName + "`n"
    }
}

Write-Host '----------------------------------------------------------------------------------------------'
Write-Host "Result`n"

Write-Host $result

Read-Host 'R U surprised?'