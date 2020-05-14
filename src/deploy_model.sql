INSERT INTO dbo.nyc_taxi_models(model, name)
SELECT BulkColumn, '$(ModelId)'
FROM OPENROWSET(
  BULK '$(Container)/$(ModelId)',
  DATA_SOURCE = 'AzureModels',
  SINGLE_BLOB
) AS DATA;
