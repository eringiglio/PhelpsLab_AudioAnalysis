function [song] = synth_song(note_num, note_durs_a, note_durs_b, note_durs_c, INI_a, INI_b, INI_c, pk_amp_a, pk_amp_b, pk_amp_c, pk_time_a, pk_time_b, pk_time_c, FMa_a, FMa_b, FMa,_c, FMb_a, FMb_b, FMb_c, FMc_a, FMc_b, FMc_c, samp_rate)

% Note labels are given by: 'note_starts', 'note_ends', 'note_durs', 'INI',
% 'pk_amp', 'pk_time', 'qpk_amp', 'qpk_time', 'note_rmss', 'rel_pk_amp', 'rel_qpk_amp', 'rel_note_rmss', 'rel_pk_tm', 'rel_qpk_tm', 'rel_INI', 'max_Hz', 'min_Hz', 'FMa', 'FMb', 'FMc', 'FM_resid', 'note_DF'
% 
% note_num, note_durs, INI, pk_amp, pk_time, FMa, FMb, FMc
%
% note_num, note_durs_a, note_durs_b, note_durs_c, INI_a, INI_b, INI_c, pk_amp_a, pk_amp_b, pk_amp_c, pk_time_a, pk_time_b, pk_time_c, FMa_a, FMa_b, FMa,_c, FMb_a, FMb_b, FMb_c, FMc_a, FMc_b, FMc_c
% Makes more sense to have all of these in a file and read them in_
%
% THIS IS UNTESTED. SEEMS RIGHT, BUT WOULD BE GOOD TO READ IN VALUES FROM
% FILE.

if nargin<23, samp_rate = 195312.5;
if nargin<22, error('error: 22 input arguments needed to define song'), end
song = 0; % need to define song prior to concatenation at end of routine. However, this will lead to an extra zero element in first position

for i=1:note_num
    j=i-1; %first note is defined as note zero
    
    % Calculate frequency modulation for current note
    FMa = FMa_a*j^2 + FMa_b*j +FMa_c;
    FMb = FMb_a*j^2 + FMb_b*j +FMb_c;
    FMc = FMc_a*j^2 + FMc_b*j +FMc_c;
    note_dur = note_dur_a*j^2 + note_dur_b*j +note_dur_c;
    note = write_note_FM(FMa,FMb,FMc,note_dur,samp_rate);
    
    % Calculate amplitude envelope for current note
    pk_time = pk_time_a*j^2 + pk_time_b*j +pk_time_c;
    note = write_note_AM(note, pk_time, samp_rate);
 
    pk_amp = pk_amp_a*j^2 + pk_amp_b*j +pk_amp_c; %should this be rel_pk_amp?
    note = note*pk_amp; %rel_pk_amp? I think it doesn't matter...
    
    %Add current note to song, followed by appropriate INI
    song = [song, note];
    if i<note_num 
        INI = INI_a*j^2 + INI_b*j +INI_c;
        song = [song, zeros(round(INI*samp_rate))]; 
    end
end