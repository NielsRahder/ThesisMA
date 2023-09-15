library(dplyr)
library(ggplot2)
library(GGally)

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




