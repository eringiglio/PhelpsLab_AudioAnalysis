function[song_filter] = test(song_list,list_number)

filename = char(song_list(list_number));
song = read_songs(filename);
song_filter = BUTTfil(song);
view_modified_songs(song_filter);
