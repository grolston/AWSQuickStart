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
function New-AWSQuickStartWaitHandle {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string]
      $Handle,

      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\',

      [Parameter(Mandatory=$false)]
      [switch]
      $Base64Handle
  )

  try {
      $ErrorActionPreference = "Stop"

      Write-Verbose "Creating $Path"
      New-Item $Path -Force

      if ($Base64Handle) {
          Write-Verbose "Trying to decode handle Base64 string as UTF8 string"
          $decodedHandle = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Handle))
          if ($decodedHandle -notlike "http*") {
              Write-Verbose "Now trying to decode handle Base64 string as Unicode string"
              $decodedHandle = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Handle))
          }
          Write-Verbose "Decoded handle string: $decodedHandle"
          $Handle = $decodedHandle
      }

      Write-Verbose "Creating Handle Registry Key"
      New-ItemProperty -Path $Path -Name Handle -Value $Handle -Force

      Write-Verbose "Creating ErrorCount Registry Key"
      New-ItemProperty -Path $Path -Name ErrorCount -Value 0 -PropertyType dword -Force
  }
  catch {
      Write-Verbose $_.Exception.Message
  }
}

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
function New-AWSQuickStartResourceSignal {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string]
      $Stack,

      [Parameter(Mandatory=$true)]
      [string]
      $Resource,

      [Parameter(Mandatory=$true)]
      [string]
      $Region,

      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  try {
      $ErrorActionPreference = "Stop"

      Write-Verbose "Creating $Path"
      New-Item $Path -Force

      Write-Verbose "Creating Stack Registry Key"
      New-ItemProperty -Path $Path -Name Stack -Value $Stack -Force

      Write-Verbose "Creating Resource Registry Key"
      New-ItemProperty -Path $Path -Name Resource -Value $Resource -Force

      Write-Verbose "Creating Region Registry Key"
      New-ItemProperty -Path $Path -Name Region -Value $Region -Force

      Write-Verbose "Creating ErrorCount Registry Key"
      New-ItemProperty -Path $Path -Name ErrorCount -Value 0 -PropertyType dword -Force
  }
  catch {
      Write-Verbose $_.Exception.Message
  }
}

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
function Get-AWSQuickStartErrorCount {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  process {
      try {
          Write-Verbose "Getting ErrorCount Registry Key"
          Get-ItemProperty -Path $Path -Name ErrorCount -ErrorAction Stop | Select-Object -ExpandProperty ErrorCount
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Set-AWSQuickStartErrorCount {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory, ValueFromPipeline=$true)]
      [int32]
      $Count,

      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  process {
      try {
          $currentCount = Get-AWSQuickStartErrorCount
          $currentCount += $Count

          Write-Verbose "Creating ErrorCount Registry Key"
          Set-ItemProperty -Path $Path -Name ErrorCount -Value $currentCount -ErrorAction Stop
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Get-AWSQuickStartWaitHandle {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  process {
      try {
          $ErrorActionPreference = "Stop"

          Write-Verbose "Getting Handle key value from $Path"
          $key = Get-ItemProperty $Path

          return $key.Handle
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Get-AWSQuickStartResourceSignal {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  try {
      $ErrorActionPreference = "Stop"

      Write-Verbose "Getting Stack, Resource, and Region key values from $Path"
      $key = Get-ItemProperty $Path
      $resourceSignal = @{
          Stack = $key.Stack
          Resource = $key.Resource
          Region = $key.Region
      }
      $toReturn = New-Object -TypeName PSObject -Property $resourceSignal

      if ($toReturn.Stack -and $toReturn.Resource -and $toReturn.Region) {
          return $toReturn
      } else {
          return $null
      }
  }
  catch {
      Write-Verbose $_.Exception.Message
  }
}

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
function Remove-AWSQuickStartWaitHandle {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  process {
      try {
          $ErrorActionPreference = "Stop"

          Write-Verbose "Getting Handle key value from $Path"
          $key = Get-ItemProperty -Path $Path -Name Handle -ErrorAction SilentlyContinue

          if ($key) {
              Write-Verbose "Removing Handle key value from $Path"
              Remove-ItemProperty -Path $Path -Name Handle
          }
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Remove-AWSQuickStartResourceSignal {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$false)]
      [string]
      $Path = 'HKLM:\SOFTWARE\AWSQuickStart\'
  )

  try {
      $ErrorActionPreference = "Stop"

      foreach ($keyName in @('Stack','Resource','Region')) {
          Write-Verbose "Getting Stack, Resource, and Region key values from $Path"
          $key = Get-ItemProperty -Path $Path -Name $keyName -ErrorAction SilentlyContinue

          if ($key) {
              Write-Verbose "Removing $keyName key value from $Path"
              Remove-ItemProperty -Path $Path -Name $keyName
          }
      }
  }
  catch {
      Write-Verbose $_.Exception.Message
  }
}

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
function Write-AWSQuickStartEvent {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory, ValueFromPipelineByPropertyName=$true)]
      [string]
      $Message,

      [Parameter(Mandatory=$false)]
      [string]
      $EntryType = 'Error'
  )

  process {
      Write-Verbose "Checking for AWSQuickStart Eventlog Source"
      if(![System.Diagnostics.EventLog]::SourceExists('AWSQuickStart')) {
          New-EventLog -LogName Application -Source AWSQuickStart -ErrorAction SilentlyContinue
      }
      else {
          Write-Verbose "AWSQuickStart Eventlog Source exists"
      }

      Write-Verbose "Writing message to application log"

      try {
          Write-EventLog -LogName Application -Source AWSQuickStart -EntryType $EntryType -EventId 1001 -Message $Message
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Write-AWSQuickStartException {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory, ValueFromPipeline=$true)]
      [System.Management.Automation.ErrorRecord]
      $ErrorRecord
  )

  process {
      try {
          Write-Verbose "Incrementing error count"
          Set-AWSQuickStartErrorCount -Count 1

          Write-Verbose "Getting total error count"
          $errorTotal = Get-AWSQuickStartErrorCount

          $errorMessage = "Command failure in {0} {1} on line {2} `nException: {3}" -f $ErrorRecord.InvocationInfo.MyCommand.name,
                                                      $ErrorRecord.InvocationInfo.ScriptName, $ErrorRecord.InvocationInfo.ScriptLineNumber, $ErrorRecord.Exception.ToString()

          $CmdSafeErrorMessage = $errorMessage -replace '[^a-zA-Z0-9\s\.\[\]\-,:_\\\/\(\)]', ''
          if ($CmdSafeErrorMessage.length -gt 255) {
              $CmdSafeErrorMessage = $CmdSafeErrorMessage.substring(0,252) + '...'
          }

          $handle = Get-AWSQuickStartWaitHandle -ErrorAction SilentlyContinue
          if ($handle) {
              Invoke-Expression "cfn-signal.exe -e 1 --reason='$CmdSafeErrorMessage' '$handle'"
          } else {
              $resourceSignal = Get-AWSQuickStartResourceSignal -ErrorAction SilentlyContinue
              if ($resourceSignal) {
                  Invoke-Expression "cfn-signal.exe -e 1 --stack '$($resourceSignal.Stack)' --resource '$($resourceSignal.Resource)' --region '$($resourceSignal.Region)'"
              } else {
                  throw "No handle or stack/resource/region found in registry"
              }
          }
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
      finally {
          Write-AWSQuickStartEvent -Message $errorMessage
          # throwing an exception to force cfn-init execution to stop
          throw $CmdSafeErrorMessage
      }
  }
}

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
function Write-AWSQuickStartStatus {
  [CmdletBinding()]
  Param()

  process {
      try {
          Write-Verbose "Checking error count"
          if((Get-AWSQuickStartErrorCount) -eq 0) {
              Write-Verbose "Getting Handle"
              $handle = Get-AWSQuickStartWaitHandle -ErrorAction SilentlyContinue
              if ($handle) {
                  Invoke-Expression "cfn-signal.exe -e 0 '$handle'"
              } else {
                  $resourceSignal = Get-AWSQuickStartResourceSignal -ErrorAction SilentlyContinue
                  if ($resourceSignal) {
                      Invoke-Expression "cfn-signal.exe -e 0 --stack '$($resourceSignal.Stack)' --resource '$($resourceSignal.Resource)' --region '$($resourceSignal.Region)'"
                  } else {
                      throw "No handle or stack/resource/region found in registry"
                  }
              }
          }
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}

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
function Write-AWSQuickStartCWLogsEntry {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true)]
      [string] $logGroupName,
      [Parameter(Mandatory = $true)]
      [string] $LogStreamName,
      [Parameter(Mandatory = $true)]
      [string] $LogString
  )
  Process {
      try {
          Write-Verbose "Checking for existing Log Group : $logGroupName"
          #Determine if the LogGroup Exists
          If (-Not (Get-CWLLogGroup -LogGroupNamePrefix $logGroupName)) {
              Write-Verbose "No existing Log Group found. Creating new Log Group : $logGroupName"
              New-CWLLogGroup -LogGroupName $logGroupName
              Write-Verbose "Creating new Log Stream : $logStreamName"
              New-CWLLogStream -LogGroupName $logGroupName -LogStreamName $logStreamName
          }
          #Determine if the LogStream Exists
          Write-Verbose "Existing Log Group found. Checking for existing Log Stream"
          If (-Not (Get-CWLLogStream -LogGroupName $logGroupName -LogStreamName $LogStreamName)) {
              Write-Verbose "Creating new Log Stream in existing Log Group : $logStreamName"
              New-CWLLogStream -LogGroupName $logGroupName -LogStreamName $logStreamName
          }

          $logEntry = New-Object -TypeName 'Amazon.CloudWatchLogs.Model.InputLogEvent'
          $logEntry.Message = $LogString
          $logEntry.Timestamp = (Get-Date).ToUniversalTime()
          #Get the next sequence token
          Write-Verbose "Checking for sequence token"
          $SequenceToken = (Get-CWLLogStream -LogGroupName $logGroupName -LogStreamNamePrefix $logStreamName).UploadSequenceToken
          if ($SequenceToken) {
              $splat = @{
                  LogEvent      = $logEntry
                  LogGroupName  = $logGroupName
                  LogStreamName = $logStreamName
                  SequenceToken = $SequenceToken
              }
              Write-Verbose "Writing new log entry to existing Log Stream"
              Write-CWLLogEvent @splat
          }
          else {
              $splat = @{
                  LogEvent      = $logEntry
                  LogGroupName  = $logGroupName
                  LogStreamName = $logStreamName
              }
              Write-Verbose "Writing new log entry to newly created Log Stream"
              Write-CWLLogEvent @splat
          }
      }
      catch {
          Write-Verbose $_.Exception.Message
      }
  }
}