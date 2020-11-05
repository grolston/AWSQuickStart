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
function Join-ADDSDomain {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$DomainName,

        [Parameter(Mandatory=$true)]
        [string]$UserName,

        [Parameter(Mandatory=$true)]
        [string]$Password,

        [Parameter(Mandatory=$false)]
        [string]$NewName,

        [Parameter(Mandatory=$false)]
        [switch]$Restart
    )

    try {
        $ErrorActionPreference = "Stop"

        $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName,$securePassword

        $addComputerParams = @{
            DomainName = $DomainName
            Credential = $creds
            Force = $true
            ErrorAction = [System.Management.Automation.ActionPreference]::Stop
        }

        if (-not [string]::IsNullOrEmpty($NewName)) {
            $renameComputerParams = @{
                NewName = $NewName
                Force = $true
            }

            Rename-Computer @renameComputerParams

            $addComputerParams.Add("NewName",$NewName)
        }

        Add-Computer @addComputerParams

        if ($Restart) {
            # Execute restart after script exit and allow time for external services
            $shutdown = Start-Process -FilePath "shutdown.exe" -ArgumentList @("/r", "/t 10") -Wait -NoNewWindow -PassThru
            if ($shutdown.ExitCode -ne 0) {
                throw "[ERROR] shutdown.exe exit code was not 0. It was actually $($shutdown.ExitCode)."
            }
        }
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}