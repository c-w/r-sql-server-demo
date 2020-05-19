if (![bool](Get-Command Invoke-Sqlcmd -ErrorAction SilentlyContinue))
{
  Install-Module -Name SqlServer -Force -Verbose -Scope CurrentUser
}
