require './input_functions'

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

def pause(seconds = 2)
  sleep(seconds)
end

def safe_int(str)
  Integer(str)
rescue
  nil
end

# Try to read an integer line; returns [int_or_nil, raw_line]
def read_int_line(io)
  raw = io.gets
  return [nil, nil] if raw.nil?
  raw = raw.chomp
  [safe_int(raw), raw]
end

def read_line(io)
  line = io.gets
  return nil if line.nil?
  line.chomp
end

def read_albums_from_file(filename)
  albums = []

  begin
    file = File.new(filename, 'r')
  rescue
    puts "Could not open '#{filename}'."
    return albums
  end

  first = read_line(file)
  if first.nil?
    puts "Empty file."
    file.close
    return albums
  end

  album_count = safe_int(first)
  if album_count.nil?
    puts "Invalid file header (expected number of albums)."
    file.close
    return albums
  end

  i = 0
  while i < album_count
    artist = read_line(file)
    title  = read_line(file)
    rec_type = read_line(file)
    break if artist.nil? || title.nil? || rec_type.nil?

    maybe_int, raw = read_int_line(file)
    if maybe_int.nil?
      puts "Unexpected end of file while reading album #{i+1}."
      break
    end

    genre_id = nil
    track_count = nil

    if !file.eof?
      pos = file.pos
      next_int, _ = read_int_line(file)
      if next_int.nil?
        track_count = maybe_int
      else
        genre_id = maybe_int
        track_count = next_int
      end
      file.pos = pos if genre_id.nil?
    else
      track_count = maybe_int
    end

    if track_count.nil? || track_count < 0
      puts "Invalid track count for album #{i+1}."
      break
    end

    tracks = []
    t = 0
    while t < track_count
      name = read_line(file)
      location = read_line(file)
      duration = read_line(file)
      if name.nil? || location.nil? || duration.nil?
        puts "Unexpected end of file while reading tracks for album #{i+1}."
        break
      end
      tracks << { name: name, location: location, duration: duration }
      t += 1
    end

    albums << {
      artist: artist,
      title: title,
      recording_type: rec_type,
      genre_id: genre_id,
      tracks: tracks
    }

    i += 1
  end

  file.close
  albums
end

def print_single_album(album, index_for_user)
  puts "##{index_for_user}  #{album[:title]} — #{album[:artist]}"
  puts "   Record Type: #{album[:recording_type]}"
  if !album[:genre_id].nil?
    g = album[:genre_id]
    gname = (g >= 0 && g < GENRE_NAMES.length) ? GENRE_NAMES[g] : "Genre #{g}"
    puts "   Genre: #{gname}"
  end
  puts "   Tracks: #{album[:tracks].length}"
end

def display_all_albums(albums)
  if albums.length == 0
    puts "No albums loaded."
    return
  end
  i = 0
  while i < albums.length
    print_single_album(albums[i], i+1)
    i += 1
  end
end

def list_genres_available(albums)
  present = {}
  i = 0
  while i < albums.length
    gid = albums[i][:genre_id]
    present[gid] = true unless gid.nil?
    i += 1
  end
  if present.empty?
    puts "No genre information available in this file."
    return []
  end
  keys = present.keys.sort
  j = 0
  while j < keys.length
    gid = keys[j]
    name = (gid >= 0 && gid < GENRE_NAMES.length) ? GENRE_NAMES[gid] : "Genre #{gid}"
    puts "#{gid} - #{name}"
    j += 1
  end
  keys
end

def display_albums_by_genre(albums, genre_id)
  shown = 0
  i = 0
  while i < albums.length
    a = albums[i]
    if a[:genre_id] == genre_id
      print_single_album(a, i+1)
      shown += 1
    end
    i += 1
  end
  puts "(none found for that genre)" if shown == 0
end

def list_tracks(album)
  i = 0
  while i < album[:tracks].length
    t = album[:tracks][i]
    puts "#{i+1}. #{t[:name]} (#{t[:duration]})"
    i += 1
  end
end

# -------- Menu actions --------
def menu_read_in_albums
  fname = read_string("Enter albums filename: ")
  albums = read_albums_from_file(fname)
  if albums.length > 0
    puts "Loaded #{albums.length} album(s)."
  else
    puts "No albums loaded."
  end
  albums
end

def menu_display_albums(albums)
  if albums.length == 0
    puts "No albums loaded yet. Use option 1 first."
    return
  end

  puts "1. Display ALL albums"
  puts "2. Display albums BY GENRE"
  sub = read_integer_in_range("Choose option: ", 1, 2)

  if sub == 1
    display_all_albums(albums)
  else
    keys = list_genres_available(albums)
    return if keys.empty?
    gid = read_integer("Enter a genre id from the list: ").to_i
    display_albums_by_genre(albums, gid)
  end
end

def menu_select_album_to_play(albums)
  if albums.length == 0
    puts "No albums loaded yet. Use option 1 first."
    return
  end

  # show brief index
  i = 0
  while i < albums.length
    puts "#{i+1}. #{albums[i][:title]} — #{albums[i][:artist]}"
    i += 1
  end

  anum = read_integer_in_range("Enter album number: ", 1, albums.length)
  album = albums[anum - 1]

  # list tracks
  if album[:tracks].length == 0
    puts "This album has no tracks."
    return
  end
  list_tracks(album)
  tnum = read_integer_in_range("Enter track number: ", 1, album[:tracks].length)
  track = album[:tracks][tnum - 1]

  puts "Playing track \"#{track[:name]}\" from album \"#{album[:title]}\"..."
  pause(2)
end

def main()
  albums = []
  choice = 0

  while choice != 5
    
    puts "Text Music Player"
    puts "1. Read in Albums"
    puts "2. Display Albums"
    puts "3. Select an Album to play"
    puts "5. Exit the application"
    choice = read_integer_in_range("Choose an option: ", 1, 5)

    if choice == 1
      albums = menu_read_in_albums
    elsif choice == 2
      menu_display_albums(albums)
    elsif choice == 3
      menu_select_album_to_play(albums)
    elsif choice == 5
      puts "Goodbye!"
    else
      puts "Invalid option."
    end
  end
end

main()
