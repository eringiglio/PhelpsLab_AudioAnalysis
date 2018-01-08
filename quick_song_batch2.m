function[output] = quick_song_stats_batch(xl_file)

[r,song_list] = xlsread(xl_file);

num_songs=length(song_list);

%Let's just get all the summary stats from everything...
output = [];

for i=1:num_songs
    % Extract specified song from file
    file_name = char(song_list(i,:))
    song = read_songs(file_name);

    %Now we'll want to pass this to quick_song_stats...
    summary_table = quick_song_stats(song);
    output = [output; summary_table];
    %[note_starts,note_ends,note_durs,INI] = msr_note_times(song, samp_freq);
    %msr_notes_table(i,:) = [note_starts,note_ends,note_durs,INI];
end