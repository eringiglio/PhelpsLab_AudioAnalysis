function [bestThresholds] = findBestThreshold_batch(xls_file,samp_rate)
% This code is designed to help you find the best threshold value for a batch of songs. Insert an excel file formatted with the name of all the songs in your dataset (see getSongListfromExcel), and you should get a list of values.

%Deprecated, maybe try fixing other issues with the songs. Erin Giglio, Dec 2017.

% define default sample frequency
if nargin<2
    samp_rate = 195312.5;
end

songList = getSongListfromExcel('xls_file',samp_rate);

% How many songs do we have? == c 
[r,c] = size(songList);
threshList = [];

for i=1:c
	song = songList(:,i);
	threshList(i) = findBestThreshold(song);
end

bestThresholds = threshList';