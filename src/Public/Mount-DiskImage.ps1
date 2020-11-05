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
function Mount-DiskImage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ImagePath
    )

    try {
        $ErrorActionPreference = "Stop"

        Mount-DiskImage -ImagePath $ImagePath
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}