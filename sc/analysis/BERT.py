from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

# Load the tokenizer and model
tokenizer = AutoTokenizer.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')
model = AutoModelForSequenceClassification.from_pretrained('nlptown/bert-base-multilingual-uncased-sentiment')

# Tokenize the input sentence
tokens = tokenizer.encode('I do not know how i feel about this', return_tensors='pt')
print(tokens)

# Pass the tokenized sentence through the model
outputs = model(tokens)
predictions = torch.nn.functional.softmax(outputs.logits, dim=-1)
predicted_class = torch.argmax(predictions).item() + 1

print(f"Sentiment score: {predicted_class}")
