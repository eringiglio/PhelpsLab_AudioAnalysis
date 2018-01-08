function [chunk,name] = breakSongListinChunks(fileList,songList,section)

% This program exists to take a matrix of songs as produced by getSongListfromExcel and breaks them into n equal chunks with attached names.
%
% DEPENDENCIES: read_songs; xlsread
%
%The Excel file should be formatted:
%'SONGNAME_1.f32'
%'SONGNAME_2.f32'
% and so forth and so on. 

%If you don't know how many chunks it will make, you can simply input 0 and as its first output it will tell you. 

[r,fileListNum] = size(fileList);
[r,songListNum]= size(songList);

if fileListNum ~= songListNum
	error('The song list and filename list are different lengths. Check that your file is correctly formatted.')
end

if nargin < 3
	section = 0;
end

%How many chunks will be available to us?
numChunks = floor(fileListNum/12);
addRem = rem(fileListNum,12);
if addRem ~= 0
	numChunks = numChunks + 1;
end

%This is the case where the program will just deliver numChunks if asked to. 
if section == 0;
	nargout = 1;
	chunk = numChunks;
	return;	
end

%Okay. What about the rest?
if section == numChunks;
	chunk = songList(:,(12*(section-1))+1:songListNum);
	name = fileList(:,(12*(section-1))+1:fileListNum);
elseif section == 1;
	chunk = songList(:,1:12);
	name = fileList(:,1:12);
else
	chunk = songList(:,(12*(section-1))+1:12*section);
	name = fileList(:,(12*(section-1))+1:12*section);
end

%To get all variables, at once, you may want to run the script 
