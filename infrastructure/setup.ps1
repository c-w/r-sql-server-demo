#!/usr/bin/env pwsh

param (
  [Parameter(Mandatory=$true)][string]$masterKey,
  [Parameter(Mandatory=$true)][string]$password,
  [Parameter(Mandatory=$true)][string]$user,
  [Parameter(Mandatory=$true)][string]$subscriptionId,
  [Parameter(Mandatory=$true)][string]$name,
  [string]$location = 'EastUS',
  [string]$modelsContainerName = 'models',
  [string]$backupContainerName = 'backup',
  [string]$sasPolicyName = 'sqlserver',
  [string]$sasStart = '2020-01-01',
  [string]$sasExpiry = '2222-01-01',
  [int]$numRowsTrain = 1000000,
  [int]$numRowsTest = 50000,
  [int]$randomSeed = 1234
)

$backupUrl = 'https://sqlmldoccontent.blob.core.windows.net/sqlml/NYCTaxi_Sample.bak'
$database = 'NYCTaxi_Sample'
$here = Split-Path -parent $PSCommandPath

Push-Location "$here"

terraform init

terraform apply `
  -var subscription_id=$subscriptionId `
  -var location=$location `
  -var name=$name `
  -var user=$user `
  -var password=$password `
  -auto-approve

$storageAccount = terraform output -no-color storage_account_name
$storageKey = terraform output -no-color storage_account_key
$serverInstance = terraform output -no-color server_fqdn

Pop-Location

az storage container create `
  --name $backupContainerName `
  --account-name $storageAccount `
  --account-key $storageKey

az storage container create `
  --name $modelsContainerName `
  --account-name $storageAccount `
  --account-key $storageKey

az storage container policy create `
  --container-name $backupContainerName `
  --name $sasPolicyName `
  --start $sasStart `
  --expiry $sasExpiry `
  --permissions 'dlrw' `
  --account-name $storageAccount `
  --account-key $storageKey

az storage container policy create `
  --container-name $modelsContainerName `
  --name $sasPolicyName `
  --start $sasStart `
  --expiry $sasExpiry `
  --permissions 'dlrw' `
  --account-name $storageAccount `
  --account-key $storageKey

$backupSAS = az storage container generate-sas `
  --name $backupContainerName `
  --policy-name $sasPolicyName `
  --output 'tsv' `
  --account-name $storageAccount `
  --account-key $storageKey

$modelSAS = az storage container generate-sas `
  --name $modelsContainerName `
  --policy-name $sasPolicyName `
  --output 'tsv' `
  --account-name $storageAccount `
  --account-key $storageKey

az storage blob copy start `
  --source-uri $backupUrl `
  --destination-container $backupContainerName `
  --destination-blob "$database.bak" `
  --account-name $storageAccount `
  --account-key $storageKey

while (
  az storage blob show `
    --container $backupContainerName `
    --name "$database.bak" `
    --query 'properties.copy.status' `
    --output 'tsv' `
    --account-name $storageAccount `
    --account-key $storageKey | `
  Select-String `
    -NotMatch `
    -Quiet `
    'success'
) {
  Start-Sleep -Seconds 5
}

function LoadSqlTemplate {
  # Invoke-Sqlcmd balks on variables where the value contains an equal sign
  # so this function injects variables directly into a SQL template so that
  # we can pass the fully resolved query to Invoke-Sqlcmd
  param(
    [string]$inputFile,
    [hashtable]$variable
  )

  $sql = Get-Content $inputFile

  foreach ($kv in $variable.GetEnumerator()) {
    $sql = $sql.Replace('$(' + $kv.Name + ')', $kv.Value)
  }

  return $sql -Join "`r`n"
}

Invoke-Sqlcmd `
  -Query $(
    LoadSqlTemplate `
      -InputFile "$here/setup_server.sql" `
      -Variable @{
        StorageAccount=$storageAccount;
        BackupContainerName=$backupContainerName;
        BackupSAS=$backupSAS;
        Database=$database;
      } `
  ) `
  -Password $password `
  -ServerInstance $serverInstance `
  -User $user

Invoke-Sqlcmd `
  -Query $(
    LoadSqlTemplate `
      -InputFile "$here/setup_database.sql" `
      -Variable @{
        MasterKey=$masterKey;
        StorageAccount=$storageAccount;
        ModelSAS=$modelSAS;
      } `
  ) `
  -Password $password `
  -ServerInstance $serverInstance `
  -User $user `
  -Database $database

Invoke-Sqlcmd `
  -InputFile "$here/setup_predict.sql" `
  -Password $password `
  -ServerInstance $serverInstance `
  -User $user `
  -Database $database

Set-Content `
  -Path "$here/../secrets.env" `
  -Value (
    "SQLSERVER_STORAGE_ACCOUNT_NAME=$storageAccount",
    "SQLSERVER_STORAGE_ACCOUNT_KEY=$storageKey",
    "SQLSERVER_STORAGE_CONTAINER=$modelsContainerName",
    "SQLSERVER_INSTANCE=$serverInstance",
    "SQLSERVER_USERNAME=$user",
    "SQLSERVER_PASSWORD=$password",
    "SQLSERVER_DATABASE=$database",
    "NUM_ROWS_TRAIN=$numRowsTrain",
    "NUM_ROWS_TEST=$numRowsTest",
    "RANDOM_SEED=$randomSeed"
  )
