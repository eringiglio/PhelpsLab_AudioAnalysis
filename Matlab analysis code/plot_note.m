function[note_plot] = plot_note(file_name, note_ID, samp_freq)

%setting base values for nonessential inputs--in general, most of this code
%is just borrowed from fundamental_freq for troubleshooting/visualizing
%purposes. Better commenting can be found there

if nargin < 3
    samp_freq = 195312.5;
end

if nargin < 2
    error('Please provide individual note identity.')
end

song = read_songs(file_name);
[note_starts, note_ends] = msr_note_times(song);

this_start = round((note_starts(note_ID,1)*samp_freq)/1000);  %here I'm turning values spit out in units of ms into sampling units
this_end = round((note_ends(note_ID,1)*samp_freq)/1000);

note_graph = specgram(song(this_start:this_end), 256, samp_freq);
[r,c] = size(note_graph);

freq_bin_width = samp_freq/(2*r); %here I'm defining the bin size--maximal frequency I can "see" is half my sampling frequency, and the number of bins I have is equal to the number of rows

    for i=1:c
        [~, this_place] = max(note_graph(:,i));
        fund_frequency(i,1) = (this_place*freq_bin_width) - 0.5*freq_bin_width;
               j=1;
        while(j && i>2)
           if (fund_frequency(i,1) - fund_frequency(i-1,1)) > 200 
               note_graph(this_place,i) = 0;
           else
               j=0;
          end
        end
 
        time_bin_width = (this_end - this_start)/c; 
        time(i,1) = i*time_bin_width - 0.5*time_bin_width;
    end
time_sec = (time)/samp_freq;   % trying to see if converting into seconds helps at all
equation = polyfit(time_sec(1:c), fund_frequency(1:c), 2);

%creating definitions for my second plot
time_note_gradient = 0:0.01:(note_ends(note_ID,1)-note_starts(note_ID,1));
plotted_fit = polyval(equation,time_note_gradient);

subplot(1,3,1), specgram(song(this_start:this_end), 256, samp_freq)
subplot(1,3,2), plot(time_note_gradient,plotted_fit,'-'), axis([0 ((note_ends(note_ID,1)-note_starts(note_ID,1))/1000) 0 (samp_freq/2)])
subplot(1,3,3), plot(time_sec,fund_frequency,'o'), axis([0 ((note_ends(note_ID,1)-note_starts(note_ID,1))/1000) 0 (samp_freq/2)])