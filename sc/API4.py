import csv
import itertools
import lyricsgenius
import pandas as pd

# Your Genius API token
token = 'KVwDIglrdj1dLgMzwTeVS_hyHEoDcsrGN_RsROWLJPS-E-5NefEhfFuJlYBcXy63'
genius = lyricsgenius.Genius(token)

# Function to search for lyrics for a given song and artist
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

# CSV file containing unique song names and artist names
df = pd.read_csv("../Data/track_characteristics.csv", nrows=30)

# Convert the DataFrame to a list of lists
data = df.values.tolist()

# The first row (header) is not included in the 'data', so if you need it:
header = df.columns.tolist()

# Create lists to store found lyrics and songs not found
lyrics_found = []
songs_not_found = []

# Read song names and artist names from the CSV file
# Skip the header row if it exists
for row in data:
    if len(row) >= 2:  # Ensure the row has at least 2 columns
        artist_name = row[9]  # Assuming the artist names are in the first column
        song_name = row[4]  # Assuming the song names are in the second column
        
            # Flag to track whether lyrics were found
        lyrics_found_flag = False

            # Search with the original artist and song names
        lyrics = search_lyrics(song_name, artist_name)
            
        if lyrics is not None:
            lyrics_found.append([song_name, artist_name, lyrics])
            lyrics_found_flag = True

            # If lyrics were still not found, add to "songs_not_found" list
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