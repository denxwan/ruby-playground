require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :title, :artist, :genre, :tracks, :recording_type
	
	def initialize (title, artist, genre, tracks, recording_type)
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
    @recording_type = recording_type
	end
end

class Track
	attr_accessor :name, :location, :duration

	def initialize (name, location, duration)
		@name = name
		@location = location
    @duration = duration
	end
end

# Reads a single track from file
def read_track(music_file)
	name = music_file.gets.chomp
	location = music_file.gets.chomp
  duration = music_file.gets.chomp
	track = Track.new(name, location, duration)
	return track
end

# Reads all tracks from file
def read_tracks(music_file)
	count = music_file.gets().to_i()
  tracks = Array.new()
	i = 0
	while i < count 
  		track = read_track(music_file)
  		tracks << track
		i += 1
	end
	return tracks
end

# Print a single track
def print_track(track)
  puts track.name
	puts track.location
end

# Print track information
def print_tracks(tracks)
	i = 0
	while i < tracks.length
    puts "==== Track number ##{i} ===="
		print_track(tracks[i])
		i += 1
	end
end

# Reads an album from file
def read_album(music_file)
  album_artist = music_file.gets.chomp
  album_title = music_file.gets.chomp
  album_recording_type = music_file.gets.chomp
  album_genre = music_file.gets.chomp.to_i
  tracks = read_tracks(music_file)
  album = Album.new(album_title, album_artist, album_genre, tracks, album_recording_type)
	return album
end

# Prints albums and all its tracks
def print_album(album)
	puts "#{album.title.to_s} by #{album.artist.to_s}"
	puts(GENRE_NAMES[album.genre])
  puts(album.recording_type.to_s)
end

# The stub code for display albums menu
def display_albums(albums)
  finished = false
  if albums.length != 0
    begin
      puts 'Display Albums Menu:'
      puts '1. Display All Albums'
      puts '2. Display Albums by Genre'
      puts '3. Return to Main Menu'
      choice = read_integer_in_range("Please enter your choice:", 1, 3)
      case choice
      when 1
        display_all_albums(albums)
      when 2
        display_albums_by_genre(albums)
      when 3
        finished = true
      else
        puts "Please select again."
      end
    end until finished
  else
    puts "No album file loaded, please read an album file first."
  end
end

# The stub code for display all albums menu
def display_all_albums(albums)
  albums_count = albums.length
  # puts ("Number of albums loaded: #{albums_count}")
  i = 0
  while i < albums_count
    puts "==== Album number ##{i}: ===="
    print_album(albums[i])
    i += 1
  end
end

# The stub code for display albums by genre menu
def display_albums_by_genre(albums)
  puts 'Genres list:'
  puts '1. Pop'
  puts '2. Classic'
  puts '3. Jazz'
  puts '4. Rock'
  choice = read_integer_in_range("Please select the genre to list albums:", 1, 4)
  case choice
  when 1
    display_selected_albums_by_genre(choice, albums)
  when 2
    display_selected_albums_by_genre(choice, albums)
  when 3
    display_selected_albums_by_genre(choice, albums)
  when 4
    display_selected_albums_by_genre(choice, albums)
  else
    puts "Please select again."
  end
end

# Function to display selected albums by genre
def display_selected_albums_by_genre(choice, albums)
  genre_found = false
  albums_count = albums.length
  i = 0
  while i < albums_count
    if albums[i].genre == choice
      puts "==== Album number ##{i}: ===="
      print_album(albums[i])
      genre_found = true
      i += 1
    else
      i += 1
    end
  end
  if genre_found == false
    puts "No albums of the selected genre has found."
  end
end

# Function to load albums to the system
def load_albums(albums)
  file_name = read_string("You selected to Load Albums. Type the file name to load the albums.")
  if (file_name != "")
    music_file = File.new(file_name, "r")
    album_count = music_file.gets.chomp.to_i
    i = 0
    while i < album_count
      albums << (read_album(music_file))
      i += 1
    end
    music_file.close()
    puts ("\'#{file_name}\' loaded successfully with #{albums.length} albums.")
  else
    puts ("Incorrect file name or the file doesn't exist. Please try again.")
  end
end

# The stub code for play albums menu
def play_album(albums)
  if albums != []
    album_number = read_integer("You selected to play an Album. Type the album number you want to play.")
    puts "You selected album number ##{album_number} - #{albums[album_number].title} by #{albums[album_number].artist} to play."
    print_tracks(albums[album_number].tracks)
    track_number = read_integer("Select the track number to play.")
    if (albums[album_number].tracks.length == 0)
      puts "There are no tracks in the selected album. Please play a different album."
    elsif ((track_number < albums[album_number].tracks.length) && (track_number >= 0) && (albums[album_number].tracks.length != 0))
      puts "Playing track #{albums[album_number].tracks[track_number].name} from album #{albums[album_number].title}..."
      sleep(3)
    else
      puts "The selected track number doesn't exist in the album. Please try again."
    end
  else 
    puts "No album file loaded, please read an album file first."
  end
end

def main()
    albums = []
    finished = false
  begin
    puts 'Main Menu:'
    puts '1. Read in Albums'
    puts '2. Display Albums'
    puts '3. Select an Album to play'
    puts '4. Exit the application'
    choice = read_integer_in_range("Please enter your choice:", 1, 4)
    case choice
    when 1
      load_albums(albums)
    when 2
      display_albums(albums)
    when 3
      play_album(albums)
    when 4
      finished = true
    else
      puts "Please select again."
    end
  end until finished
end

main()
