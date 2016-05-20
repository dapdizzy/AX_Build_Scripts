function Set-CurrentAXClientConfiguration($configuration)
{
    $path = "HKCU:\SOFTWARE\Microsoft\Dynamics\6.0\Configuration"
    Set-ItemProperty -Path $path -Name Current $configuration
}

Set-CurrentAXClientConfiguration $args[0]