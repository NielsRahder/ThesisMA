#sentiment analysis 

#load packages 
install.packages(c("tidytext", "dplyr", "tm", "stringr", "textstem"))
library(tidytext)
library(dplyr)
library(tm)
library(stringr)
library(textstem)

#load and clean data 
data <- read.csv("../Data/ColdPlay.csv", nrow = 10)

data <- data %>%
  select(Artist, 
         Title, 
         Lyric)

#lowercase everything
data <- data %>%
  mutate(Lyric = tolower(Lyric))

#tokenization
tokenized_data <- data %>%
  unnest_tokens(output = token, input = Lyric)

#remove stopwords 
stopwords <- tibble(word = stopwords("en"))

#create dataset with own stopwords 
personal_stopwords <- tibble(
  word = 
    c('chorus', 
      'chris')
)

all_stop_words <- 
  stopwords %>%
  bind_rows(personal_stopwords)


tokenized_data <- tokenized_data[!(tokenized_data$token %in% stopwords), ]


#remove digits 
tokenized_data <- tokenized_data %>%
  # find all numbers in the data
  filter(!str_detect(token, "^[0-9]")) 

#expand contractions 

 
#remove punctuation 


#lemmatization
tokenized_data_lemma <- tokenized_data %>%
  mutate(word_lemma = lemmatize_words(token))
View(tokenized_data_lemma)


#sentiment analysis using VADER (for which you do not use the above steps)
vader_data <- vader_df(data$Lyric)

vader_data <- data.frame(Artist = data$Artist, 
                         Title = data$Title, 
                         vader_data)


View(vader_data)


