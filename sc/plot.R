library(dplyr)
library(ggplot2)
library(GGally)
install.packages('hexbin')
library(hexbin)

data <- read.csv("~/Documents/MMMA/MA/Thesis_23/Analysis/Data/data_long_prepped.csv", nrows = 1000)

#spotify popularity distribution
ggplot(data, aes(x = spotify_popularity)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Spotify Popularity Distribution", x = "Spotify Popularity", y = "Frequency")

#Bar plot of Track Genres
ggplot(data, aes(x = track_genre)) +
  geom_bar(fill = "blue") +
  labs(title = "Track Genre Distribution", x = "Genre", y = "Count") 

#Pair Plot
ggpairs(data[, c("spotify_popularity", "danceability", "energy", "acousticness", "genre_hiphop", "genre_classical")])

#plot change in aucoustic feautures over time 
ggplot(data_unique, aes(x = year, y = danceability)) +
  geom_point(alpha = 0.3) +  # sets transparency of the points to 0.3 (1 is opaque, 0 is transparent)
  geom_smooth(method = 'loess', se = FALSE) +  # adds a smoothed line without the standard error shading
  scale_x_continuous(limits = c(1970, 2022), breaks = seq(1970, 2022, by = 5)) +  # adjusts x-axis to start from 1970 and show every 5 years
  ggtitle("Change in Danceability Over Time") +
  xlab("Year") +
  ylab("Danceability")



library(hexbin)
ggplot(data_unique, aes(x = year, y = danceability)) +
  geom_hex(bins = 50) +  # you can adjust the number of bins
  geom_smooth(method = 'loess', se = FALSE, color = "red") + 
  ggtitle("Density of Danceability Over Time") +
  xlab("Year") +
  ylab("Danceability")


ggplot(subset(data_unique, year > 1970), aes(x = year, y = danceability)) +
  geom_point(alpha = 0.5, size = 1, color = "blue") +  # scatter points
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # trend line without shaded region
  ggtitle("Danceability Over Time (Post-1970)") +
  xlab("Year") +
  ylab("Danceability") +
  theme_minimal() 


#create median plots over time
agg_data <- data_unique %>%
  filter(year > 1950) %>%
  group_by(year) %>%
  summarize(median_danceability = median(danceability))

ggplot(agg_data, aes(x = leng, y = median_danceability)) +
  geom_point(color = "blue") +
  geom_smooth(aes(group=1), method = "lm", se = FALSE, color = "black") +
  ggtitle("Median danceability Over Time (Post-1970)") +
  xlab("Year") +
  ylab("Median danceability") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 

#create plots for different variables
# Load necessary libraries if not already loaded
library(ggplot2)


# Create a barplot
ggplot(data_unique, aes(x = spotify_duration_mins)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Durations",
    x = "Duration (Minutes)",
    y = "Count"
  ) +
  theme_minimal() + theme(plot.title = element_text(hjust = 0.5)) 


#barplot for danceability etc 
ggplot(data_unique, aes(x = danceability)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Danceability",
    x = "Danceability",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

ggplot(data_unique, aes(x = acousticness)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Acousticness",
    x = "Acousticness",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

ggplot(data_unique, aes(x = speechiness)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Speechiness",
    x = "Speechiness",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

ggplot(data_unique, aes(x = energy)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Energy",
    x = "Energy",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

ggplot(data_unique, aes(x = instrumentalness)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Instrumentalness",
    x = "Instrumentalness",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

ggplot(data_unique, aes(x = liveness)) +
  geom_bar(fill = "blue", color = "blue")  + 
  labs(
    title = "Song Liveness",
    x = "Liveness",
    y = "Count"
  ) +
  theme_minimal() +  theme(plot.title = element_text(hjust = 0.5)) 

