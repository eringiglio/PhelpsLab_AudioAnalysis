function [call_stats, call_stat_labels, all_notes_matrix, note_labels] = msr_all_AL(call, samp_rate, threshold, reset, time_code, curve_meth, INI_max, fig_on, BUTTfil_on, call_id)
% 3-2016 TTB
% note: TTB added "arclength" & "FM_score" calculations and BUTTfil option.
% input: [call_stats, call_stat_labels, all_notes_matrix, note_labels] = msr_all(call(saved from file), samp_rate, threshold, reset, time_code, curve_meth, INI_max, fig_on, call_id)
%
% This routine takes 8 input arguments, the first being a call to analyze. If more than one call is present in the data, it will analyze the
% longest call. The latter arguments can be omitted for default values. Default values are

% if nargin < 10, call_id = 'unnamed call'; end  % If the fig_on input is true (=1), the routine will make a graph of all curves for the respective variables, as well as a spectrogram. 
% if nargin < 9, BUTTfil = 0; end
% if nargin < 8, fig_on = 0; end 
% if nargin < 7, INI_max = 200; end
% if nargin < 6, curve_meth = 'q'; end
% if nargin < 5, time_code = 'note'; end
% if nargin < 4, reset = 10; end
% if nargin < 3, threshold = 8; end
% if nargin < 2, samp_rate = 195312.5; end 

% The routine provides three output variables:
% 1) The first is a row vector describing all scalar descriptors of a call. This is a rather long list, 
    % including the parameters for curves that describe how note variables change over the course
    % of a call. 
	% (call_stats)
% 2) To clarify, it also lists the labels of each of these variables. Labels ending in "a", "b" and "c" correspond
    % to the coefficients in a quadratic curve fit for the changes in that variable over the course of a curve. Labels ending in
    % "res" are the average residuals from the corresponding curves.
    % (call_stats_labels)
% 3) The third output variable is a matrix of variables measured for
    % individual notes within a call (notes in rows, variables in columns) on which the curves were based. 
    % (all_notes_matrix)
% 4) The final output is a list of labels for this matrix. Note that both label lists 
    % have the variables in rows and letters of the labels in columns. In contrast, the data outputs 
    % have variables in columns and notes in columns. This is due to the way Matlab treats text.
    % The text will need to be transposed before being used as a labels in a
    % spreadsheet or text file. 
    % (note_labels)

% The routine calls, directly or indirectly, nearly all of the routines in the "call analysis tools" folder. 
% The routines it calls directly are MSR_CURVE, MSR_CALL_AMPS, MSR_WHOLE_CALL, MSR_ALL_NOTES, 
% 
% S. Phelps 6-03-07.

% Set defaults
%---------
if nargin < 10, call_id = 'unnamed call'; end 
if nargin < 9, BUTTfil_on = 0; end
if nargin < 8, fig_on = 0; end
if nargin < 7, INI_max = 200; end
if nargin < 6, curve_meth = 'q'; end
if nargin < 5, time_code = 'note'; end
if nargin < 4, reset = 10; end
if nargin < 3, threshold = 8; end
if nargin < 2, samp_rate = 195312.5; end % use 97656.25 for sample rate for RX8

% BUTTfil with Butterworth filter to get rid of band of noise.
%------
if BUTTfil_on == 1 % filter call with butterworth filter
    call = BUTTfil(call); end 

% Measure note number, onset and offset, trim "call" to just those samples within call.
%----------------------------------------------
[note_starts, note_ends, note_durs, INI] = msr_note_times(call,samp_rate,threshold,reset);
%[note_num,c] = size(note_ends);

%a = ceil(note_starts(1,1)*samp_rate/1000);
%b = floor(note_ends(note_num,1)*samp_rate/1000);
%call = call(a:b);

%note_ends = note_ends - note_starts(1,1);
%note_starts = note_starts - note_starts(1,1) + 1000/samp_rate;


% Measure attributes of whole call. Each of these measures is a scalar.
%----------------------------------------------
[note_num, call_length, call_DF, entropy, pk_amp, rms, pk_power] = ...
    msr_whole_call(call, samp_rate, threshold, reset, note_starts, note_ends, INI_max);


% Measure attributes of notes. The resulting matrix has each row equalling one note, variable values in each column.
%----------------------------------------------
[all_notes_matrix, note_labels] = msr_all_notes(call, samp_rate, note_starts, note_ends);


% Measure arclength of individual notes.  This is a measure of FM across song. TTB 2-2016
%----------------------------------------------
rowlength = size(all_notes_matrix,1);
arclength = zeros(rowlength,1); % empty vector to add values to

for i = 1:size(all_notes_matrix,1);
    t1 = all_notes_matrix(i,1); % note.starts
    t2 = all_notes_matrix(i,2); % note.ends
    FMa = all_notes_matrix(i,18);
    FMb = all_notes_matrix(i,19);

ttbarcl = @(t) sqrt(1.+(2.*FMa*(t)+FMb).^2); 
% ttb arc length function: the derivative of ax^2 + bx + c

s = integral(ttbarcl,t1,t2); 
% s = this is the equation for the arclength, integrate over start and end times

arclength(i) = s;

end

all_notes_matrix_AL = [all_notes_matrix, arclength];

% A = all_notes_matrix(1:row,23) % this is the subset of the matrix we need to sum to get FM score
FM_total = sum(all_notes_matrix_AL(1:rowlength,23));
% end TTB insertion.------------------------


% Measure and plot curves.
%-------------------------
[r, var_num] = size(all_notes_matrix);

% Define dimensions of graph, plot spectrogram, if figure is being made
if (fig_on)
    figure, title(call_id);
    rows = ceil(var_num/4)+1;
    if rows>3, rows = 3; end
    columns = 4;
    subplot(rows,1,1), specgram(call, 256, samp_rate), caxis([-100, 35]); 
end

% Calculate curves for each column of note stats
sp=5; %position of subplot skips first row for specgram.

for i =1:var_num
    
    j=(i-1)*4 +1;
    var_name = (note_labels(i,:)); 
    
    if all_notes_matrix(note_num,i) == 0 % Redefine note number for INI measures to avoid zero filler
        note_num=r-1;
    end
    
    if (fig_on) % Activate subplot window for msr_curve routine.
        if (i == 9)|(i == 21) 
            figure, title(call_id); 
            sp=1;
        end    
        subplot(rows,columns,sp);
        sp=sp+1;
    end
    
    [curves(1,j:j+2), curves(1,j+3)] = msr_curve(all_notes_matrix(1:note_num,i), note_starts(1:note_num), note_ends(1:note_num), time_code, curve_meth, fig_on, var_name);
    
    if i ==1    
        curve_labels = char(strcat(note_labels(i,:),'_a'), strcat(note_labels(i,:),'_b'), strcat(note_labels(i,:),'_c'), strcat(note_labels(i,:),'_res'));
    else
        curve_label_temp = char(strcat(note_labels(i,:),'_a'), strcat(note_labels(i,:),'_b'), strcat(note_labels(i,:),'_c'), strcat(note_labels(i,:),'_res'));
        curve_labels = char(curve_labels, curve_label_temp);
    end
    
    note_num = r;
    
    if fig_on % Label curve drawn by msr_curve
        if (sp<10), xlabel (''), end
        if (i == var_num)
            a = axis;
            x = 1.25*((a(1,2)-a(1,1)) + a(1,1));
            y = (a(1,4) - a(1,3))/2 + a(1,3);
            text(x,y,char(strcat('note number = ', num2str(note_num)), strcat('length = ', num2str(call_length)), strcat('DF = ', num2str(call_DF)), strcat('peak amp = ', num2str(pk_amp)), strcat('RMS amp = ', num2str(rms)))), xlabel('time(sec)'), ylabel('frequency(hz)'); 
        end 
    end
    if fig_on == 2 % Save each figure with a unique name
        if i == 8
            fig_file_name = strcat(call_id, '_A');
            saveas(gcf, fig_file_name, 'jpeg'); end
        if i == 20
            fig_file_name = strcat(call_id, '_B');
            saveas(gcf, fig_file_name, 'jpeg');
            close; end
        if i == 22
            fig_file_name = strcat(call_id, '_C');
            saveas(gcf, fig_file_name, 'jpeg');
            close; end
    end
end

% calculate new values of BW and FM (TTB 3/4/2016)
%---------------------------------------
call_Hz_max = max(all_notes_matrix_AL(:,16));
call_Hz_min = min(all_notes_matrix_AL(:,17));
call_BW_mean = mean(all_notes_matrix_AL(:,16)) - mean(all_notes_matrix_AL(:,17));
call_BW_max = call_Hz_max - call_Hz_min;


% Concatenate data and labels for output
%---------------------------------------
all_notes_matrix = all_notes_matrix_AL;

note_labels = char('note.starts', 'note.ends', 'note.durs', 'INI', 'pk.amps', ...
    'pk.times', 'qpk.amps', 'qpk.times', 'note.rmss', 'rel.pk.amps', 'rel.qpk.amps', ...
    'rel.note.rmss', 'rel.pk.tm', 'rel.qpk.tm', 'rel.INI', 'max.Hz', 'min.Hz', 'FMa', ...
    'FMb', 'FMc', 'FM.resid', 'note.DF', 'arclength');

call_stats = [note_num, call_length, call_DF,...
    entropy, pk_amp, rms, pk_power, curves];

FM_score = FM_total/call_stats(1,2); % divide arcsum by the call_length    
trill_rate = note_num/call_length;
call_stats = [call_stats, trill_rate, FM_total, FM_score, ...
    call_Hz_max, call_Hz_min, call_BW_mean, call_BW_max];

Hz_FM_labels = char('trill_rate','FM_total', 'FM_score', ...
    'call_Hz_max', 'call_Hz_min', 'call_BW_mean', 'call_BW_max');

call_stat_labels = char('note_num', 'call_length', 'call_DF', ...
    'entropy', 'pk_amp', 'rms', 'pk_power');
call_stat_labels = char(call_stat_labels, curve_labels, Hz_FM_labels); % added on the curve labels and new HZ, FM labels


