install.packages("lm.beta")
library(lm.beta)

#simple regression
mod <- lm(spotify_popularity ~ danceability + energy + speechiness + acousticness + instrumentalness + liveness, data = data)
summary(mod)

#with standardized values
mod_with_std_coeffs <- lm.beta(mod)
summary(mod_with_std_coeffs)

#Principal component analysis 

# Select numeric columns for PCA
numeric_data <- data %>%
  select(danceability, energy, speechiness, acousticness, instrumentalness, liveness)

standardized_data <- scale(numeric_data)
pca_result <- prcomp(standardized_data, center = TRUE, scale. = TRUE)

pca_result$sdev^2
prop_var <- pca_result$sdev^2 / sum(pca_result$sdev^2)
prop_var
pca_components <- pca_result$x

# Scree plot
plot(1:length(prop_var), prop_var, type = "b", xlab = "Principal Component", ylab = "Proportion of Variance Explained")

