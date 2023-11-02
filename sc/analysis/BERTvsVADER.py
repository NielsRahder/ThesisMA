import pandas as pd
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Initialize the tokenizer and model for BERT
bert_tokenizer = AutoTokenizer.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
bert_model = AutoModelForSequenceClassification.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')

# Initialize VADER sentiment intensity analyzer
vader_analyzer = SentimentIntensityAnalyzer()

# The lyric
lyric = "Smiling faces sometimes pretend to be your friend." 

# Function to get sentiment score using BERT
def get_bert_sentiment(lyric):
    tokens = bert_tokenizer.encode(lyric, return_tensors='pt', truncation=True, max_length=512)
    outputs = bert_model(tokens)
    predictions = torch.nn.functional.softmax(outputs.logits, dim=-1)
    return predictions.detach().numpy()

# Function to get sentiment score using VADER
def get_vader_sentiment(lyric):
    return vader_analyzer.polarity_scores(lyric)

# Get BERT sentiment
bert_sentiment = get_bert_sentiment(lyric)
print(f"BERT sentiment scores: {bert_sentiment}")

# Get VADER sentiment
vader_sentiment = get_vader_sentiment(lyric)
print(f"VADER sentiment scores: {vader_sentiment}")


