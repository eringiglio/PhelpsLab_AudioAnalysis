function [new_note] = stretch_note(FMa, FMb, FMc, pk_time, note_dur, BW_stretch, AM_stretch, samp_rate)
%
% function [new_note] = stretch_note(FMa, FMb, FMc, pk_time, note_dur, BW_stretch, AM_stretch, samp_rate)
%
% This defines a note in terms of six variables: FMa, FMb, FMc, pk_amp
% pk_time, and note_dur. It then streteches a note in terms of either bandwidth
% (BW_STRETCH) or amplitude (AM_STRETCH). A value of 2 for BW_STRETCH
% doubles the bandwidth while keeping the frequency with the most power the
% same. Similarly, 2 for AM_stretch doubles the length of the note (which
% also alters its FM properties) while keeping the peak amplitude centered
% at the same peak frequency as in the original note. A value of 1
% preserves the original values for the note. Deafult value for AM_stretch
% is 1, default for sample rate is 195312.5. Notice that the new note
% passed back will not be the same length as the old note if the amplitude
% envelope has been altered. Routines calling this function will need to
% determine size of new note

if nargin<8, samp_rate = 195312.5, end
if nargin<7, AM_stretch = 1, end
if nargin<6, error('error: too few input arguments'), end

% Determine three frequencies used to define note
F0 = FMc; %starting frequency
F1 = FMa*pk_time*pk_time + FMb*pk_time + FMc; %peak frequency
F2 = FMa*note_dur*note_dur + FMb*note_dur + FMc; %end freq

new_F(1,1) = BW_stretch*(F0-F1)+F1;     %new F0
new_F(2,1) = F1;                        %new peak freq same as last
new_F(3,1) = BW_stretch*(F2-F1)+F1;     %new F2

% Determine times of new note
new_T(1,1) = 0;                         %start time always zero
new_T(2,1) = AM_stretch*pk_time;        %new peak time
new_T(3,1) = AM_stretch*note_dur;       %new note_dur

% Calculate new FM curves
FM = polyfit(new_T, new_F, 2); %FM gives the terms in 2nd-order polynomial

% Get new synthetic frequency sweep
new_note = write_note_FM(FM(1,1), FM(1,2), FM(1,3), new_T(3,1), samp_rate);

% Amplitude modulate note
new_note = write_note_AM(new_note, pk_time); 

