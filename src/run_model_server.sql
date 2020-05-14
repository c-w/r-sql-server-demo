DECLARE @query_string nvarchar(max)
SET @query_string='
SELECT
  tipped,
  fare_amount,
  passenger_count,
  trip_time_in_secs,
  trip_distance,
  pickup_datetime,
  dropoff_datetime,
  dbo.fnCalculateDistance(pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude) AS direct_distance
FROM dbo.nyctaxi_sample
ORDER BY rand($(Seed))
OFFSET $(Skip) ROWS
FETCH NEXT $(Take) ROWS ONLY
'
EXEC dbo.RxPredictBatchOutput @model = '$(ModelId)', @inquery = @query_string;
