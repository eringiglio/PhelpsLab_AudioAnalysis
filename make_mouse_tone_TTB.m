function [tone] = make_mouse_tone(song, method, samp_rate)

% function [tone] = make_mouse_tone(song, method, samp_rate)
%
% dominant frequency: frequency of highest amplitude
%
% Takes a song file as input and returns tone precisely matched to the
% dominant frequency and amplitude envelope of the model/input song.  
% It uses one of three methods for generating the tone, which vary in terms 
% of their amplitude envelopes. The simplest is 'simp' -- this method looks 
% up the time and value of the peak amplitude in the song, and generates 
% an amplitude envelope that is a linear ramp up to that peak, and a linear 
% ramp down from it. The default method is 'song' in which the peak amplitude 
% and timing is recorded for each note. The amplitude envelope is a linear 
% ramp from note to note. The last option is called 'note' -- this 
% amplitude envelope is flat for each note, set to the corresponding note's 
% peak amplitude, and zero between notes. It thus preserves the amplitude 
% envelope of the signal at the level of note structure.
%
% After the appropriate emplitude envelope is generated, the specific frequency is stated, 
% and a tone is generated and then shaped by amplitude envelope.  
% modified from previous code by S. Phelps.
% - T.T.Burkhard, July 2016.

if nargin<3, samp_rate = 195312.5; end 
if nargin<2, method = 'song'; end

% Input data from song, using the msr_all_AL script for QERC songs. --TTB July 2016
%[note_num, song_length, song_DF, entropy, pk_amp, song_rms, pk_power] = msr_whole_call(song, samp_rate, 10, 5); %note threshold and reset values!
[call_stats, call_stat_labels, all_notes_matrix, note_labels] = msr_all_AL(song, 195312.5, 8, 10, 'note', 'q', 200, 0, 1);

   
%% tracy tone new stuff 7 july 2016 ---------------------

tone = s.*amp_env';
tone = tone*(song_rms/rms(tone));

[call_stats, call_stat_labels, all_notes_matrix, note_labels] = msr_all_AL(song, 195312.5, 8, 10, 'note', 'q', 200, 0, 1);

% variables
pk_amps = all_notes_matrix(:,5);
pk_times = all_notes_matrix(:,6); % time given in sec
note_durs = all_notes_matrix(:,3)/1000; % time now in sec
INI = all_notes_matrix(:,4)/1000;
note_starts = (all_notes_matrix(:,1) - all_notes_matrix(1,1))/1000; % first note starts at time 0, time given in sec
note_ends = (all_notes_matrix(:,2) - all_notes_matrix(1,1))/1000;
call_DF = call_stats(:,3);
call_length = call_stats(:,2);
note_num = call_stats(:,1);
song_rms = call_stats(:,6);
pre_pk_amp = 0;
pre_pk_time = 0;
first=1;
num_samp = round(call_length*samp_rate);
amp_env = zeros(num_samp,1);

 for i=1:note_num
        pk_time = pk_times(i,1)+ note_starts(i,1); %defines where the peak is within the song in secs
        step_samps = round((pk_time - pre_pk_time)*samp_rate); %what is pre_pk_time? starts as 0, set to last pk time.
        step_sz = (pk_amps(i,1)-pre_pk_amp)/step_samps;
        last = first + step_samps;
        amp_env(first:last) = [pre_pk_amp:step_sz:pk_amps(i,1)]';
        
        %reset for next note
        first=last;
        pre_pk_amp = pk_amps(i,1);
        pre_pk_time = pk_time;
    end
    step_sz = -pk_amps(note_num,1)/(num_samp-last);
    amp_env(first:num_samp) = [pre_pk_amp:step_sz:0]';
% more vars
cf = call_DF;               % carrier frequency (Hz)
sf = samp_rate;             % sample frequency (Hz)
d = call_length;            % duration (s)
n = sf * d;                 % number of samples
s = (1:n) / sf;             % sound data preparation
s = sin(2 * pi * cf * s);   % sinusoidal modulation

tone = s.*amp_env';
tone = tone*(song_rms/rms(tone));

% each window needs to be 2000000 units, so 2000000 - the length of the
% tone
% e.g. 2000000 - 562440
silence = zeros(1,'the length of the tone');
ct18c_tone = [tone silence];
ct18c = ct18c_tone';
cat_tone = cat(1,ct18a, ct18b);
CT18_tone = cat(1, cat_tone, ct18c);

% Append the songs together....
cat_song = cat(1,final_song1,final_song2);
finished_stimulus = cat(1,cat_song,final_song3);

fid = fopen('CT18_tone.f32', 'a');         % saved to a new file 
fwrite(fid, CT18_tone, 'float32');





