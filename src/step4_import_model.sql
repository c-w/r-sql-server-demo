INSERT INTO dbo.nyc_taxi_models(model, name)
SELECT BulkColumn, 'newmodel' FROM OPENROWSET(
    BULK 'models/model.rds',
    DATA_SOURCE = 'AzureModels',
    SINGLE_BLOB
) AS DATA;
