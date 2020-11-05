[CmdletBinding(
    SupportsShouldProcess=$true,
    ConfirmImpact="High")]
  PARAM(
    [Parameter(Mandatory=$true,
               Position=0)]
    [string]$ModuleName = "AWSQuickStart"
  )

  ## Get project root directory
  $ProjectRoot = (Get-Item $MyInvocation.MyCommand.Path ).Parent.Parent.FullName
  $BuildDirectory = Join-Path $ProjectRoot  -ChildPath "build"
  ## Setup build directory if not created. The build directory will hold
  if(Test-Path -PathType Container  -Path $BuildDirectory -EA SilentlyContinue){
    mkdir $BuildDirectory -Force
  }
  ## Setup the Module Directory for easy of deploying module
  $ModuleDirectory = Join-Path $BuildDirectory -ChildPath $ModuleName
  if(Test-Path -PathType Container -Path $ModuleDirectory -ErrorAction SilentlyContinue){
    mkdir $ModuleDirectory -Force
  }

  ## Set the path for the output of the build file and remove old builds
  $Module = Join-Path $ModuleDirectory -ChildPath $ModuleName
  if(test-path $Module -EA SilentlyContinue){
    remove-item -Path $Module -Force
  }

  ## build by zipping into distr directory
  $Source = "$PSScriptRoot\src\$ModuleName"
  $Destination = Join-Path -Path $BuildDirectory -ChildPath $ModuleName.zip
  if(Test-path $Destination) {Remove-item $Destination}
  Add-Type -assembly "system.io.compression.filesystem"
  [io.compression.zipfile]::CreateFromDirectory($Source, $Destination)
