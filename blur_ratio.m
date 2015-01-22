function [] = blur_ratio(note_starts, note_ends, song, samp_rate)

% function [] = blur_ratio(note_starts, note_ends, song)
%
% Takes note_starts and note_ends variables as inputs from msr_note_times.
% This existing routine measures note onset and offset in units of msec.
% Unlike most of our code, the default sample rate here is set to 96000 to match
% the specs on the ranging study conducted by Bret Pasch.

% Set defaults
%-------------

if nargin<4
    samp_rate = 96000;
end

if nargin<3
    error('Error: must have at least three input arguments.')
end

[note_num, c] = size(note_starts);


% Extract notes
%--------------
for i=1:note_num
    signal_start = int(note_starts(i,1)*samp_rate/1000);
    signal_end = int(note_ends(i,1)*samp_rate/1000);
    
    if i==1
        signal = song(signal_start:signal_end);
    else
        signal = [signal;song(signal_start:signal_end)];
    end
end

% Extract INI
%--------------
for i = 2:note_num
    INI_start = int(note_ends(i-1,1)*samp_rate/1000);
    INI_end = int(note_starts(i,1)*samp_rate/1000);
    if i==2
        noise = song(INI_start:INI_end);
    else
        noise = [noise;song(INI_start:INI_end)];
    end
end

% Calculate SNR for notes/INI
%-----------------------------
[signal_Pxx, F] = pwelch(signal,[],[],[], samp_rate);
[noise_Pxx, F] = pwelch(noise,[],[],[], samp_rate);
snr = log10(signal_Pxx./noise_Pxx);

