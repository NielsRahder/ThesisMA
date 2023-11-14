# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tseries)
library(forecast)
library(lmtest)
library(sandwich)
library(MASS)
library(AER)

# Filter the synced_songs for relative_weeks from -4 to 4
filtered_data <- subset(synced_songs, relative_weeks >= -8 & relative_weeks <= 8)

# Calculate the mean of n_playlist_inclusion_log for each relative_week
mean_data <- filtered_data %>%
  group_by(relative_weeks) %>%
  summarize(mean_n_playlist_inclusion = mean(n_playlist_inclusion, na.rm = TRUE))

# plot
ggplot(mean_data, aes(x = relative_weeks, y = mean_n_playlist_inclusion)) +
  geom_line() +
  labs(title = "Mean playlist inclusion Over Time (Relative to Sync)",
       x = "Relative Weeks (-4 to +4)",
       y = "Mean playlist inclusion") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 


synced_songs <- synced_songs %>%
  filter(relative_weeks >= -4 & relative_weeks <= 4) %>%
  mutate(
    Time = as.numeric(relative_weeks), 
    Post = as.numeric(relative_weeks >= 0),
    Time_After_Sync = ifelse(Post == 1, Time, 0) 
  )

# ITSA model
itsa_model <- lm(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code), data = synced_songs)
summary(itsa_model)

#perform tests
acf(itsa_model$residuals, main="ACF of Residuals")
pacf(itsa_model$residuals, main="PACF of Residuals")

dwtest_result <- dwtest(formula = itsa_model) 
print(dwtest_result)

Box.test(itsa_model$residuals, type="Ljung-Box")

#the outputs show autocorrelation 
dwtest_result <- dwtest(itsa_model)
print(dwtest_result)

# Compute Newey-West standard errors & apply them
nw_se <- NeweyWest(itsa_model)
coeftest(itsa_model, vcov = nw_se)

### add autolags 
synced_songs$lagged_playlist_inclusion <- lag(synced_songs$n_playlist_inclusion, n = 1)

# Fit the modified ITSA model with lagged variable
itsa_model_lagged <- lm(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code) + lagged_playlist_inclusion, data = synced_songs)
summary(itsa_model_lagged)

##check for over-dispersion 
poisson_model <- glm(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code), 
                     data = synced_songs, family = poisson)


dispersion_statistic <- sum(residuals(poisson_model, type = "deviance")^2) / poisson_model$df.residual
print(dispersion_statistic)

quasi_poisson_model <- glm(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code), 
                           data = synced_songs, family = quasipoisson)
summary(quasi_poisson_model)

###create a negative Binomial model with 2 lagged time variables 
synced_songs$lagged_playlist_inclusion_1 = lag(synced_songs$n_playlist_inclusion, 1)  
synced_songs$lagged_playlist_inclusion_2 = lag(synced_songs$n_playlist_inclusion, 2)  

# Remove NA values that result from lagging
synced_songs <- na.omit(synced_songs)

#fit the model 
nb_model_ts <- glm.nb(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code) +
                        lagged_playlist_inclusion_1 + lagged_playlist_inclusion_2, 
                      data = synced_songs)

summary(nb_model_ts)

#plot model
plot(residuals(nb_model_ts))
plot(residuals(nb_model_ts))

AIC(nb_model_ts)
BIC(nb_model_ts)

#copare Poisson to Negative Binomial
poisson_model <- glm(n_playlist_inclusion ~ Time + Post + Time_After_Sync + as.factor(genre_code), 
                     data = synced_songs, family = poisson)
AIC(poisson_model, nb_model_ts)
BIC(poisson_model, nb_model_ts)


# mean and variance of the playlist inclusions
mean_inclusions <- mean(synced_songs$n_playlist_inclusion)
variance_inclusions <- var(synced_songs$n_playlist_inclusion)

# Calculate the percentage of songs with inclusions between 0 and 5
percentage_in_range <- with(synced_songs, sum(n_playlist_inclusion >= 0 & n_playlist_inclusion <= 5) / length(n_playlist_inclusion) * 100)

mean_inclusions
variance_inclusions

percentage_in_range








