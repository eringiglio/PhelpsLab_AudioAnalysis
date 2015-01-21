function [coeff1, coeff2, coeff3, fund_frequency] = fundamental_freq(file_name, samp_freq)

%setting base values for nonessential inputs
if nargin < 2
    samp_freq = 195312.5;
end

%defining initial variables
song = read_songs(file_name);
[note_starts, note_ends] = msr_note_times(song);

% separating out individual note and spitting out a specgram for further
% analysis
this_start = round((note_starts(1,1)*samp_freq)/1000);  %here I'm turning values spit out in units of ms into sampling units
this_end = round((note_ends(1,1)*samp_freq)/1000);

note_graph = specgram(song(this_start:this_end), 256, samp_freq);
[r,c] = size(note_graph);



%time to find the placement of the maximum frequency bin on our spectrogram
%for each column: using a for loop

for i=1:c
    [this_max, this_place] = max(note_graph(:,i));
    bin_place = samp_freq/(2*r); %here I'm defining the bin size--maximal frequency I can "see" is half my sampling frequency, and the number of bins I have is equal to the number of rows
    actual_freq = (this_place*bin_place) - 0.5*bin_place;
    fund_frequency(i,1) = actual_freq;
    bin_max = (this_end - this_start)/c; 
    actual_max = this_max*bin_max - 0.5*bin_max;
    freq_max(i,1) = actual_max;
end

equation = polyfit(fund_frequency, freq_max, 2);
coeff1 = equation(1,1);
coeff2 = equation(1,2);
coeff3 = equation(1,3);