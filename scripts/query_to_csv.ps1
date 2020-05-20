[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification='Pass-through')]
param (
  [Parameter(Mandatory=$true)][string]$inputFile,
  [Parameter(Mandatory=$true)][string]$outputFile,
  [Parameter(Mandatory=$true)][string]$password,
  [Parameter(Mandatory=$true)][string]$serverInstance,
  [Parameter(Mandatory=$true)][string]$user,
  [Parameter(Mandatory=$true)][string]$database,
  [string[]]$variable = @()
)

Invoke-Sqlcmd `
  -InputFile $inputFile `
  -ServerInstance $serverInstance `
  -User $user `
  -Password $password `
  -Database $database `
  -Variable $variable | `
Export-CSV `
  -NoTypeInformation `
  -Path $outputFile
