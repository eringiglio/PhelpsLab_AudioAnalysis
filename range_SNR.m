function [T_Pxx, X_Pxx, T_SNR, X_SNR, Noise_Pxx, stim_labels, F] = range_SNR(file, stim_starts, stim_ends, samp_rate)

% function [T_Pxx, X_Pxx, T_SNR, X_SNR, Noise_Pxx, stim_labels] = range(file, stim_starts, stim_ends, samp_rate)
%
% This code was written specifically to analyze ranging data from Pasch. It
% assumes the first stimulus is a tone (at DF of species), the second is
% white noise that has been been band-pass filtered and shaped to roughly
% the amplitude envelope of a song, and stimuli 3-6 correspond to different
% exemplars of a natural song. The first 6 stimuli were for teguina, the
% second six for xerampelinus. Lastly, the time between stimuli was
% concatenated and used to measure the power spectrum of ambient noise.
%
% Analysis for songs are given explicitly below, and would need to be
% changed manually within the code to try other values. 
%
% The Pxx outputs contain 256 frequency bins defined in the output variable
% F. The 6 columns for each Pxx output variable correspond to teh six
% stimuli tested for the corresponding species. The order of the stimuli is
% given in stim_labels.
%
% SNR is defined as the log10(power in song/power in noise) for each
% frequency bin. The order of stimuli is as in Pxx. 
%
% S. Phelps, Feb. 2011

% Set defaults
%--------------
 if nargin<4, samp_rate = 96000; end
 if nargin<3, stim_ends = [8.498; 16.482; 24.316; 32.136; 40.642; 47.430; 52.411; 57.412; 61.882; 67.155; 71.592; 76.161]; end
 if nargin<2, stim_starts = [3.502; 11.483; 19.491; 27.382; 35.180; 43.743; 50.416; 55.414; 60.462; 64.980; 70.185; 74.628]; end
 if nargin<1, error('Error: need at least one input argument.'), end

% Read in file
%--------------
source = wavread(file);

% Extract stimuli
%----------------

stim_start = round(stim_starts(1,1)*samp_rate);
stim_end = round(stim_ends(1,1)*samp_rate);
T_tone = source(stim_start:stim_end);

stim_start = round(stim_starts(2,1)*samp_rate);
stim_end = round(stim_ends(2,1)*samp_rate);
T_nos = source(stim_start:stim_end);

stim_start = round(stim_starts(3,1)*samp_rate);
stim_end = round(stim_ends(3,1)*samp_rate);
T1 = source(stim_start:stim_end);

stim_start = round(stim_starts(4,1)*samp_rate);
stim_end = round(stim_ends(4,1)*samp_rate);
T2 = source(stim_start:stim_end);

stim_start = round(stim_starts(5,1)*samp_rate);
stim_end = round(stim_ends(5,1)*samp_rate);
T3 = source(stim_start:stim_end);

stim_start = round(stim_starts(6,1)*samp_rate);
stim_end = round(stim_ends(6,1)*samp_rate);
T4 = source(stim_start:stim_end);

stim_start = round(stim_starts(7,1)*samp_rate);
stim_end = round(stim_ends(7,1)*samp_rate);
X_tone = source(stim_start:stim_end);

stim_start = round(stim_starts(8,1)*samp_rate);
stim_end = round(stim_ends(8,1)*samp_rate);
X_nos = source(stim_start:stim_end);

stim_start = round(stim_starts(9,1)*samp_rate);
stim_end = round(stim_ends(9,1)*samp_rate);
X1 = source(stim_start:stim_end);

stim_start = round(stim_starts(10,1)*samp_rate);
stim_end = round(stim_ends(10,1)*samp_rate);
X2 = source(stim_start:stim_end);

stim_start = round(stim_starts(11,1)*samp_rate);
stim_end = round(stim_ends(11,1)*samp_rate);
X3 = source(stim_start:stim_end);

stim_start = round(stim_starts(12,1)*samp_rate);
stim_end = round(stim_ends(12,1)*samp_rate);
X4 = source(stim_start:stim_end);

% Extract noise
%--------------

for i = 2:12
    noise_start = round(stim_ends(i-1,1)*samp_rate);
    noise_end = round(stim_starts(i,1)*samp_rate);
    if i==2
        noise = source(noise_start:noise_end);
    else
        noise = [noise;source(noise_start:noise_end)];
    end
end


% Measure power spectra
%----------------------

[T_tone_Pxx, F] = pwelch(T_tone,[],[],256, samp_rate);
[T_nos_Pxx, F] = pwelch(T_nos,[],[],256, samp_rate);
[T1_Pxx, F] = pwelch(T1,[],[],256, samp_rate);
[T2_Pxx, F] = pwelch(T2,[],[],256, samp_rate);
[T3_Pxx, F] = pwelch(T3,[],[],256, samp_rate);
[T4_Pxx, F] = pwelch(T4,[],[],256, samp_rate);

[X_tone_Pxx, F] = pwelch(X_tone,[],[],256, samp_rate);
[X_nos_Pxx, F] = pwelch(X_nos,[],[],256, samp_rate);
[X1_Pxx, F] = pwelch(X1,[],[],256, samp_rate);
[X2_Pxx, F] = pwelch(X2,[],[],256, samp_rate);
[X3_Pxx, F] = pwelch(X3,[],[],256, samp_rate);
[X4_Pxx, F] = pwelch(X4,[],[],256, samp_rate);

[Noise_Pxx, F] = pwelch(noise,[],[],256, samp_rate);


% Measure SNR in dB
%------------------

T_tone_SNR = log10(T_tone_Pxx./Noise_Pxx);
T_nos_SNR = log10(T_nos_Pxx./Noise_Pxx);
T1_SNR = log10(T1_Pxx./Noise_Pxx);
T2_SNR = log10(T2_Pxx./Noise_Pxx);
T3_SNR = log10(T3_Pxx./Noise_Pxx);
T4_SNR = log10(T4_Pxx./Noise_Pxx);

X_tone_SNR = log10(X_tone_Pxx./Noise_Pxx);
X_nos_SNR = log10(X_nos_Pxx./Noise_Pxx);
X1_SNR = log10(X1_Pxx./Noise_Pxx);
X2_SNR = log10(X2_Pxx./Noise_Pxx);
X3_SNR = log10(X3_Pxx./Noise_Pxx);
X4_SNR = log10(X4_Pxx./Noise_Pxx);


% Measure song attributes
%------------------------

% [call_stats, call_stat_labels, all_notes_matrix, note_labels] =
% msr_all(call, samp_rate, threshold, reset, time_code, curve_meth, INI_max, fig_on, call_id)
% Could  define variables for measure all if need to.

%[T1_stats] = msr_all(T1, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[T2_stats] = msr_all(T2, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[T3_stats] = msr_all(T3, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[T4_stats] = msr_all(T4, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[X1_stats] = msr_all(X1, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[X2_stats] = msr_all(X2, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[X3_stats] = msr_all(X3, samp_rate, threshold, reset, time_code, curve_meth, INI_max);
%[X4_stats] = msr_all(X4, samp_rate, threshold, reset, time_code, curve_meth, INI_max);


% Group data for easier export
%-----------------------------

T_Pxx(:,1) = T_tone_Pxx;
T_Pxx(:,2) = T_nos_Pxx;
T_Pxx(:,3) = T1_Pxx;
T_Pxx(:,4) = T2_Pxx;
T_Pxx(:,5) = T3_Pxx;
T_Pxx(:,6) = T4_Pxx;

X_Pxx(:,1) = X_tone_Pxx;
X_Pxx(:,2) = X_nos_Pxx;
X_Pxx(:,3) = X1_Pxx;
X_Pxx(:,4) = X2_Pxx;
X_Pxx(:,5) = X3_Pxx;
X_Pxx(:,6) = X4_Pxx;

T_SNR(:,1) = T_tone_SNR;
T_SNR(:,2) = T_nos_SNR;
T_SNR(:,3) = T1_SNR;
T_SNR(:,4) = T2_SNR;
T_SNR(:,5) = T3_SNR;
T_SNR(:,6) = T4_SNR;

X_SNR(:,1) = X_tone_SNR;
X_SNR(:,2) = X_nos_SNR;
X_SNR(:,3) = X1_SNR;
X_SNR(:,4) = X2_SNR;
X_SNR(:,5) = X3_SNR;
X_SNR(:,6) = X4_SNR;


%T_stats(:,1) = T1_stats';
%T_stats(:,2) = T2_stats';
%T_stats(:,3) = T3_stats';
%T_stats(:,4) = T4_stats';

%X_stats(:,1) = X1_stats';
%X_stats(:,2) = X2_stats';
%X_stats(:,3) = X3_stats';
%X_stats(:,4) = X4_stats';

stim_labels = char('tone','nos', 'song1', 'song2', 'song3', 'song4');








