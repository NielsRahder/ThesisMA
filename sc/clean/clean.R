library(tidyr)
library(dplyr)

data <- read.csv("~/Documents/MMMA/MA/Thesis_23/ThesisMA/Data/data_long_prepped.csv", nrows = 500)
data <- as.data.frame(data)
View(data)

# Iterate through all columns and replace empty cells with NA
data[data == ""] <- NA

#calculate the absolute change in playlist inclusion
data <- data %>%
  group_by(track_id) %>%
  mutate(
    max_inclusions = max(n_playlist_inclusion),
    min_inclusions = min(n_playlist_inclusion)
  ) %>%
  ungroup() %>%
  mutate(
    absolute_change = abs(max_inclusions - min_inclusions)
  ) %>%
  select(-max_inclusions, -min_inclusions) 

#create dataframe with unique values: 
data_unique <- data %>% 
  distinct(artist_names, name, .keep_all = TRUE)  # Make sure to replace 'artist' and 'song_title' with your actual column names

#add a year column
data_unique$release_dates <- as.Date(data_unique$release_dates, format="%Y-%m-%d") # adjust format as needed
data_unique$year <- as.numeric(format(data_unique$release_dates, "%Y"))

#calculate the mean popularity of songs
result <- data %>%
  filter(treated == "0") %>%
  summarise(mean_popularity = mean(as.numeric(spotify_popularity), na.rm = TRUE))
result

# Calculate the number of unique track IDs
unique_track_ids <- unique(data$track_id)
num_unique_track_ids <- length(unique_track_ids)
num_unique_track_ids

#calculate the average number of dates a song is in the dataset 
data$date <- as.Date(data$date)
average_dates <- data %>%
  group_by(track_id) %>%
  summarize(mean_time_in_days = mean(difftime(date, min(date), units = "days")))
print(average_dates)

average_dates$mean_time_in_days <- as.character(average_dates$mean_time_in_days)
class(average_dates$mean_time_in_days)

#check out info on songs with 0 days
zero_dates <- sum(average_dates$mean_time_in_days == "0")
print(zero_dates)
track_379268_info <- data %>%
  filter(track_id == 379268)
print(track_379268_info)

#write unique values to csv
unique_artist_names <- unique(data$artist_names)
unique_artist_names <- as.data.frame(unique_artist_names)

unique_names <- unique(data$name)
unique_names <- as.data.frame(unique_names)

nrow(unique_artist_names)
nrow(unique_names)

unique_data <- data.frame(artist_names = unique_artist_names, name = unique_names)

# Write the unique data to a CSV file
write.csv(unique_data, file = "unique_values.csv", row.names = FALSE)

# Create a new data frame with unique artist names and their songs
unique_data <- data %>%
  distinct(artist_names, name)

write.csv(unique_data, file = "../Data/unique_artists_and_songs.csv", row.names = FALSE)

lyrics <- read.csv("lyrics.csv")
not_found <- read.csv("songs_not_found.csv")
nrow(lyrics)
nrow(not_found)
nrow(unique_data)
