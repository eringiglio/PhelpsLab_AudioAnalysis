function [songList,fileList] = getSongListfromExcel(xls_file,samp_rate)

% This program exists in order to take an xlsx file in the form of a list of song file names and return a list of songs, such that it can be taken by view_many_songs and allow the user to scroll through it.
%
% DEPENDENCIES: read_songs; xlsread
%
%The Excel file should be formatted:
%'SONGNAME_1.f32'
%'SONGNAME_2.f32'
% and so forth and so on. 

% define default sample frequency
if nargin<2
    samp_rate = 195312.5;
end

[x,c,fileOutput] = xlsread(xls_file);

songList = zeros(2000000,length(fileOutput(1,:)));

for i=1:length(fileOutput)
	songList(:,i) = read_songs(char(fileOutput(i)),samp_rate);
end
fileList = fileOutput';