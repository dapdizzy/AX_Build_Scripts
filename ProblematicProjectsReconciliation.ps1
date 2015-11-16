function FlatFileToHashSet($fileName)
{
    if (($fileName -eq $null) -or ((Test-Path $fileName) -eq $false))
    {
        return $null
    }

    $contents = Get-Content -Path $fileName

    . $hsm $contents
}

function FlatFileToSortedSet($fileName)
{
    if ($fileName -eq $null -or (Test-Path $fileName) -eq $false)
    {
        return $null
    }

    $contents = Get-Content -Path $fileName

    . $newSorredSet $contents
}

$newSorredSet = (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "New-SortedSet.ps1")

$ss = . $newSorredSet 1, 3, 5, 7, 9

<#Write-Host "SortedSet length $($ss.Count)"

Read-Host

break#>

#$hsm = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "HashSetMagic.ps1")
$hsm = (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "HashSetMagic.ps1")

#$hs = . $hsm 1,3,5,7
#break

$p1 = FlatFileToHashSet 'C:\AX\Projects.txt'
$p2 = FlatFileToHashSet 'C:\AX\Projects_I.txt'
$p3 = FlatFileToHashSet 'C:\AX\AllProjects.txt'

<#$buffer = @()
foreach ($item in $p1)
{
    if ($item -ne $null)
    {
        $buffer += $item.ToString()
    }
}
$buffer | Out-file -FilePath 'C:\AX\ProjectsP1.txt' -Encoding ascii

$buffer = @()
foreach ($item in $p2)
{
    $buffer += $item
}
$buffer | Out-File -FilePath 'C:\AX\ProjectsP2.txt' -Encoding ascii

$buffer = @()
foreach ($item in $p3)
{
    $buffer += $item
}
$buffer | Out-File -FilePath 'C:\AX\ProjectsP3.txt' -Encoding ascii

break#>

Write-Host "Combined XPO contains $($p1.Count) projects" -ForegroundColor Cyan
Write-Host "Projects split by multiple 100Kb XPOs contain $($p2.Count) projects" -ForegroundColor Cyan

if ($p1.SetEquals($p2) -eq $true)
{
    $conclusion = 'Those sets are equal'
}
elseif ($p1.IsSupersetOf($p2) -eq $true)
{
    $conclusion = 'Second set is a subset of the first one'
}
elseif ($p1.IsSubsetOf($p2) -eq $true)
{
    $conclusion = "It's weird to state, but the first set is a subset of the second one"
}
else
{
    $conclusion = 'There are no feasible relationships between the two sets'
}

Write-Host $conclusion -ForegroundColor Cyan

Write-Host "The third set, collected from the local repo representation contains $($p3.Count) elements"

Write-Host 'Comparison with the first set' -ForegroundColor Green

if ($p3.SetEquals($p1) -eq $true)
{
    $conclusion = 'Those sets are equal'
}
elseif ($p3.IsSupersetOf($p1) -eq $true)
{
    $conclusion = 'First set is a subset of the third one'
}
elseif ($p3.IsSubsetOf($p1) -eq $true)
{
    $conclusion = "It's weird to state, but the third set is a subset of the first one"
}
else
{
    $conclusion = 'There are no feasible relationships between the two sets'
}

Write-Host $conclusion -ForegroundColor Cyan

Write-Host 'Comparison with the second set' -ForegroundColor Green

if ($p3.SetEquals($p2) -eq $true)
{
    $conclusion = 'Those sets are equal'
}
elseif ($p3.IsSupersetOf($p2) -eq $true)
{
    $conclusion = 'Second set is a subset of the third one'
}
elseif ($p3.IsSubsetOf($p2) -eq $true)
{
    $conclusion = "It's weird to state, but the third set is a subset of the second one"
}
else
{
    $conclusion = 'There are no feasible relationships between the two sets'
}

Write-Host $conclusion -ForegroundColor Cyan


Write-Host "p3 set length before substraction $($p3.Count)"
Write-Host "p1 set length $($p1.Count)"

$p3.ExceptWith($p1)

Write-Host "p3 set length after substraction of p1 set $($p3.Count)"

Write-Host "p2 set length is $($p2.Count)"

$p3.ExceptWith($p2)

Write-Host "p3 length after substraction with p2 $($p3.Count)"

#$p3.IntersectWith($p1)

#Write-Host "p3 length after intersection with p1 $($p3.Count)"

Read-Host

Write-Host "And finally, please welcome! The missed project elements from local repo file representation ($($p3.Count) total):"

foreach ($item in $p3)
{
    Write-Host $item
}

Write-Host 'Thanks Your for paying with your attention! Have a Great Flight!' -ForegroundColor White

break