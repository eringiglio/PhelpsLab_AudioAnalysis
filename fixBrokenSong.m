function[fixedSongA,fixedSongB] = fixBrokenSong(songA,songB,index)

%This program is intended to take a set of paired songs that have gotten
%cut in the middle and started again because of buffering issues and fix
%them. 

[songLengthA,~] = size(songA);
[songLengthB,~] = size(songB);

if songLengthA ~= songLengthB
    error('Make sure these are paired songs, or perhaps edit this code')
end

% define default number of bins in the sample (number of songs = bins)
if nargin<3
    index=songLengthA/2;
end

songA1 = songA(1:index,:);
songA2 = songA(index+1:songLengthA,:);
fixedSongA(1:songLengthA-index,:) = songA2;
fixedSongA(songLengthA-index+1:songLengthA,:) = songA1;

songB1 = songB(1:index);
songB2 = songB(index+1:songLengthB);
fixedSongB(1:songLengthB-index,:) = songB2;
fixedSongB(songLengthB-index+1:songLengthB,:) = songB1;
