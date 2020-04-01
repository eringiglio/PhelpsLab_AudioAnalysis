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

clear file1; clear file2; clear song

file1 = read_songs('8-12_ch4_901_09_21_02.F32');
file2 = read_songs('8-12_ch4_961_10_22_28.F32');

file1 = rx8Filter(file1);
file2 = rx8Filter(file2);

secondsTrimmed = 38*60+58;

samples = round(secondsTrimmed * samp_freq);

song = file1(samples:360000000);
song(360000001-samples:360000000) = file2(1:samples);

write_songs('08-14_ch4_preplay.F32',song);
