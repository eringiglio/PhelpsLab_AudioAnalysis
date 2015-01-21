function [songs] = view_songs(file_name, same_freq, num_songs);

fid = fopen(C:\Users\Biosci\Downloads\agTEGpilot.f32, 'r');

if fid == -1
      error('Error: check that path has been set to find appropriate file.')
end

songs = fread(fid, 'float32');
[file_length,c] = size(songs);

% define default number of bins in the sample (number of calls = bins)
if nargin<3                
    num_songs=1;
end

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

%-------------
% Now plot calls in spectrogram form
%-------------

for i=1:num_calls
    start = (i-1)*(song_length)+1;
    finish = i*song_length;
    if num_songs == 1
        specgram(songs, 512, samp_freq);
    elseif num_songs <= 4
        subplot (4, 1, i) specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 6
        subplot (6, 1, i) specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 8
        subplot (4, 2, i) specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 12
        subplot (6, 2, i) specgram(songs(start:finish), 512, samp_freq);
    end
end
