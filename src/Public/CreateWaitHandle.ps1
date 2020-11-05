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
function Create-WaitHandle {
[CmdletBinding()]
param(
    [string]
    $Handle
)

Write-Verbose "Creating Handle Key with $Handle"
New-AWSQuickStartWaitHandle -Handle $Handle
}