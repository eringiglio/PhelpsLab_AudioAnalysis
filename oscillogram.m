function [oscillogram] = oscillogram(song,samp_freq,startTime)
%Intended to provide an automatic oscillogram of a song in the same way
%that specgram or spectrogram function provides an automatic spectrogram.
%Inputs a pre-read .f32 file and a sampling frequency, automatically
%calculates the x axis. Optional argument startTime = time in seconds that
%the recording began at. 
%EMG, 2019

%set default of time of recording beginning at 0
if nargin<3
    startTime = 0;
end

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

[song_length,~] = size(song);

time_between = 1/samp_freq;
%define Y axis
y = song;

x = startTime:time_between:((song_length-1)*time_between)+startTime;

%length(x) == length(y);
oscillogram = plot(x,y);