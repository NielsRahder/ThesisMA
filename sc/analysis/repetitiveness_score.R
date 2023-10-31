library(tidytext)
library(dplyr)
library(stringr)

# Load and clean data
data <- read.csv("../Data/ColdPlay.csv", nrow = 10)

data <- data %>%
  select(Artist, 
         Title, 
         Lyric)

# Lowercase everything
data <- data %>%
  mutate(Lyric = tolower(Lyric))

# Tokenization
tokenized_data <- data %>%
  unnest_tokens(output = token, input = Lyric)

# Remove stopwords
stopwords_df <- tibble(word = stopwords("en"))

# Create dataset with own stopwords
personal_stopwords <- tibble(
  word = c('chorus', 'chris')
)

all_stop_words <- 
  stopwords_df %>%
  bind_rows(personal_stopwords)

tokenized_data <- tokenized_data %>%
  filter(!token %in% all_stop_words$word)

# Function to compute compression score
CompressionScore <- function(lyric_data) {
  unique_tokens <- n_distinct(lyric_data$token)
  total_tokens <- nrow(lyric_data)
  
  return(1 - unique_tokens / total_tokens)
}

compression_scores <- tokenized_data %>%
  group_by(Artist, Title) %>%
  do(score = CompressionScore(.))

# Combine the compression scores with the original dataset
final_data <- left_join(data, compression_scores, by = c("Artist", "Title"))

View(final_data)
