function [song] = stretch_song(note_num, note_durs_a, note_durs_b, note_durs_c, INI_a, INI_b, INI_c, pk_amp_a, pk_amp_b, pk_amp_c, pk_time_a, pk_time_b, pk_time_c, FMa_a, FMa_b, FMa,_c, FMb_a, FMb_b, FMb_c, FMc_a, FMc_b, FMc_c, BW_stretch, AM_stretch, INI_stretch, samp_rate)

%
% THIS IS UNTESTED. SEEMS RIGHT, BUT WOULD BE GOOD TO READ IN VALUES FROM
% FILE. Note this could replace synth song, adding stretch arguments as
% extra posibile inputs.

if nargin<26, samp_rate = 195312.5; end
if nargin<25, INI_stretch = 1; end
if nargin<24, AM_stretch = 1; end
if nargin<23, FM_stretch = 1; end
if nargin<22, error('error: 22 input arguments needed to define song'), end
song = 0; % need to define song prior to concatenation at end of routine. However, this will lead to an extra zero element in first position

for i=1:note_num
    j=i-1; %first note is defined as note zero
    
    % Calculate frequency modulation for current note
    FMa = FMa_a*j^2 + FMa_b*j +FMa_c;
    FMb = FMb_a*j^2 + FMb_b*j +FMb_c;
    FMc = FMc_a*j^2 + FMc_b*j +FMc_c;
    note_dur = note_dur_a*j^2 + note_dur_b*j +note_dur_c;
    
    % Calculate amplitude envelope for current note
    pk_time = pk_time_a*j^2 + pk_time_b*j +pk_time_c;
    
    % Synthesize stretched note
    note = stretch_note(FMa, FMb, FMc, pk_time, note_dur, BW_stretch, AM_stretch, samp_rate)
 
    pk_amp = pk_amp_a*j^2 + pk_amp_b*j +pk_amp_c; %should this be rel_pk_amp?
    note = note*pk_amp; %rel_pk_amp? I think it doesn't matter...
    
    %Add current note to song, followed by appropriately stretched INI
    song = [song, note];
    if i<note_num 
        INI = INI_a*j^2 + INI_b*j +INI_c;
        INI = INI*INI_stretch;
        song = [song, zeros(round(INI*samp_rate))]; 
    end
end