args <- commandArgs(trailingOnly = TRUE)
model_file <- args[1]
data_file <- args[2]

model <- readRDS(model_file)
data <- read.csv(data_file)

print(predict(model, data))
