import lyricsgenius
import csv
import wordninja
import itertool


# Your Genius API token
token = 'KVwDIglrdj1dLgMzwTeVS_hyHEoDcsrGN_RsROWLJPS-E-5NefEhfFuJlYBcXy63'
genius = lyricsgenius.Genius(token)

# Function to split a name into words and add spaces
def add_spaces_to_name(name):
    words = wordninja.split(name)
    return ' '.join(words)

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

# Function to try omitting words from the song name
def try_omitting_words(song_name, artist_name, omit_words):
    # Generate all possible combinations of omitted words
    omitted_combinations = []
    for num_omitted in range(1, len(omit_words) + 1):
        for combo in itertools.combinations(omit_words, num_omitted):
            omitted_combinations.append(combo)

    for omitted_combo in omitted_combinations:
        omitted_song_name = song_name
        for omitted_word in omitted_combo:
            omitted_song_name = omitted_song_name.replace(omitted_word, '').strip()
        lyrics = search_lyrics(omitted_song_name, artist_name)
        if lyrics is not None:
            return lyrics
    return None

# CSV file containing unique song names and artist names

csv_file = "/Users/Niels/Documents/MMMA/MA/Thesis_23/Analysis/ThesisMA/unique_artists_and_songs.csv"

# Create lists to store found lyrics and songs not found
lyrics_found = []
songs_not_found = []

# List of words to try omitting from the song name
omit_words_list = ["mixed", "remix", "edit"]  # Add more words as needed

# Read song names and artist names from the CSV file
with open(csv_file, 'r') as file:
    reader = csv.reader(file)
    next(reader)  # Skip the header row if it exists
    for row in reader:
        if len(row) >= 2:  # Ensure the row has at least 2 columns
            artist_name = row[0]  # Assuming the artist names are in the first column
            song_name = row[1]  # Assuming the song names are in the second column
        
            # Flag to track whether lyrics were found
            lyrics_found_flag = False

            # Search with the original artist and song names
            lyrics = search_lyrics(song_name, artist_name)
            
            if lyrics is not None:
                lyrics_found.append([song_name, artist_name, lyrics])
                lyrics_found_flag = True

            # If the lyrics were not found on the first attempt, try variations
            if not lyrics_found_flag:
                artist_name_with_spaces = add_spaces_to_name(artist_name)
                lyrics = search_lyrics(song_name, artist_name_with_spaces)
                
                if lyrics is not None:
                    lyrics_found.append([song_name, artist_name_with_spaces, lyrics])
                    lyrics_found_flag = True

                if not lyrics_found_flag:
                    song_name_with_spaces = add_spaces_to_name(song_name)
                    lyrics = search_lyrics(song_name_with_spaces, artist_name)
                    
                    if lyrics is not None:
                        lyrics_found.append([song_name_with_spaces, artist_name, lyrics])
                        lyrics_found_flag = True

                if not lyrics_found_flag:
                    artist_name_with_spaces = add_spaces_to_name(artist_name)
                    song_name_with_spaces = add_spaces_to_name(song_name)
                    lyrics = search_lyrics(song_name_with_spaces, artist_name_with_spaces)
                    
                    if lyrics is not None:
                        lyrics_found.append([song_name_with_spaces, artist_name_with_spaces, lyrics])
                        lyrics_found_flag = True

                # If lyrics were still not found, try omitting words
                if not lyrics_found_flag:
                    omitted_lyrics = try_omitting_words(song_name, artist_name, omit_words_list)
                    if omitted_lyrics is not None:
                        lyrics_found.append([song_name, artist_name, omitted_lyrics])
                        lyrics_found_flag = True

            # If lyrics were still not found, add to "songs_not_found" list
            if not lyrics_found_flag:
                songs_not_found.append([song_name, artist_name])

# Save the found lyrics to "lyrics.csv"
if lyrics_found:
    with open('lyrics.csv', 'w', newline='') as lyrics_file:
        writer = csv.writer(lyrics_file)
        writer.writerow(['Song Name', 'Artist Name', 'Lyrics'])
        writer.writerows(lyrics_found)

# Save the list of songs not found to "songs_not_found.csv"
if songs_not_found:
    with open('songs_not_found.csv', 'w', newline='') as not_found_file:
        writer = csv.writer(not_found_file)
        writer.writerow(['Song Name', 'Artist Name'])
        writer.writerows(songs_not_found)
