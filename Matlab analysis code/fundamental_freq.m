function [coeff1, coeff2, coeff3, freq_max, freq_min] = fundamental_freq(file_name, samp_freq)

%setting base values for nonessential inputs
if nargin < 2
    samp_freq = 195312.5;
end

%defining initial variables
song = read_songs(file_name);
[note_starts, note_ends] = msr_note_times(song);
[number_notes,~] = size(note_starts);

%setting up a bigger for loop to capture all the notes in the song
for j=1:number_notes;

    % separating out individual note and spitting out a specgram for further
    % analysis
    this_start = round((note_starts(j,1)*samp_freq)/1000);  %here I'm turning values spit out in units of ms into sampling units
    this_end = round((note_ends(j,1)*samp_freq)/1000);

    note_graph = specgram(song(this_start:this_end), 256, samp_freq);
    [r,c] = size(note_graph);

    %it turns out that the last ~20-30% or so of the "fundamental frequency"
    %maximum data comes from the next-lowest harmonic, not the actual
    %fundamental frequency itself, as the real fundamental trails off.
    %Current attempts to fix that are in plot_note; I can't quite figure it
    %out. 

    %time to find the placement of the maximum frequency bin on our spectrogram
    %for each column: using a for loop

        for i=1:c
            [~, this_place] = max(note_graph(:,i));
            freq_bin_width = samp_freq/(2*r); %here I'm defining the bin size--maximal frequency I can "see" is half my sampling frequency, and the number of bins I have is equal to the number of rows
            fund_frequency(i,1) = (this_place*freq_bin_width) - 0.5*freq_bin_width; %reading maximum frequency and placing it in the middle of that frequency bin
            time_bin_width = (this_end - this_start)/c; 
            time(i,1) = i*time_bin_width - 0.5*time_bin_width;
        end

    time_sec = (time)/samp_freq;   % trying to see if converting into seconds helps at all
    equation = polyfit(time_sec(1:c), fund_frequency(1:c), 2);
    coeff1(j,1) = equation(1,1);
    coeff2(j,1) = equation(1,2);
    coeff3(j,1) = equation(1,3);
    [freq_max(j,1),~] = max(fund_frequency);
    [freq_min(j,1),~] = min(fund_frequency);
    
    %creating definitions for my second plot
    time_note_gradient = 0:0.01:(note_ends(j,1)-note_starts(j,1));
    plotted_fit = polyval(equation,time_note_gradient);

%    subplot(1,3,1), specgram(song(this_start:this_end), 256, samp_freq);
%    subplot(1,3,2), plot(time_note_gradient,plotted_fit,'-'), axis([0 ((note_ends(j,1)-note_starts(j,1))/1000) 0 (samp_freq/2)])
%    subplot(1,3,3), plot(time_sec,fund_frequency,'o'), axis([0 ((note_ends(j,1)-note_starts(j,1))/1000) 0 (samp_freq/2)])
end

%x2 = 1:.1:5;
%y2 = polyval(p,x2);
%plot(x,y,'o',x2,y2)