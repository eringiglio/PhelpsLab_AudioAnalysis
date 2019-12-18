 function [songs] = view_many_songs(songList,fileList,samp_freq)

%songList should be a list of the songs you wish to view as a set,
%formatted as a series of cells

%fileList should be a series of cells formatted the same way, like a header for songList. 
[num_songs,~] = size(songList);

% define default sample frequency
if nargin<3
    samp_freq = 195312.5;
end

if nargin<2
    fileList = zeros(2,num_songs);
end

%Want to see all songs in a plot line, ideally at a size I can distinguish them. Also want to see oscillograms and spectrograms grouped. soooo....

figure
for i=1:num_songs
	thisSong = songList{i};
    if num_songs == 1
        specgram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
        caxis([-100 20])
    elseif num_songs <= 4
        subplot (4, 1, i), specgram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
        caxis([-100 20])
    elseif num_songs <= 6
        subplot (6, 1, i), specgram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
        caxis([-100 20])
    elseif num_songs <= 8
        subplot (4, 2, i), specgram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
        caxis([-100 20])
    elseif num_songs <= 12
        subplot (6, 2, i), specgram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
        caxis([-100 20])
    elseif num_songs > 12
        error('Too many songs! Please give me 12 or fewer next time.')
    end
end
caxis([-100 20])

figure
for i=1:num_songs
	thisSong = songList{i};
    if num_songs == 1
        oscillogram(thisSong, 512, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
    elseif num_songs <= 4
        subplot (4, 1, i), oscillogram(thisSong, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
    elseif num_songs <= 6
        subplot (6, 1, i), oscillogram(thisSong, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
    elseif num_songs <= 8
        subplot (4, 2, i), oscillogram(thisSong, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
    elseif num_songs <= 12
        subplot (6, 2, i), oscillogram(thisSong, samp_freq);
        title(char(fileList{i}),'Interpreter','none')
    end
end
