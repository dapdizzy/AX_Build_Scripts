$srcFolder = 'C:\AX\Build\Drop\AXTest\DAXSTDR3\1.0.0.63\VSProjBin'
$dstFolder = 'C:\Tmp'

Remove-Item "$dstFolder\*" -Force -Recurse -ErrorAction SilentlyContinue

Copy-Item "$srcFolder\*" $dstFolder -Force -Recurse -ErrorAction SilentlyContinue