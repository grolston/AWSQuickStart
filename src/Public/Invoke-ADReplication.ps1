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
function  Invoke-ADReplication {
    [CmdletBinding()]
    param(
        [string]
        $UserName,

        [string]
        $Password,

        [string]
        $DomainController
    )

    try {
        $pass = ConvertTo-SecureString $Password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName,$pass

        $sb = {
            repadmin /syncall /A /e /P
        }

        Write-Verbose "Invoking repadmin on $DomainController"
        Invoke-Command -ScriptBlock $sb -ComputerName $DomainController -Credential $cred -ErrorAction Stop
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}