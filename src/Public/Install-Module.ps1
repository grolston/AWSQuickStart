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
function  Install-Module {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Name,

        [Parameter(Mandatory=$false)]
        [string[]]$Scope = 'AllUsers'
    )

    try {
        $ErrorActionPreference = "Stop"
        Import-Module PowerShellGet
        PowerShellGet\Install-Module -Name $Name -Scope $Scope
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}