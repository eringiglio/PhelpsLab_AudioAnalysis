function [oscillogram] = oscillogram(song,samp_freq)

%Intended to provide an automatic oscillogram of a song in the same way that specgram or spectrogram function. 

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

[song_length,c] = size(song);

time_between = 1/samp_freq;
%define Y axis
y = song;

x = 0:time_between:(song_length-1)*time_between;

%length(x) == length(y);
oscillogram = plot(x,y)