function [threshold,noteNum] = findBestThreshold(song,samp_rate)

% This is a program intended to find the best threshold at which to run a given song via msr_note_times; generally we tend to get more false negatives than false positives, and in cases where the song is cut slightly off at the beginning finding the right threshold can be difficult. 
% If this is something worrying you, check the sampling rate--a real song should have a fundamental frequency that sits between 1 and 2 kHz--and then try running this. 

% define default sample frequency
if nargin<2
    samp_rate = 195312.5;
end

% We're starting from a default threshold multiplication value of 8 and seeing whether increasing or decreasing the value increases or decreases the number of notes. 
noteNum = [];

% Right, here's a *way* easier way to do this... gets me a column of threshold values that work for me.
for i=1:20
	try
		[A_starts,A_ends,A_durs,A_INIs] = msr_note_times(song,samp_rate,i);
	catch 
		A_starts = 0;
	end
	[sizeI,c] = size(A_starts);
	noteNum(i) = sizeI;
end

% Selecting the first maximum value from this column.
[Y,threshold] = max(noteNum);