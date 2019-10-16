function [song] = makeHourRecord(samp_freq)

%This function exists to help me create a single hour-long recording for
%each playback instance in the leptin IEG experiment--starting with two
%recordings that each contain a piece of my desired recording time and
%pasting them together to fit. 
%  - EMG 5/25/19


% define default number of bins in the sample (number of songs = bins)
if nargin<1
    samp_freq = 195312.5/2;
end

file1 = read_songs('7-22_ch6_2641_10_37_37.F32',samp_freq);
file2 = read_songs('7-22_ch6_2701_11_39_03.F32',samp_freq);

file1 = rx8Filter(file1);
file2 = rx8Filter(file2);

secondsTrimmed = 22*60+33;

samples = round(secondsTrimmed * samp_freq);

song = file1(samples:360000000);
song(360000001-samples:360000000) = file2(1:samples);

write_songs('7-22_ch6_playback.F32',song);

