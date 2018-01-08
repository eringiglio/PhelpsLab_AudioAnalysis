function[summary_table, note_dur_avg, INI_avg, note_num, song_length] = quick_song_stats(song, samp_freq, threshold, INI_max)

%This program is intended to take some quick metrics of song quality from 
%songs recorded on the RX8 at a glance, so that I can see whether quality
%is a metric worth pursuing on measures of 2MA vs saline as a treatment.
%We'll see what it gives me for each song. 

%Because it's easiest to use all those values under one statistic, I want 
%this program to spit out a lixlttle summarytable with all of these metrics 
%in order for its first output variable. If you want just one of the 
%metrics from it, it will also return those if you specify future output 
%variables. 

%We're writing this assuming to start with that you have only one song per
%file, and if you are intending to do a file with two songs you'll split
%them up. Okay.

%Specifying defaults
if nargin < 4
    INI_max = 200;
end

if nargin < 3
    threshold = 8;
end

if nargin < 2
    samp_freq = 195312.5;
end

%First thing we'll want is tables of notes...
[note_starts, note_ends, note_durs, INI] = msr_note_times(song, samp_freq,threshold,10,INI_max);

%That gives us a bunch of tables. We want to take the average of each real
%quick. We also want to know how many notes are in each song, so we count
%the table. Note that all time values are expressed in msec. 
note_dur_avg = mean(note_durs);
INI_avg = mean(INI);
[note_num,c] = size(note_starts);

%What about the average bandwidth of each note? ugh this is hard, leaving
%it out for a moment
%bandwidth_avg = 

%Hell, how about how long the song lasts...
song_length = note_ends(note_num) - note_starts(1);

%Let's put it all together...
summary_table = [note_dur_avg,INI_avg,note_num,song_length];
