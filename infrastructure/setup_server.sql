CREATE PROCEDURE dbo.RxPredictBatchOutput (@model varchar(250), @inquery nvarchar(max))
AS
BEGIN
DECLARE @lmodel2 varbinary(max) = (SELECT model FROM nyc_taxi_models WHERE name = @model);
EXEC sp_execute_external_script
  @language = N'R',
  @script = N'
    con <- gzcon(rawConnection(model));
    mod <- readRDS(con);
    close(con);
    print(summary(mod));
    predictions <- predict(mod, InputDataSet);
    print(head(predictions));
    OutputDataSet <- data.frame(predictions);
  ',
  @input_data_1 = @inquery,
  @params = N'@model varbinary(max)',
  @model = @lmodel2
  WITH RESULT SETS ((Score float));
END;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(MasterKey)';

CREATE DATABASE SCOPED CREDENTIAL AzureModels
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '$(StorageSAS)';

CREATE EXTERNAL DATA SOURCE AzureModels WITH (
  TYPE = BLOB_STORAGE,
  LOCATION = 'https://$(StorageAccount).blob.core.windows.net',
  CREDENTIAL = AzureModels
);
