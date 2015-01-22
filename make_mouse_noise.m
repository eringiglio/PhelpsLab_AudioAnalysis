function [noise] = make_mouse_noise(song, method, samp_rate)

% function [noise] = make_mouse_noise(song, method, samp_rate)
%
% Takes a song file as input and returns noise precisely matched to the
% attributes of the song. It uses one of three methods for generating
% the noise, which vary in terms of their amplitude envelopes. The simplest
% is 'simp' -- this method looks up the time and value of the peak
% amplitude in the song, and generates an amplitude envelope that is a
% linear ramp up to that peak, and a linear ramp down from it. The default
% method is 'song' in which the peak amplitude and timing is recorded for
% each note. The amplitude envelope is a linear ramp from note to note. The
% last option is called 'note' -- this amplitude envelope is flat for each
% note, set to the corresponding note's peak amplitude, and zero between
% notes. It thus preserves the amplitude envelope of the signal at the
% level of note structure.
%
% After the appropriate emplitude envelope is generated, a gaussian noise
% is generated, shaped by the amplitude envelope, and then bandpass
% filtered. Currently the filter can only handle a single sampling
% frequency (195312.5), which is the default for this routine. The bandpass
% filter is described in MOUSE_NOISE_FILTER.M. Lastly, the overall
% amplitude of the noise is adjusted so that the noise and the input signal
% have the same rms smplitude.
%
% S. Phelps, May 2012.

if nargin<3, samp_rate = 195312.5; end
if nargin<2, method = 'song'; end

% Input data from song
[note_num, song_length, song_DF, entropy, pk_amp, song_rms, pk_power] = msr_whole_call(song, samp_rate, 10, 5); %note threshold and reset values!
[song_stats, song_stat_labels, all_notes_matrix, note_labels] = msr_all(song, samp_rate);

pk_amps = all_notes_matrix(:,5);
pk_times = all_notes_matrix(:,6); % time given in sec
note_durs = all_notes_matrix(:,3)/1000; % time now in sec
INI = all_notes_matrix(:,4)/1000;
note_starts = (all_notes_matrix(:,1) - all_notes_matrix(1,1))/1000; % first note starts at time 0, time given in sec
note_ends = (all_notes_matrix(:,2) - all_notes_matrix(1,1))/1000;

% Declare variables
pre_pk_amp = 0;
pre_pk_time = 0;
first=1;
num_samp = round(song_length*samp_rate);
amp_env = zeros(num_samp,1);

% Generate amplitude envelope matching song using desired method
if method == 'simp'
    [pk_amp,pk_samp] = max(abs(song));
    ascending_step = pk_amp/pk_samp;
    descending_step = pk_amp/(num_samp-pk_samp);
    amp_env = [0:ascending_step:pk_amp]';
    amp_env(pk_samp:num_samp,1) = [pk_samp:descending_step:0]';
end

if method == 'song'
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
end

if method == 'note'
    for i = 1:note_num
        first = round(note_starts(i,1)*samp_rate)+1;
        last = round(note_ends(i,1)*samp_rate);
        amp_env(first:last) = pk_amps(i,1);
    end
end

% generate noise stimulus
noise = randn(num_samp,1); % begin with gaussian noise
noise = noise.*amp_env; % shape according to amplitude envelope calculated above
noise = mouse_noise_filter(noise); %bandpass filter noise so energy is all between ~15-32kHz; designed using matlab filter design tool. see comments.
                                    % this method assumes a sample rate of
                                    % 195312.5 Hz. Would need to generate a
                                    % new filter for different sample rates
noise = noise*(song_rms/rms(noise)); % make rms of energy in noise stimulus identical to input song



        
        
        
        
        
        
        
        
        
        
