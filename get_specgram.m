function[song] = get_specgram(song,samp_freq)

%Here I basically just want to set up a quick thing that will translate 
%specgram, which is outdated, into spectrogram, which is a successor
%program. (Ideally this will play more nicely with other options.)

[file_length,c] = size(song);
% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

spectrogram(song,512,256,512,samp_freq);