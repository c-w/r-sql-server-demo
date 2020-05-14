SELECT
  tipped,
  fare_amount,
  passenger_count,
  trip_time_in_secs,
  trip_distance,
  format(pickup_datetime, 'yyyy-MM-dd hh:mm:ss', 'en-US') AS pickup_datetime,
  format(dropoff_datetime, 'yyyy-MM-dd hh:mm:ss', 'en-US') AS dropoff_datetime,
  dbo.fnCalculateDistance(pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude) AS direct_distance
FROM dbo.nyctaxi_sample
ORDER BY rand($(Seed))
OFFSET $(Skip) ROWS
FETCH NEXT $(Take) ROWS ONLY;

