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
function Reset-LocalAdminPassword {
    [CmdletBinding()]
    param(
        [string]
        $password
    )

    try {
        Write-Verbose "Resetting local admin password"
        ([adsi]("WinNT://$env:COMPUTERNAME/administrator, user")).psbase.invoke('SetPassword', $password)
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}