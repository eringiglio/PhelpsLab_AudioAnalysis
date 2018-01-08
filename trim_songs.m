function[trimmed_song] = trim_songs(song, samp_freq)

%Decided it was easier to run the thing where the songs were each trimmed,
%had their amplitudes corrected, and put up to the right length in the
%buffer in a separate program rather than in make_stimulus_recording. So
%we'll do this instead. Assumes you've already "read" the song in, because
%make_stimulus_recording will call this. 

%Specifying the sampling frequency...
if nargin <2
    samp_freq = 195312.5;
end
%Useful later on to know the full length of the song in samples...
[s,c] = size(song);

%You want to trim the songs, right? So one easy way to do that might
%be to take the start of the first note and the end of the last note, and
%anything between those things is the trimmed song. So for that, we need to
%measure those things: 
[note_starts, note_ends, note_durs, INI] = msr_note_times(song);

%Specifying the onset and offset of the song itself
onset_song = note_starts(1,1);
offset_song = note_ends(end,end);

%Converting that onset and offset back to samples rather than msec; also,
%pulling a bunch of samples ahead so you catch the whole song with a little
%wiggle room
onset_song = round((samp_freq*onset_song/1000));
if onset_song <1
    onset_song = 1;
end
offset_song = round((samp_freq*offset_song/1000));

%Okay, and NOW we want to make sure all the songs conform to a fixed
%length. For us, that's going to be 3000000 units, so let's have a look at
%that in our song....

[r,c] = size(song(onset_song:offset_song));
if r < 3000000
    buffer = round((3000000-r) / 2);
    onset_song = round(onset_song - buffer);
    offset_song = round(offset_song + buffer);
    if onset_song < 0 % what to do if the onset of the song is really close to the beginning of the recording
        difference = 1 - onset_song;
        onset_song = 1;
        offset_song = offset_song + difference;
    end
    if offset_song > s % what to do if the offset of the song is really close to the end of the recording
        difference = offset_song - s;
        offset_song = s;
        onset_song = onset_song - difference;
    end
end

%Now we want to trim the file to the length of the song itself...
trimmed_song = song(onset_song:offset_song);

%Okay, and NOW we want to make sure all the songs conform to a fixed
%length. For us, that's going to be 3000000 units, so let's have a look at
%that in our song....
[r,c] = size(trimmed_song);

% If the recording is longer than 3000000, pull anything left off the end
if r > 3000000
    trimmed_song = trimmed_song(1:3000000);
end


