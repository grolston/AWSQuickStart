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
function Restart-Computer {
    [CmdletBinding()]
    param()

    try {
        $ErrorActionPreference = "Stop"

        # Execute restart after script exit and allow time for external services
        $shutdown = Start-Process -FilePath "shutdown.exe" -ArgumentList @("/r", "/t 10") -Wait -NoNewWindow -PassThru
        if ($shutdown.ExitCode -ne 0) {
            throw "[ERROR] shutdown.exe exit code was not 0. It was actually $($shutdown.ExitCode)."
        }
    }
    catch {
        $_ | Write-AWSQuickStartException
    }
}