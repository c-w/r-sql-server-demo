library(odbc)
con <- dbConnect(odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Database = "NYCTaxi_Sample",
                 Server = "$CHANGEME_insert_ip_of_sql_server_vm_here",
                 UID = "$CHANGEME_insert_sql_server_vm_username_here",
                 PWD = "$CHANGEME_insert_sql_server_vm_password_here",
                 Port = 1433)
query <- dbSendQuery(con, "select model from dbo.nyc_taxi_models where name='newmodel'")
result <- dbFetch(query, n=1)
model <- readRDS(gzcon(rawConnection(result[1,1][[1]])))
print(predict(model, head(data)))
