# R SQL Server Demo

## One-time set up

1) [Create a SQL Server 2017 Enterprise instance](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/quickstart-sql-vm-create-portal) with SQL Server Authentication enabled, and install [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

2) [Create an Azure Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create), two containers named "models" and "data" as well as a [shared access signature](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature) for the models container

3) Download the [NYC Taxi dataset backup file](https://docs.microsoft.com/en-us/sql/machine-learning/tutorials/demo-data-nyctaxi-in-sql), upload it to the data container and [restore the database in SSMS](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/restore-a-database-backup-using-ssms?view=sql-server-ver15)

4) Set up the SQL Server instance by executing the `infrastructure/setup_server.sql` script in SSMS, replacing `$(StorageSAS)` with the value of the shared access signature from step 2, `$(StorageAccount)` with the name of the storage account from step 2 and `$(MasterKey)` with an arbitrary password.

5) Set up the Azure Pipeline with the variables listed in `template.env` filling in the blanks using values from steps 1 and 2.

## Training, publishing and scoring a model

Run the pipeline linked below to:

- Fetch training and validation data from SQL Server
- Train a model and validate it locally on the Azure DevOps agent
- Archive the model binary, training and validation data to Azure Storage
- Wait for approval and then deploy the model to SQL Server and score it against production data

[![Build Status](https://dev.azure.com/dwrdev/pca-mlprep/_apis/build/status/r-sql-server-demo/train_model?branchName=master)](https://dev.azure.com/dwrdev/pca-mlprep/_build/latest?definitionId=332&branchName=master)
