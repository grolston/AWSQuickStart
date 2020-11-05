<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function  Disable-CredSSP {

    try {
        Start-Transcript -Path C:\cfn\log\DisableCredSSP.ps1.txt -Append
        $ErrorActionPreference = "Stop"

        Disable-WSManCredSSP Client
        Disable-WSManCredSSP Server

        Remove-Item -Path 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentials' -ErrorAction Ignore
        Remove-ItemProperty -Path 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation' -Name 'AllowFreshCredentials' -ErrorAction Ignore
        Remove-Item -Path 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly' -ErrorAction Ignore
        Remove-ItemProperty -Path 'hklm:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation' -Name 'AllowFreshCredentialsWhenNTLMOnly' -ErrorAction Ignore
    }
    catch {
        $_ | Write-AWSQuickStartException
    }

}