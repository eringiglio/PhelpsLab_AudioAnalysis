function [] = write_playbackSongs(outputTable, song,outFile)

%This routine exists in order to take the output of findPlaybackSongs and
%use it to create a series of 30sec recordings that can be analyzed later
%as part of a batch process. Try to make sure the origin file is filtered,
%it'll make your life easier later on. 
%
% - EMG, July 2019

%default is RX8 sampling frequency
if nargin<3
    outFile = "";
end

[r,~] = size(outputTable);

nameRoot = outputTable{1,1};

for i=1:r
    newFile = strcat(outFile,nameRoot,'_',string(i),'.F32');
    songStart = max(outputTable{i,5} - 1000000,1);
    songEnd = outputTable{i,5} + 2000000;
    newBit = song(songStart:songEnd);
    write_songs(newFile,newBit);
end