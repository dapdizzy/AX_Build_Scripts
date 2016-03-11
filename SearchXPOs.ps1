$expression = 'Microsoft Dynamics AX Class: MMS_CMKateChangeStatusControl_ToPay'
$cnt = 0
foreach ($item in (gci -Path "C:\Program Files\Microsoft Dynamics AX\60\Server\AXTest\bin\Application\FAX\VAR Model\Classes\*" -Include *.xpo -Recurse))
{
    $contents = Get-Content $item
    if ($contents -match $expression)
    {
        Write-Host "$($item.Name)" -ForegroundColor Cyan
    }
    $cnt++
}
Write-Host "$cnt files iterated" -ForegroundColor Green