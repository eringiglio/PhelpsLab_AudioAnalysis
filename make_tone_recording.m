function[finished_tone_stimulus] = make_tone_recording(file_name1, file_name2, file_name3, name_of_file, samp_freq)

% This program is intended to take the same song recordings used in 
% make_stimulus_recording and create a paired noise stimulus. However,
% for whatever reason make_mouse_noise doesn't play nicely with the
% finished stimuli, so we're going to make a separate program to set up
% the noise stimulus. 

%List of subroutines that you must have to run this program:
    %read_songs
    %downsample
    %trim_songs
    %write_calls

%First, we need to define a default sampling rate of our inputted songs and
%the outputted songs. Since we're writing this to make RX8 stimuli from RX6 
%recordings:

if nargin <5
    samp_freq = 195312.5;
end

%Next, we need to read all three songs:
song1 = read_songs(file_name1);
song2 = read_songs(file_name2);
song3 = read_songs(file_name3);

%Next, we need to BUTTfil (lol) all three songs:
song1 = BUTTfil(song1);
song2 = BUTTfil(song2);
song3 = BUTTfil(song3);

% Okay, we've outsourced finding the songs, trimming them, and normalizing
% the peak amplitude to 1 to another program....
trimmed_song1 = trim_songs(song1); % note I may need to wind up normalizing the peak amplitude later. we shall see what the effect of changing the sampling is. 
trimmed_song2 = trim_songs(song2);
trimmed_song3 = trim_songs(song3);

% Right. Now to fix the sampling rate on all the songs...
% downsampled_song1 = downsample(trimmed_song1,samp_freq_output,samp_freq_input);
% downsampled_song2 = downsample(trimmed_song2,samp_freq_output,samp_freq_input);
% downsampled_song3 = downsample(trimmed_song3,samp_freq_output,samp_freq_input);

% Let's turn our song into tone...
tone1 = make_mouse_tone(trimmed_song1,'song',195312.5);
tone2 = make_mouse_tone(trimmed_song2,'song',195312.5);
tone3 = make_mouse_tone(trimmed_song3,'song',195312.5);

% Normalizing the peak amplitude to 1... 
final_tone1 = tone1/(max(abs(trimmed_song1)));
final_tone2 = tone2/(max(abs(trimmed_song2)));
final_tone3 = tone3/(max(abs(trimmed_song3)));

% Append the songs together....
cat_tone = cat(1,final_tone1,final_tone2);
finished_tone_stimulus = cat(1,cat_tone,final_tone3);

%...and write the song to a new file name.
fid = fopen(name_of_file, 'w');
fwrite(fid, finished_tone_stimulus, 'float32');
