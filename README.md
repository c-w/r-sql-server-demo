# R SQL Server Demo

## One-time set up

1) [Create a SQL Server 2017 Enterprise instance](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/quickstart-sql-vm-create-portal) with R Services and SQL Server Authentication enabled.

2) [Create an Azure Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create).

3) [Install the SQL Server PowerShell module](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-ver15).

4) Set up the SQL Server instance by executing `infrastructure/setup.ps1`.

5) Set up the Azure Pipeline with the variables listed in `secrets.env`.

## Training, publishing and scoring a model

Run the pipeline linked below to:

- Fetch training and validation data from SQL Server
- Train a model and validate it locally on the Azure DevOps agent
- Archive the model binary, training and validation data to Azure Storage
- Wait for approval and then deploy the model to SQL Server and score it against production data

[![Build Status](https://dev.azure.com/dwrdev/pca-mlprep/_apis/build/status/r-sql-server-demo/train_model?branchName=master)](https://dev.azure.com/dwrdev/pca-mlprep/_build/latest?definitionId=332&branchName=master)

## Troubleshooting

### 'sp_execute_external_script' is disabled on this instance of SQL Server

Connect to the SQL Server using [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) and execute the following:

```sql
sp_configure 'external scripts enabled', 1;
RECONFIGURE WITH OVERRIDE;
```

Next, restart the VM from the Azure portal.

### Unable to communicate with the LaunchPad service

Connect to the VM via RDP (ensure to prefix the username with `LOCAL\`), open SQL Server Configuration Manager, select the `SQL Server Services` option, find the `SQL Server Launchpad` entry, right click and start the service.
