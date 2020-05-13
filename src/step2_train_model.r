data <- read.csv("data.csv")
colnames(data)[1] <- "tipped"
data["tipped"] <- as.factor(data["tipped"])
data["pickup_datetime"] <- as.Date(data["pickup_datetime"], format="%Y-%m-%d %H:%M:%S")
data["dropoff_datetime"] <- as.Date(data["dropoff_datetime"], format="%Y-%m-%d %H:%M:%S")

model <- glm(tipped ~ passenger_count + trip_distance + trip_time_in_secs + direct_distance,
             data=data,
             family=binomial(link="logit"))
saveRDS(model, file="model.rds")
