# Load and clean data
data <- read.csv("../Data/ColdPlay.csv", nrow = 50)

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
  word = c('chorus', 'chris', 'martin')
)

all_stop_words <- 
  stopwords_df %>%
  bind_rows(personal_stopwords)

# Filter out stopwords
tokenized_data <- tokenized_data %>%
  filter(!token %in% all_stop_words$word)

# Group by Artist and Title to reassemble the cleaned lyrics
cleaned_data <- tokenized_data %>%
  group_by(Artist, Title) %>%
  summarise(cleaned_lyric = paste(token, collapse = " "))

# Sentiment analysis using VADER on cleaned_lyric
vader_data <- vader_df(cleaned_data$cleaned_lyric)

# Combine with the original Artist and Title info
vader_data <- data.frame(Artist = cleaned_data$Artist, 
                         Title = cleaned_data$Title, 
                         vader_data)

View(vader_data)



