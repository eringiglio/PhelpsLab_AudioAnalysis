function[note_rate,note_bandwidth] = plot_fitness(file_name, samp_freq)
    
if nargin < 2
    samp_freq = 195312.5;
end

song = read_songs(file_name);

% first we work on the note rate side of things
[note_starts, ~, note_durs, INIs] = msr_note_times(song);

% if you have n notes in the song, INIs will be a matrix of n-1 length, so
% correcting for that here by removing the final note here
num_notes_trim = length(note_starts) - 1;
trim_note_durs = note_durs(1:num_notes_trim);

duty_cycle = (trim_note_durs + INIs);
note_rate = 1000./duty_cycle;

%now we go after the bandwidth of each note

[~,~,~,freq_max,freq_min] = fundamental_freq(file_name);
trim_freq_max = freq_max(1:num_notes_trim);
trim_freq_min = freq_min(1:num_notes_trim);
note_bandwidth = trim_freq_max - trim_freq_min;

%setting bounds on our axes for plotting later
[max_dur,~] = max(note_rate);
[min_dur,~] = min(note_rate);
range_note_dur = max_dur - min_dur;
[max_bandwidth,~] = max(note_bandwidth);

%Now we have Bret's equation, borrowed from the Animal Behaviour paper
time_between = 1/samp_freq;
x = 0:time_between:max_dur;
y = -1191.4*(x) + 42692;

hold on
plot(note_rate,note_bandwidth,'o')%, axis([0 max_dur 0 max_bandwidth]));
plot(x,y,'-')%, axis([0 max_dur 0 max_bandwidth]));