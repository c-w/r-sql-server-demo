# R SQL Server Demo

1) [Create a SQL Server 2017 Enterprise instance](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/quickstart-sql-vm-create-portal) with SQL Server Authentication enabled, and install [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

2) [Create an Azure Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create), two containers named "models" and "data" as well as a [shared access signature](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature) for the models container

3) Download the [NYC Taxi dataset backup file](https://docs.microsoft.com/en-us/sql/machine-learning/tutorials/demo-data-nyctaxi-in-sql), upload it to the data container and [restore the database in SSMS](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/restore-a-database-backup-using-ssms?view=sql-server-ver15)

4) [Run feature engineering in SSMS](https://docs.microsoft.com/en-us/sql/machine-learning/tutorials/sqldev-create-data-features-using-t-sql#generate-the-features-using-fnengineerfeatures), save the results to a CSV file called `data.csv`, add a header line with the content `tipped,fare_amount,passenger_count,trip_time_in_secs,trip_distance,pickup_datetime,dropoff_datetime,direct_distance` and move the file into the `src` folder. A sample data file is included in this repository for convenience.

5) Update the strings prefixed with `$CHANGEME_` in the src folder with connection strings and access tokens from the previous steps and run the scripts one at a time
