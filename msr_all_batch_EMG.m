function [call_list, parameters, call_stats, call_stat_labels, note_labels] = msr_all_batch_EMG(xl_file, output_file, range, anal_param, methods)

% [call_list, parameters, call_stats, call_stat_labels, note_labels] = msr_all_batch(xl_file, output_file, range, anal_param, methods)

% Need to be sure file list is single column. Dropped samp_rate from anal_param since it will be in input file.

% Read in list of files
%----------------------

[param_list, call_list] = xlsread(xl_file);

%call_list = call_list(2:num_rows,1); %Note I could choose to save rest of string data and write it to output file below.

[num_calls, c] = size(call_list);
[num_calls2, c2] = size(param_list);

if num_calls ~= num_calls2
    error('Error: file list and parameter list must be of equal lengths.')
end

if c2 ~= 4, error('Error: expecting three columns in parameter file.'), end


% Check inputs and assign defaults
%---------------------------------

if nargin<5
    time_code = 'note';
    curve_meth = 'q';
else
    time_code = methods(1,:);
    curve_meth = methods(2,:);
end

%Note we've also moved threshold out of anal_param and into the excel file. 
if nargin<4
    reset = 1;
    INI_max = 200; 
    fig_on = 0;
else
    reset = anal_param(2,1);
    INI_max = anal_param(3,1); 
    fig_on = anal_param(4,1); %if fig on is 1 or greater, will display fig, if 2, will save it also
end

if nargin<3 
    range = [1, num_calls];
else
    [r,c] = size(range);
    if (r ~= 1) | (c ~= 2)
        error('Error specifying range: must be integer values of form [min max].')
    end
    if (round(range(1,1)) ~= range(1,1)) | (round(range(1,2)) ~= range(1,2))
        error('Error specifying range: must be integer values of form [min max].')
    end
end


% Redefine call and parameter lists to include just those in specified range
%---------------------------------------------------------------------------
file_min = range(1,1);
file_max = range(1,2);

call_list = call_list(file_min:file_max,:); %call_list file should have file list only!
parameters = param_list(file_min:file_max,:);

[num_calls, c] = size(parameters);

if num_calls>10, disp('Figure capability turned off for more than 10 calls.'); fig_on = 0; end


% Open file to write call stats
%------------------------------
fid_call_stats = fopen(output_file, 'a'); % The 'a' specifies the data will be appended to an existing file, or a new one will be created if needed.


% Cycle through list of files, extract call, pass to msr_all, write data to files
%--------------------------------------------------------------------------------
for i =1:num_calls
    
    % Extract specified call from file
    file_name = char(call_list(i,:)); %***
    fid = fopen(file_name,'r');
    
    call_length = parameters(i,1);
    call_position = parameters(i,2);
    samp_rate = parameters(i,3);
    threshold = parameters(i,4);
    
    n = call_position*call_length;
    call = fread(fid, n, 'float32');
    if call_position > 1
            call = call(((call_position-1)*call_length + 1):call_position*call_length);
    elseif call_position == 1
        call = call(1:call_length);
    else
        error('Error specifying call position. Should be positive integer size 1 or larger.')
    end
    fclose(fid);
    
    % Define call ID
    call_id_temp = deblank(char(call_list(i,:)));
    [r,c] = size(call_id_temp);
    
    if (call_id_temp(1,c-3:c) == '.F32')
        call_id_temp = call_id_temp(1,1:c-4);
        
    elseif (call_id_temp(1,c-3:c) == '.f32')
        call_id_temp = call_id_temp(1,1:c-4);
    end
    call_id = sprintf('%s_%.0f', call_id_temp, call_position);
    
    % Pass call to msr_all
    [call_stats(i,:), call_stat_labels, all_notes_matrix, note_labels] = msr_all_AL(call, samp_rate, threshold, reset, time_code, curve_meth, INI_max, fig_on, call_id);
    
    % Write call stats to existing file, write note matrix to new file
    %----------------------
    % fprintf(fid_call_stats, '%s \t %g \t', call_id, call_stats(i,:)); %note could easily put sample rate or other parameters here for output file.
    fprintf(fid_call_stats, '\n');
    
    note_file_name = strcat(call_id, '_notemtx.txt');
    dlmwrite(char(note_file_name), all_notes_matrix, '\t');
    
    disp(call_list(i,:));
end

 % fclose(fid_call_stats);

xlswrite('output_file',call_stats);