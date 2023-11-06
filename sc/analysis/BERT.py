import pandas as pd
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

df = pd.read_csv('../Data/ColdPlay.csv')

# Load the tokenizer and model
tokenizer = AutoTokenizer.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
model = AutoModelForSequenceClassification.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')

# Function to get sentiment score
def get_sentiment(lyric):
    # Convert non-string inputs to empty strings
    if not isinstance(lyric, str):
        lyric = ""

    # Encode the lyric text
    tokens = tokenizer.encode(lyric, return_tensors='pt', truncation=True, max_length=512)  # Truncate to handle very long lyrics
    outputs = model(tokens)
    predictions = torch.nn.functional.softmax(outputs.logits, dim=-1)
    predicted_class = torch.argmax(predictions).item() + 1
    return predicted_class

# Apply the sentiment analysis function on the 'Lyric' column
df['sentiment'] = df['Lyric'].apply(get_sentiment)

# Save the modified DataFrame to a new CSV
df.to_csv('../Data/ColdPlay_with_Sentiment.csv', index=False)

