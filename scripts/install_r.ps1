param (
  [string]$version = "4.0.0"
)

if (![bool](Get-Command Rscript -ErrorAction SilentlyContinue)) {
  choco install R.Project --version=$version
}

$rPath="$env:SystemDrive\Program Files\R\R-$version\bin"
$env:PATH="$rPath;$env:PATH"
Write-Host "##vso[task.prependpath]$rPath"
