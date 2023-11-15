library(e1071)
library(caret)

set.seed(123)

data_SVM$affected <- as.factor(data_SVM$affected)

# Split the dataset into affected and not affected
affected_subset <- subset(data_SVM, affected == 1)
not_affected_subset <- subset(data_SVM, affected == 0)

# create affected and not affected datasets (balancing)
sample_size <- min(nrow(affected_subset), nrow(not_affected_subset))
affected_sample <- affected_subset[sample(1:nrow(affected_subset), sample_size), ]
not_affected_sample <- not_affected_subset[sample(1:nrow(not_affected_subset), sample_size), ]

balanced_subset_SVM <- rbind(affected_sample, not_affected_sample)
subset_SVM_balanced <- balanced_subset_SVM[sample(1:nrow(balanced_subset_SVM)), ]

# 70% training & 30% testing
train_sample_size <- floor(0.7 * nrow(subset_SVM_balanced))
train_indices <- sample(1:nrow(subset_SVM_balanced), train_sample_size)

test_indices <- setdiff(1:nrow(subset_SVM_balanced), train_indices)

#select features 
feature_cols <- c("danceability", "energy", 
                  "speechiness", "acousticness", 
                  "instrumentalness", "liveness", 
                  "major_label_dummy", "sumfollowers_earliest", 
                  "song_age_yr", "genre_code", 
                  "spotify_popularity")

subset_SVM_balanced[feature_cols] <- scale(subset_SVM_balanced[, feature_cols])

# Create the training and testing subset
train_subset_data <- subset_SVM_balanced[train_indices, ]
test_subset_data <- subset_SVM_balanced[test_indices, ]

train_features <- train_subset_data[, feature_cols]
test_features <- test_subset_data[, feature_cols]
train_target <- train_subset_data$affected
test_target <- test_subset_data$affected

train_data <- cbind(train_target, train_features)

# parameters for grid search
tune.grid <- expand.grid(
  cost = c(0.1, 1, 3 ),
  gamma = c(0.01, 1, 3 )
)

#perform grid search with 3 fold 
svm.tune <- tune(
  svm, train_target ~ .,
  data = train_data,
  kernel = "radial",
  ranges = tune.grid,
  scale = FALSE,
  cross = 3
)

# select best model 
best.model <- svm.tune$best.model
print(svm.tune$best.parameters)

# Train the SVM model with the best parameters found
svm_fit <- svm(train_target ~ ., data = train_data, 
               kernel = "radial", 
               cost = svm.tune$best.parameters$cost, 
               gamma = svm.tune$best.parameters$gamma)

# Predict on the test set
predictions <- predict(svm_fit, test_features)

#create confusion matrix 
conf_matrix <- confusionMatrix(factor(predictions), factor(test_target))
print(conf_matrix)

# Extracting metrics
print(conf_matrix$byClass["Precision"])
print(conf_matrix$byClass["Recall"])
print(conf_matrix$byClass["F1"])
print(conf_matrix$byClass["Specificity"])
