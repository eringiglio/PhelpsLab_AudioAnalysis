function[finished_stimulus] = make_stimulus_recording(file_name1, file_name2, file_name3, name_of_file, samp_freq_output, samp_freq_input)

% This program is intended to take inputs from separate files, paste them
% together, and resample them for the RX8. They'll need to be pre-trimmed
% and honestly this may not be easily automated, but this will serve as a
% good summary of workflow.

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

%Normalizing the peak amplitude to 1... 
final_song1 = downsampled_song1/(max(abs(downsampled_song1)));
final_song2 = downsampled_song2/(max(abs(downsampled_song2)));
final_song3 = downsampled_song3/(max(abs(downsampled_song3)));

%Append the songs together....
cat_song = cat(1,final_song1,final_song2);
finished_stimulus = cat(1,cat_song,final_song3);

%...and write the song to a new file name.
fid = fopen(name_of_file, 'w');
fwrite(fid, finished_stimulus, 'float32');
