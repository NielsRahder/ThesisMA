import csv
import lyricsgenius
import pandas as pd
import time

# Record the start time
start_time = time.time()

token = "bBOHnPYLSJkn-q3hibku1NkZmlS7X1xq3s8odqSoIgSuCjb2IiLCg4LoTrc0KHKED0h0mh6JKNFE4DdWwn1MuQ"
genius = lyricsgenius.Genius(token, verbose=True)

def search_lyrics(song_name, artist_name):
    try:
        search_query = f"{song_name} {artist_name}"
        song = genius.search_song(search_query)
        if song is not None:
            return song.lyrics
        else:
            return None
    except Exception as e:
        return None

df = pd.read_csv("../Data/track_characteristics.csv", nrows=10)

print(df.iloc[:, 8].head())
data = df.values.tolist()
header = df.columns.tolist()

lyrics_found = []
songs_not_found = []

for row in data:
    if len(row) >= 2:  
        artist_name = row[9]  
        song_name = row[4]  
        
        lyrics_found_flag = False

        lyrics = search_lyrics(song_name, artist_name)
            
        if lyrics is not None:
            lyrics_found.append([song_name, artist_name, lyrics])
            lyrics_found_flag = True

        if not lyrics_found_flag:
            songs_not_found.append([song_name, artist_name])

# Save the found lyrics to "lyrics.csv"
if lyrics_found:
    with open('../Data/lyrics.csv', 'w', newline='') as lyrics_file:
        writer = csv.writer(lyrics_file)
        writer.writerow(['Song Name', 'Artist Name', 'Lyrics'])
        writer.writerows(lyrics_found)

# Save the list of songs not found to "songs_not_found.csv"
if songs_not_found:
    with open('../Data/songs_not_found.csv', 'w', newline='') as not_found_file:
        writer = csv.writer(not_found_file)
        writer.writerow(['Song Name', 'Artist Name'])
        writer.writerows(songs_not_found)

print(len(lyrics_found))
end_time = time.time()

# Calculate the difference
elapsed_time = end_time - start_time
print(f"The script took {elapsed_time} seconds to complete.")
