﻿<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Set-Dns {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ns1,

        [Parameter(Mandatory=$true)]
        [string]$ns2
    )

    try {
        Start-Transcript -Path C:\cfn\log\Set-Dns.ps1.txt -Append
        $ErrorActionPreference = "Stop"

        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $ns1,$ns2

    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}