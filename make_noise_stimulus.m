function[finished_stimulus] = make_stimulus_recording(file_name1, file_name2, file_name3, name_of_file, samp_freq_output, samp_freq_input)

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
if nargin <6
    samp_freq_input = 195312.5;
end
 
if nargin <5
    samp_freq_output = 97656.25;
end

%Next, we need to read all three songs:
song1 = read_songs(file_name1);
song2 = read_songs(file_name2);
song3 = read_songs(file_name3);

%Okay, we've outsourced finding the songs, trimming them, and normalizing
%the peak amplitude to 1 to another program....
trimmed_song1 = trim_songs(song1);          %note I may need to wind up normalizing the peak amplitude later. we shall see what the effect of changing the sampling is. 
trimmed_song2 = trim_songs(song2);
trimmed_song3 = trim_songs(song3);

%Right. Now to fix the sampling rate on all the songs...
downsampled_song1 = downsample(trimmed_song1,samp_freq_output,samp_freq_input);
downsampled_song2 = downsample(trimmed_song2,samp_freq_output,samp_freq_input);
downsampled_song3 = downsample(trimmed_song3,samp_freq_output,samp_freq_input);

%Let's turn our song into noise...
noise1 = make_mouse_noise(downsampled_song1,'song',samp_freq_output);
noise2 = make_mouse_noise(downsampled_song2,'song',samp_freq_output);
noise3 = make_mouse_noise(downsampled_song3,'song',samp_freq_output);

%Normalizing the peak amplitude to 1... 
final_noise1 = noise1/(max(abs(downsampled_song1)));
final_noise2 = noise2/(max(abs(downsampled_song2)));
final_noise3 = noise3/(max(abs(downsampled_song3)));

%Append the songs together....
cat_noise = cat(1,final_noise1,final_noise2);
finished_stimulus = cat(1,cat_noise,final_noise3);

%...and write the song to a new file name.
fid = fopen(name_of_file, 'w');
fwrite(fid, finished_stimulus, 'float32');
