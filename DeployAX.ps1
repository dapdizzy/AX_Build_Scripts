# Copyright (c) Microsoft 
# All rights reserved.
# Microsoft Limited Public License:
# This license governs use of the accompanying software. If you use the software, you 
# accept this license. If you do not accept the license, do not use the software.
# 1. Definitions 
# The terms "reproduce," "reproduction," "derivative works," and "distribution" have the 
# same meaning here as under U.S. copyright law. 
# A "contribution" is the original software, or any additions or changes to the software. 
# A "contributor" is any person that distributes its contribution under this license. 
# "Licensed patents" are a contributor's patent claims that read directly on its contribution.
# 2. Grant of Rights 
# (A) Copyright Grant- Subject to the terms of this license, including the license conditions and limitations in section 3, each contributor grants you a non-exclusive, worldwide, royalty-free copyright license to reproduce its contribution, prepare derivative works of its contribution, and distribute its contribution or any derivative works that you create. 
# (B) Patent Grant- Subject to the terms of this license, including the license conditions and limitations in section 3, each contributor grants you a non-exclusive, worldwide, royalty-free license under its licensed patents to make, have made, use, sell, offer for sale, import, and/or otherwise dispose of its contribution in the software or derivative works of the contribution in the software.
# 3. Conditions and Limitations 
# (A) No Trademark License- This license does not grant you rights to use any contributors' name, logo, or trademarks. 
# (B) If you bring a patent claim against any contributor over patents that you claim are infringed by the software, your patent license from such contributor to the software ends automatically. 
# (C) If you distribute any portion of the software, you must retain all copyright, patent, trademark, and attribution notices that are present in the software. 
# (D) If you distribute any portion of the software in source code form, you may do so only under this license by including a complete copy of this license with your distribution. If you distribute any portion of the software in compiled or object code form, you may only do so under a license that complies with this license. 
# (E) The software is licensed "as-is." You bear the risk of using it. The contributors give no express warranties, guarantees or conditions. You may have additional consumer rights under your local laws which this license cannot change. To the extent permitted under your local laws, the contributors exclude the implied warranties of merchantability, fitness for a particular purpose and non-infringement.
# (F) Platform Limitation - The licenses granted in sections 2(A) and 2(B) extend only to the software or derivative works that you create that run on a Microsoft Windows operating system product.

#File version: 1.0.2.0
function Create-DeployCompleted
{
    $axbuildError = @() 
    
    $axbuildError | Out-File (join-path $currentLogFolder "DeployCompleted.txt") -Encoding Default 
}

function Get-InputVariables ($homePath, $fileName = "DeployParameters.txt")
{
    $script:AxBuildDir = $homePath
    $RunDeployParmFile = (Join-Path $AxBuildDir $fileName)
    Write-InfoLog "Input parameters"        
    if ((Test-Path $RunDeployParmFile) -ne $false)
    {
        $fileContent = Get-Content $RunDeployParmFile
        foreach ($line in $fileContent)
        {
            Write-InfoLog $line
        
            $line = $line.split("=")
            if($line.Count -eq 2)
            {
                [System.Environment]::SetEnvironmentVariable($line[0],$line[1])     
            }
            else
            {
                Write-InfoLog "Bad DeployParameters file content: {0}" -f $line
            }
        }       
    }   
    if ($script:SqlServer -eq $null -or [string]::IsNullOrEmpty($script:SqlServer))
    {
        $script:SqlServer           = GetEnvironmentVariable("SqlServer")
    }
    if ($script:SqlDatabase -eq $null -or [string]::isNullOrEmpty($script:SqlDatabase))
    {
        $script:SqlDatabase         = GetEnvironmentVariable("SqlDatabase")
    }
    if ($script:sqlModelDatabase -eq $null -or [string]::IsNullOrEmpty($script:sqlModelDatabase))
    {
        $script:sqlModelDatabase    = GetEnvironmentVariable("SqlModelDatabase")
    }
    $script:dropLocation            = GetEnvironmentVariable("BuildLocation")
    # Assume this is 'drop root' (the folder containing concrete build folders) folder in case this is not a 'build folder'
    if ((Is-BuildFolder $script:dropLocation) -ne $true)
    {
        # Override the value with the latest successful build folder found
        $script:dropLocation = (Get-LastSuccessfulBuild $script:dropLocation).FullName
        Write-Output "Deploting build $(Split-Path -Path $script:dropLocation -Leaf)"
    }
    if ($script:ServerBinDir -eq $null -or [string]::isNullOrEmpty($script:serverBinDir))
    {
        $script:ServerBinDir        = GetEnvironmentVariable("ServerBinDir")
    }
    $script:LogFolder               = GetEnvironmentVariable("LogFolder")
    if ($script:LogFolder -eq $null -or [string]::IsNullOrEmpty($script:LogFolder))
    {
        # Override with active AX configuration client log dir in case not defined
        $script:LogFolder = $script:clientLogDir
    }
    # Override variable only in case it is not defined or null
    if ($script:AOSname -eq $null -or [string]::IsNullOrEmpty($script:AOSname))
    {
        $script:AOSname             = GetEnvironmentVariable("AOSname")
    }
    $script:AxCompileAll            = GetEnvironmentVariable("CompileAll")
    $script:CompileCIL              = GetEnvironmentVariable("CompileCIL")
    $script:TFSIntegration          = GetEnvironmentVariable("TFSIntegration")
    $script:TFSUrl                  = GetEnvironmentVariable("TFSUrl")
    $script:TFSLabel                = GetEnvironmentVariable("TFSLabel")
    $script:ApplicationSourceDir    = GetEnvironmentVariable("ApplicationSourceDir")
    <#if ($script:ApplicationSourceDir -eq $null -or [string]::isNullOrEmpty($script:ApplicationSourceDir))
    {
        $local:systemName = GetEnvironmentVariable("SystemName")
        $script:ApplicationSourceDir = Join-Path $script:ServerBinDir "Application\$local:systemName"
        if (Test-Path $script:ApplicationSourceDir -ne $true)
        {
            New-Item -Path $script:ApplicationSourceDir -ItemType Directory -Confirm
        }
    }#>
    $script:CleanOnly               = GetEnvironmentVariable("UninstallOnly")
    $script:AOSNotOnDeployBox       = GetEnvironmentVariable("AOSNotOnDeployBox")
    $script:NoCleanOnError          = GetEnvironmentVariable("NoCleanOnError")
    $script:InstallModelStore       = GetEnvironmentVariable("InstallModelStore")
    $script:MsBuildPath             = GetEnvironmentVariable("MsBuildDir")
    $script:TFSWorkspace            = GetEnvironmentVariable("TFSWorkspace")
    
    if ((Test-Path $RunDeployParmFile) -eq $false)
    {
        $private:buffer = @()
        $buffer += "SqlServer="+ $SqlServer
        $buffer += "SqlDatabase="+ $SqlDatabase
        $buffer += "SqlModelDatabase="+ $SqlModelDatabase
        $buffer += "BuildLocation="+ $dropLocation
        $buffer += "ServerBinDir="+ $ServerBinDir
        $buffer += "LogFolder="+ $LogFolder
        $buffer += "CompileAll=" + $AxCompileAll
        $buffer += "CompileCIL="+ $CompileCIL
        $buffer += "AOSname="+ $AOSname
        $buffer += "UninstallOnly="+ $CleanOnly                         
        $buffer += "AOSNotOnDeployBox="+ $AOSNotOnDeployBox
        $buffer += "NoCleanOnError="+ $NoCleanOnError
        $buffer += "TFSIntegration="+ $TFSIntegration
        $buffer += "TFSUrl="+ $TFSUrl
        $buffer += "TFSLabel="+ $TFSLabel   
        $buffer += "ApplicationSourceDir="+ $ApplicationSourceDir
        $buffer | Out-File $RunDeployParmFile -Encoding Default
    }
    $script:vsProjBinFolder = join-path $dropLocation "VSProjBin"
}

function Validate-InputVariables
{
    $axbuildError = @()
    if ($dropLocation -eq $null)    {$axBuildError += "Folder containing models files to deploy is missing."+[char]10}
    if (($dropLocation -ne $null) -and (Test-path $dropLocation) -eq $false)    {$axBuildError += "Folder containing models files to deploy {0} is not a valid path." -f $dropLocation +[char]10}
    
    if ($dropLocation -ne $null -and (Test-path $dropLocation) -eq $true)
    {
        $appPath = join-path $dropLocation 'Application'
        if ((test-path ($appPath)) -eq $false -or (test-path (join-path $appPath 'appl')) -eq $false)
        {
            $axBuildError += "Drop folder doesn't have valid folders: {0}" -f (join-path $appPath 'appl') +[char]10
        }
        else
        {
            $appPath = join-path $appPath 'Appl'
            $x = Get-ChildItem -Path $appPath -Filter "*.axmodel" -ErrorAction SilentlyContinue
            if($x -eq $null)
            {
                $axBuildError += "Drop folder {0} doesn't contain model files." -f $appPath +[char]10
            }            
        }
    }
        
    if ($LogFolder -eq $null)    {$axBuildError += "Log Folder is missing."+[char]10}
    if ($LogFolder -ne $null -and (Test-path $LogFolder) -eq $false)    {$axBuildError += "Log Folder {0} is not a valid path." -f $LogFolder +[char]10}
    
    if ($ServerBinDir -eq $null) {
        $axBuildError += "The server bin dir is missing."+[char]10}
    if ($ServerBinDir -ne $null) {
        if ((Test-Path -Path $ServerBinDir) -eq $false) {$axBuildError += "The server bin dir {0} is not a valid path." -f $ServerBinDir +[char]10}}
    
    if ($SqlServer -eq $null)    {$axBuildError += "Sql server name is missing."+[char]10}
    if ($SqlDatabase -eq $null)    {$axBuildError += "Sql database name is missing."+[char]10}

    if ($clientBinDir -eq $null) {
        $axBuildError += "The client bin dir is missing."+[char]10}
    if ($clientBinDir -ne $null) {
        if ((Test-Path -Path $clientBinDir) -eq $false) {$axBuildError += "The client bin dir {0} is not a valid path." -f $clientBinDir +[char]10}}
    if ($AOSName -eq $null) {$axBuildError += "AOS name is missing." +[char]10}
    if ($axBuildError -ne $null) 
    {
        $axbuildError | Out-File (join-path "$currentLogFolder" "AxInputValidationErrors.txt") -Encoding Default
        Write-ErrorLog "DEPLOY Failed because of input parameter errors."
        Write-InfoLog $axbuildError
        $axbuildError
    }
}   

function Scan-InputErrors
{
    $retVal = $false
    $axbuildError = @() 
    if((Test-Path (join-path $AxBuildDir 'AxInputValidationErrors.txt')) -eq $True)
    {
        Copy-Item -Path (join-path $AxBuildDir "AxInputValidationErrors.txt") -Destination $currentLogFolder -Force 
        Remove-Item (join-path $AxBuildDir "AxInputValidationErrors.txt")
        $axBuildError += "Some parameters passed are wrong. See AxInputValidationErrors.txt in Logs"+[char]10
        $retVal = $true
    }
    
    if($retVal -eq $true)
    {
        $axbuildError | Out-File (join-path $currentLogFolder "DeployErrors.err") -Encoding Default 
    }
    
    $retVal
}

function Update-InputVariables
{
    if($dropLocation -ne $null -and ((Test-Path $dropLocation) -eq $true)) {
        $script:dependencyPath = join-path $dropLocation 'Application'
    }    
}

function Deploy-AX
{
	#Step 5
    #Set the install mode
    Write-InfoLog ("Calling Set-AXModelStore: {0}" -f (Get-Date)) 
    Set-AXModelStore -NoInstallMode -Database $sqlModelDatabase -Server $sqlServer -OutVariable out
    Write-InfoLog $out
    Write-InfoLog (" ")

    #Step 6
    Stop-AOS
    Write-InfoLog (" ")
    
    Remove-Item -Path (Join-Path $clientLogDir "*.*") -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $env:LOCALAPPDATA "ax_*.auc") -ErrorAction SilentlyContinue
    
    #Clean-Build
    
    if($CleanOnly -ne $true)
    {
        #Step 7
        Install-DependentBinaries

        Copy-VSProjectsBinaries

        Install-PackagesToGAC (Join-Path (Join-Path $dropLocation Logs) Packages)
        
        #Step 8
        Start-AOS
        
        #Step 9
        #Synchronize-AX
        
        #Step 11
        Import-VSProjectsForModel (Join-Path (join-path $dropLocation 'application\appl') 'ModelList.txt')
        <#if ($InstallModelStore -ne $true)
        {
            Load-Models (join-path $dropLocation 'application\appl') 'ModelList.txt'
        }#>
    }

    if ($InstallModelStore -eq $true)
    {
        $modelStoreLocation = (Join-Path $dropLocation 'application\appl')
        # Copy modelstore to the local location
        $localModelStoreLocation = Copy-Modelstores $modelStoreLocation
        # Select only the first *.axmodelstore file for import
        Write-Host "Local modelstore location: $localModelStoreLocation" -ForegroundColor Cyan
        Start-Sleep -Seconds 5
        $modelStore = @(gci -path $localModelStoreLocation -filter *.axmodelstore)[0]
        if ($modelStore -eq $null)
        {
            Write-TerminatingErrorLog "Model store file was not found in the drop folder $localModelStoreLocation"
        }
        $modelStore = $modelStore.FullName

        # It's critical to stop AOS before import 
        Stop-AOS

        Install-ModelStore $modelStore
    }

    Start-AOS

    Synchronize-AX
    
    <#
    Write-InfoLog ''
    Write-InfoLog ''
    Write-InfoLog ''
    Write-Infolog 'Starting synchronization before compiling AX after the model import...........................'
    Write-InfoLog ''
    Write-InfoLog ''
    Write-InfoLog ''
    #>
    
    #Step 12
    #Compile-Ax
}


#Step
#Load common automation library
$c = . (join-path (Split-Path -Parent $MyInvocation.MyCommand.Path) "common.ps1")
$script:scriptName = 'DEPLOY'

try
{   
    $ErrorActionPreference = "Stop"

    #Check-PowerShellVersion
    #Step 
    #Read environment variables comming from the build template (or the parm file)
    Get-InputVariables(Split-Path -Parent $MyInvocation.MyCommand.Path)
    
    <#if($logFolder -eq $null -or (Test-path $logFolder) -eq $false)
    {
        Write-TerminatingErrorLog "Log folder is not a valid path."
    }#>
    
    Write-InfoLog ("Deploy Starting : {0}" -f (Get-Date)) 

    <#Write-InfoLog ("Creating output directories : {0}" -f (Get-Date)) 
    Create-CurrentLogFolder#>
}
catch
{
    Write-ErrorLog "Stack trace:`n$StackTrace"
    Write-TerminatingErrorLog "Error occured while deploying." $Error[0]
}
    
try
{   
    <#$script:transcriptStarted = $true
    Start-Transcript (join-path $currentLogFolder 'DeployLogs.log')#>

    Get-DefaultParameters

    Read-AXClientConfiguration
    Write-Output "Read client configuration"
    if($AOSNotOnDeployBox -ne $True)
    {
        Read-AxServerConfiguration
    }

    Write-Output "Read client/server configurations"

    if(($logFolder -eq $null) -or (Test-path $logFolder) -eq $false)
    {
        Write-TerminatingErrorLog "Log folder is not a valid path."
    }

    Write-InfoLog ("Creating output directories : {0}" -f (Get-Date)) 
    Create-CurrentLogFolder

    Get-OverrideParameters
    Get-ImportOverrideParameters

    <#if($logFolder -eq $null -or (Test-path $logFolder) -eq $false)
    {
        Write-TerminatingErrorLog "Log folder is not a valid path."
    }#>

    #Load the AX PS libary
    $x = . (join-path (join-path (Get-Item $SetupRegistryPath).GetValue("InstallDir") "ManagementUtilities") "Microsoft.Dynamics.ManagementUtilities.ps1")
    
    #Step
    #Read the AX information from the registry
    Update-InputVariables
    <#Read-AXClientConfiguration
    if($AOSNotOnDeployBox -ne $True)
    {
        Read-AxServerConfiguration
    }#>

    #$script:transcriptStarted = $true
    <#Start-Transcript (join-path $currentLogFolder 'DeployLogs.log')
    $script:transcriptStarted = $true

    Write-InfoLog ('Printing all variables')
    Write-InfoLog (Get-Variable)#>

    <#if($logFolder -eq $null -or (Test-path $logFolder) -eq $false)
    {
        Write-TerminatingErrorLog "Log folder is not a valid path."
    }#>

    Write-InfoLog ("Creating output directories : {0}" -f (Get-Date)) 
    Create-CurrentLogFolder

    Write-InfoLog ('Printing all variables')
    Write-InfoLog (Get-Variable)

    Start-Transcript (join-path $currentLogFolder 'DeployLogs.log')
    $script:transcriptStarted = $true
    
    #Step 4
    if ((Validate-InputVariables) -eq $null)
    {
        Register-SQLSnapIn
        Disable-VCS

        if($tfsIntegration -eq $true)
        {
            Sync-FilesToALabel
        }
        
        $script:buildModelStarted = $true
        Deploy-AX
    	if((Test-Path (join-path $currentLogFolder 'DeployErrors.err')) -ne $true)
        {
            Create-DeployCompleted
            Write-InfoLog ("Deploy finished : {0}" -f (Get-Date)) 
            Write-InfoLog ("DEPLOY SUCCESS") 
        }
        else
        {
            #Compile failed so revert and clean environment.
            Write-TerminatingErrorLog "Compilation errors."
        }
    }
    else
    {
        Write-InfoLog ("Validation errors.") 
        Write-InfoLog ("Deploy finished : {0}" -f (Get-Date)) 
        Write-InfoLog ("DEPLOY FAILED")
    }
}
catch
{
    Write-ErrorLog "Stack trace:`n$StackTrace"
    Write-ErrorLog ("Error occured while deploying.")
    Write-ErrorLog ($Error[0])
    
    if($buildModelStarted -eq $true)
    {
        $script:buildModelStarted = $false

        <#try
        {
            if($NoCleanOnError -ne $true)
            {
                Write-InfoLog ("                                                                 ") 
                Write-InfoLog ("*****************************************************************") 
                Write-InfoLog ("****************TRYING TO REVERT BUILD***************************") 
                Clean-Build
                Write-InfoLog ("*****************************************************************") 
                Write-InfoLog ("*****************************************************************") 
                Write-InfoLog ("                                                                 ") 
            }
        }
        catch
        {
            Write-ErrorLog ("Failed to revert build.")
            Write-ErrorLog ($Error[0])
        }#>
    }
    $ErrorActionPreference = "SilentlyContinue"
    Write-InfoLog ("Deploy finished : {0}" -f (Get-Date)) 
    Write-InfoLog ("DEPLOY FAILED")
}
finally
{
    Enable-VCS

    if($transcriptStarted -eq $true)
    {Stop-Transcript}
}

# SIG # Begin signature block
# MIIauwYJKoZIhvcNAQcCoIIarDCCGqgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZtS2zwaf1HXR+k/d8ZULkp0Z
# 5mGgghWCMIIEwzCCA6ugAwIBAgITMwAAADUo7mFTkiJhkQAAAAAANTANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTMwMzI3MjAwODI2
# WhcNMTQwNjI3MjAwODI2WjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OjMxQzUtMzBCQS03QzkxMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm9vWEfGEH1m0
# kUedzTgvsolxQaJbPc6WtX2a9wqAK0ICg8R8//f26pcftWw4XkuVVOjsk9K5TeT3
# KyaHr7vrG+hNHCFDF/igM5qRsYFNOIEkUwKxdnlaLqz7y4xcXTubXKU7NoBsI3S2
# xnffQyfNOpmouBP65aqjt8VzhFbsjsFIMwGJMa8nNq07LQDicQQxvva3dLFnP1rl
# hLUBJpB4iYAlPj5CHFJKZCcCaM6iBr7QtT5EF4CZiImcwLkP1fI5lcM1FLsJEEW5
# 6m5frIDLh3xFZAImCU+adqVmvhBJKKO57P+y+mFb+WPqknL1SurKOz0TkYw7/TnW
# STwC7nod4QIDAQABo4IBCTCCAQUwHQYDVR0OBBYEFLkUVdsQ7WBr1Q2DdA3Oc3OV
# ImUcMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggEBAJaVlxhREadlaCDXqFbP6lUQVKjx5/JsbwouUz8YgQjPN/Y1
# ymKKoJBe4u9HzqrHBZj93hq26BKkmrnKpWKvyOY+ODJcA9PzaPlgnMeyJdykTGuP
# BsvYtsFYIn6E1Wu56PE+L3n28vpsaOjKAl8BvrGgbPmPRbm4SwZfxJSO9+3r1yFa
# uFZbeGfcQAl82pKj27zQmh2O5snaz1Iff7+W3owsX20ilqNJ+acaIl7/6cpyJUC4
# 87hUHlrIV1CyiyLmEOyt7aUQlFLU7VtXgskXVPZ03lGrVDTglUY63lUwGhdwL5f2
# CgYipvqCjochior3gYxSN0w6jQRbNcvzG4N1vl0wggTsMIID1KADAgECAhMzAAAA
# sBGvCovQO5/dAAEAAACwMA0GCSqGSIb3DQEBBQUAMHkxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBMB4XDTEzMDEyNDIyMzMzOVoXDTE0MDQyNDIyMzMzOVowgYMxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
# HjAcBgNVBAMTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAOivXKIgDfgofLwFe3+t7ut2rChTPzrbQH2zjjPmVz+l
# URU0VKXPtIupP6g34S1Q7TUWTu9NetsTdoiwLPBZXKnr4dcpdeQbhSeb8/gtnkE2
# KwtA+747urlcdZMWUkvKM8U3sPPrfqj1QRVcCGUdITfwLLoiCxCxEJ13IoWEfE+5
# G5Cw9aP+i/QMmk6g9ckKIeKq4wE2R/0vgmqBA/WpNdyUV537S9QOgts4jxL+49Z6
# dIhk4WLEJS4qrp0YHw4etsKvJLQOULzeHJNcSaZ5tbbbzvlweygBhLgqKc+/qQUF
# 4eAPcU39rVwjgynrx8VKyOgnhNN+xkMLlQAFsU9lccUCAwEAAaOCAWAwggFcMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRZcaZaM03amAeA/4Qevof5cjJB
# 8jBRBgNVHREESjBIpEYwRDENMAsGA1UECxMETU9QUjEzMDEGA1UEBRMqMzE1OTUr
# NGZhZjBiNzEtYWQzNy00YWEzLWE2NzEtNzZiYzA1MjM0NGFkMB8GA1UdIwQYMBaA
# FMsR6MrStBZYAck3LjMWFrlMmgofMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9j
# cmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY0NvZFNpZ1BDQV8w
# OC0zMS0yMDEwLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljQ29kU2lnUENBXzA4LTMx
# LTIwMTAuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQAx124qElczgdWdxuv5OtRETQie
# 7l7falu3ec8CnLx2aJ6QoZwLw3+ijPFNupU5+w3g4Zv0XSQPG42IFTp8263Os8ls
# ujksRX0kEVQmMA0N/0fqAwfl5GZdLHudHakQ+hywdPJPaWueqSSE2u2WoN9zpO9q
# GqxLYp7xfMAUf0jNTbJE+fA8k21C2Oh85hegm2hoCSj5ApfvEQO6Z1Ktwemzc6bS
# Y81K4j7k8079/6HguwITO10g3lU/o66QQDE4dSheBKlGbeb1enlAvR/N6EXVruJd
# PvV1x+ZmY2DM1ZqEh40kMPfvNNBjHbFCZ0oOS786Du+2lTqnOOQlkgimiGaCMIIF
# vDCCA6SgAwIBAgIKYTMmGgAAAAAAMTANBgkqhkiG9w0BAQUFADBfMRMwEQYKCZIm
# iZPyLGQBGRYDY29tMRkwFwYKCZImiZPyLGQBGRYJbWljcm9zb2Z0MS0wKwYDVQQD
# EyRNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwHhcNMTAwODMx
# MjIxOTMyWhcNMjAwODMxMjIyOTMyWjB5MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJyWVwZMGS/HZpgICBC
# mXZTbD4b1m/My/Hqa/6XFhDg3zp0gxq3L6Ay7P/ewkJOI9VyANs1VwqJyq4gSfTw
# aKxNS42lvXlLcZtHB9r9Jd+ddYjPqnNEf9eB2/O98jakyVxF3K+tPeAoaJcap6Vy
# c1bxF5Tk/TWUcqDWdl8ed0WDhTgW0HNbBbpnUo2lsmkv2hkL/pJ0KeJ2L1TdFDBZ
# +NKNYv3LyV9GMVC5JxPkQDDPcikQKCLHN049oDI9kM2hOAaFXE5WgigqBTK3S9dP
# Y+fSLWLxRT3nrAgA9kahntFbjCZT6HqqSvJGzzc8OJ60d1ylF56NyxGPVjzBrAlf
# A9MCAwEAAaOCAV4wggFaMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFMsR6MrS
# tBZYAck3LjMWFrlMmgofMAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBT90TFO0yaKleGYYDuoMW+mPLzYLTAZBgkrBgEEAYI3
# FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQOrIJgQFYnl+UlE/wq4QpTlVnk
# pDBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtp
# L2NybC9wcm9kdWN0cy9taWNyb3NvZnRyb290Y2VydC5jcmwwVAYIKwYBBQUHAQEE
# SDBGMEQGCCsGAQUFBzAChjhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2Nl
# cnRzL01pY3Jvc29mdFJvb3RDZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAgEAWTk+
# fyZGr+tvQLEytWrrDi9uqEn361917Uw7LddDrQv+y+ktMaMjzHxQmIAhXaw9L0y6
# oqhWnONwu7i0+Hm1SXL3PupBf8rhDBdpy6WcIC36C1DEVs0t40rSvHDnqA2iA6VW
# 4LiKS1fylUKc8fPv7uOGHzQ8uFaa8FMjhSqkghyT4pQHHfLiTviMocroE6WRTsgb
# 0o9ylSpxbZsa+BzwU9ZnzCL/XB3Nooy9J7J5Y1ZEolHN+emjWFbdmwJFRC9f9Nqu
# 1IIybvyklRPk62nnqaIsvsgrEA5ljpnb9aL6EiYJZTiU8XofSrvR4Vbo0HiWGFzJ
# NRZf3ZMdSY4tvq00RBzuEBUaAF3dNVshzpjHCe6FDoxPbQ4TTj18KUicctHzbMrB
# 7HCjV5JXfZSNoBtIA1r3z6NnCnSlNu0tLxfI5nI3EvRvsTxngvlSso0zFmUeDord
# EN5k9G/ORtTTF+l5xAS00/ss3x+KnqwK+xMnQK3k+eGpf0a7B2BHZWBATrBC7E7t
# s3Z52Ao0CW0cgDEf4g5U3eWh++VHEK1kmP9QFi58vwUheuKVQSdpw5OPlcmN2Jsh
# rg1cnPCiroZogwxqLbt2awAdlq3yFnv2FoMkuYjPaqhHMS+a3ONxPdcAfmJH0c6I
# ybgY+g5yjcGjPa8CQGr/aZuW4hCoELQ3UAjWwz0wggYHMIID76ADAgECAgphFmg0
# AAAAAAAcMA0GCSqGSIb3DQEBBQUAMF8xEzARBgoJkiaJk/IsZAEZFgNjb20xGTAX
# BgoJkiaJk/IsZAEZFgltaWNyb3NvZnQxLTArBgNVBAMTJE1pY3Jvc29mdCBSb290
# IENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0wNzA0MDMxMjUzMDlaFw0yMTA0MDMx
# MzAzMDlaMHcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAf
# BgNVBAMTGE1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAJ+hbLHf20iSKnxrLhnhveLjxZlRI1Ctzt0YTiQP7tGn
# 0UytdDAgEesH1VSVFUmUG0KSrphcMCbaAGvoe73siQcP9w4EmPCJzB/LMySHnfL0
# Zxws/HvniB3q506jocEjU8qN+kXPCdBer9CwQgSi+aZsk2fXKNxGU7CG0OUoRi4n
# rIZPVVIM5AMs+2qQkDBuh/NZMJ36ftaXs+ghl3740hPzCLdTbVK0RZCfSABKR2YR
# JylmqJfk0waBSqL5hKcRRxQJgp+E7VV4/gGaHVAIhQAQMEbtt94jRrvELVSfrx54
# QTF3zJvfO4OToWECtR0Nsfz3m7IBziJLVP/5BcPCIAsCAwEAAaOCAaswggGnMA8G
# A1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFCM0+NlSRnAK7UD7dvuzK7DDNbMPMAsG
# A1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADCBmAYDVR0jBIGQMIGNgBQOrIJg
# QFYnl+UlE/wq4QpTlVnkpKFjpGEwXzETMBEGCgmSJomT8ixkARkWA2NvbTEZMBcG
# CgmSJomT8ixkARkWCW1pY3Jvc29mdDEtMCsGA1UEAxMkTWljcm9zb2Z0IFJvb3Qg
# Q2VydGlmaWNhdGUgQXV0aG9yaXR5ghB5rRahSqClrUxzWPQHEy5lMFAGA1UdHwRJ
# MEcwRaBDoEGGP2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1
# Y3RzL21pY3Jvc29mdHJvb3RjZXJ0LmNybDBUBggrBgEFBQcBAQRIMEYwRAYIKwYB
# BQUHMAKGOGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljcm9z
# b2Z0Um9vdENlcnQuY3J0MBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEB
# BQUAA4ICAQAQl4rDXANENt3ptK132855UU0BsS50cVttDBOrzr57j7gu1BKijG1i
# uFcCy04gE1CZ3XpA4le7r1iaHOEdAYasu3jyi9DsOwHu4r6PCgXIjUji8FMV3U+r
# kuTnjWrVgMHmlPIGL4UD6ZEqJCJw+/b85HiZLg33B+JwvBhOnY5rCnKVuKE5nGct
# xVEO6mJcPxaYiyA/4gcaMvnMMUp2MT0rcgvI6nA9/4UKE9/CCmGO8Ne4F+tOi3/F
# NSteo7/rvH0LQnvUU3Ih7jDKu3hlXFsBFwoUDtLaFJj1PLlmWLMtL+f5hYbMUVbo
# nXCUbKw5TNT2eb+qGHpiKe+imyk0BncaYsk9Hm0fgvALxyy7z0Oz5fnsfbXjpKh0
# NbhOxXEjEiZ2CzxSjHFaRkMUvLOzsE1nyJ9C/4B5IYCeFTBm6EISXhrIniIh0EPp
# K+m79EjMLNTYMoBMJipIJF9a6lbvpt6Znco6b72BJ3QGEe52Ib+bgsEnVLaxaj2J
# oXZhtG6hE6a/qkfwEm/9ijJssv7fUciMI8lmvZ0dhxJkAj0tr1mPuOQh5bWwymO0
# eFQF1EEuUKyUsKV4q7OglnUa2ZKHE3UiLzKoCG6gW4wlv6DvhMoh1useT8ma7kng
# 9wFlb4kLfchpyOZu6qeXzjEp/w7FW1zYTRuh2Povnj8uVRZryROj/TGCBKMwggSf
# AgEBMIGQMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xIzAh
# BgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBAhMzAAAAsBGvCovQO5/d
# AAEAAACwMAkGBSsOAwIaBQCggbwwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFHjL
# pm/Cv+7xSFf0KhzO1HP2CyODMFwGCisGAQQBgjcCAQwxTjBMoBqAGABEAGUAcABs
# AG8AeQBBAFgALgBwAHMAMaEugCxodHRwOi8vd3d3Lk1pY3Jvc29mdC5jb20vTWlj
# cm9zb2Z0RHluYW1pY3MvIDANBgkqhkiG9w0BAQEFAASCAQBHW/DQK5+IjVJ5yeVn
# xMnJlV9Rv6NsMQ2hAnZb6V4S/UbAmfUXkKYxtWOdOfOV3W9RkyCD2GBbpwdPBhmG
# H7zhPIn8zSK1b6R6MmS4mlwk3Ua/4uWC66deFv/pfSbsIR3XcFxbQI3yaNrucw+k
# qoniFjOmvIrF44SU9uv+kvsYQB3zMLNqCyUcRfpqwmh07PpmBAo1IdpmNuNgN7Id
# uFThVvz00hakxr3b53m2qsqtXj2lhaUrWoQl/g7IkJEG6r0xB0keRsycLFd4D1oQ
# TdJ2LYuN4hxTrxtcg+C6nOB13W1ZT+mcBelDnQ/lp6WGVXtXQ8fMsP/g8K54BRrE
# vrGCoYICKDCCAiQGCSqGSIb3DQEJBjGCAhUwggIRAgEBMIGOMHcxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQQITMwAAADUo7mFTkiJhkQAAAAAANTAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTMwNjIx
# MjIxNzAxWjAjBgkqhkiG9w0BCQQxFgQUC5d9kX9p3Shb0ITBV6NImA7nNzAwDQYJ
# KoZIhvcNAQEFBQAEggEATjYO6IXANugaIlkwAAos3HGsThWHIQV/KH8zMQxJP8WF
# NCjyLw7ObBlicJxMv5jmIQVBIHrg3td2geQX+AiMihSBbRO4DEBUjXg3vy1C88Dq
# LUaZ6R6oe/qR+JXyjvmyI7yAVMwD0ZFboYmo8HM2GlIi6pGqcDSxca5Lzoan7Aee
# jRW7ZgjLlHZT7jaDjNVLmkgrZodETEN4fR5Mi2b0y1Vqap+eJ3HBM51zbPk2dyEy
# CSQJqYoxA2HykkmOddXqRD5PAkzLthJ7/7pTqwRghPaYgpbnbWL6EiQX3keAstBE
# QrIFTRQyG6/ZcYT8kpSu6BidfigzgxbHgPOSRdH/Cg==
# SIG # End signature block
