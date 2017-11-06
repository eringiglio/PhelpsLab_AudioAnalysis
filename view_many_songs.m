function [songs] = view_many_songs(songList,samp_freq)

%songList should be a list of the songs you wish to view as a set, formatted like this:
% >> songList = [song1, song2, song3, song4];

[r,num_songs] = size(songList);

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

%Want to see all songs in a plot line, ideally at a size I can distinguish them. Also want to see oscillograms and spectrograms grouped. soooo....

figure(1)
for i=1:num_songs
	thisSong = songList(:,i);
    if num_songs == 1
        specgram(songs, 512, samp_freq);
    elseif num_songs <= 4
        subplot (4, 1, i), specgram(thisSong, 512, samp_freq);
    elseif num_songs <= 6
        subplot (6, 1, i), specgram(thisSong, 512, samp_freq);
    elseif num_songs <= 8
        subplot (4, 2, i), specgram(thisSong, 512, samp_freq);
    elseif num_songs <= 12
        subplot (6, 2, i), specgram(thisSong, 512, samp_freq);
    end
end
caxis([-100 20])

figure(2)
for i=1:num_songs
	thisSong = songList(:,i);
    if num_songs == 1
        oscillogram(songs, 512, samp_freq);
    elseif num_songs <= 4
        subplot (4, 1, i), oscillogram(thisSong, samp_freq);
    elseif num_songs <= 6
        subplot (6, 1, i), oscillogram(thisSong, samp_freq);
    elseif num_songs <= 8
        subplot (4, 2, i), oscillogram(thisSong, samp_freq);
    elseif num_songs <= 12
        subplot (6, 2, i), oscillogram(thisSong, samp_freq);
    end
end