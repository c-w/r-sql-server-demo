if ([bool](Get-Command Rscript -ErrorAction SilentlyContinue))
{
  Exit 0
}

if ([bool](Get-Command choco -ErrorAction SilentlyContinue))
{
  $version = '3.5.3'
  choco install R.Project --version=$version
  $rPath="$env:SystemDrive\Program Files\R\R-$version\bin"
  $env:PATH="$rPath;$env:PATH"
  Write-Host "##vso[task.prependpath]$rPath"
}
elseif ([bool](Get-Command apt-get -ErrorAction SilentlyContinue))
{
  $release = lsb_release --codename --short
  $version = '35'
  sudo apt-key adv --keyserver 'keyserver.ubuntu.com' --recv-keys 'E298A3A825C0D65DFD57CBB651716619E084DAB9'
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $release-cran$version/"
  sudo apt-get update
  sudo apt-get install -y r-base
}
else
{
  Write-Error 'No idea how to install R on this platform'
  Exit 1
}
