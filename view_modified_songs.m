function [songs] = view_modified_songs(songs, samp_freq, num_songs)

[file_length,c] = size(songs);

% define default number of bins in the sample (number of songs = bins)
if nargin<3
    num_songs=1;
end

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

song_length = floor(file_length/num_songs);

%
% -------------
% Now plot songs in spectrogram form
% -------------

figure()
for i=1:num_songs
    start = (i-1)*(song_length)+1;
    finish = i*song_length;
    if num_songs == 1
        specgram(songs, 512, samp_freq);
    elseif num_songs <= 4
        subplot (4, 1, i), specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 6
        subplot (6, 1, i), specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 8
        subplot (4, 2, i), specgram(songs(start:finish), 512, samp_freq);
    elseif num_songs <= 12
        subplot (6, 2, i), specgram(songs(start:finish), 512, samp_freq);
    end
end
caxis([-100 20])

%Now plot calls in oscillogram form

%define X axis
time_between = 1/samp_freq;
%define Y axis
y = songs;

x = 0:time_between:(song_length-1)*time_between;

%length(x) == length(y);

figure()
plot(x,y)
