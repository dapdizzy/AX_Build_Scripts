$wc = New-Object System.Net.WebClient
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

Start-Process "C:\Program Files (x86)\Microsoft Dynamics AX\60\Client\Bin\Ax32.exe"