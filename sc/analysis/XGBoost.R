library(tidyverse)
library(caret)
library(readr)
library(xgboost)
library(Metrics)

# Open the dataset 
data_long_prepped <- read.csv("../../Data/data_long_prepped.csv", nrows = 5000)

# Select the variables
data_model <- data_long_prepped[, c("danceability", "energy", "speechiness", "acousticness", "instrumentalness", "liveness", "n_playlist_inclusion")]

# Ensure all columns are numeric
data_model <- data.frame(lapply(data_model, as.numeric), stringsAsFactors = FALSE)

features <- as.matrix(data_model[, -ncol(data_model)]) # Exclude target column
label <- data_model$n_playlist_inclusion

# Define the control method for train with cross-validation
train_control <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE,
  returnData = FALSE,
  savePredictions = "final",
  summaryFunction = defaultSummary
)

# Set up the parameter grid for tuning
xgb_grid <- expand.grid(
  nrounds = seq(50, 150, by = 50),
  max_depth = c(3, 6),
  eta = c(0.01, 0.05),
  gamma = c(0, 0.1),
  colsample_bytree = c(0.5, 0.7),
  min_child_weight = c(1, 2),
  subsample = c(0.5, 0.7)
)

# Run the model tuning
set.seed(123) # For reproducibility
xgb_tuned_model <- train(
  n_playlist_inclusion ~ .,
  data = data_model,
  method = "xgbTree",
  trControl = train_control,
  tuneGrid = xgb_grid,
  metric = "RMSE"
)

# Retrieve the best parameters
best_params <- xgb_tuned_model$bestTune

set.seed(123)

# Retrain with the best parameters
xgb_final_model <- train(
  n_playlist_inclusion ~ .,
  data = data_model,
  method = "xgbTree",
  trControl = train_control,
  tuneGrid = best_params, # Here we use the best parameters directly
  metric = "RMSE"
)

# Output the final model results
print(xgb_final_model)
