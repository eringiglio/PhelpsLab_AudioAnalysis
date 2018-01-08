function auto_extract_and_write(file_list, lengths, sample_rate, crit)

% function auto_extract_and_write(file_list, lengths, sample_rate, crit)
% 
% This function takes a list of files and the call lengths associated with each and
% extracts the recording bins that have calls in them. The trimmed records are written
% to a new file that has the same name as the original, with the suffix '_xt' added.
%
% May 23, 2007. S. Phelps

% Define defaults
if nargin < 4
    crit = 100;
end

if nargin < 3 %This version assumes only one sample rate, but it would simple to make it apply to all.
    sample_rate = 195312.5;
end

[file_num, c] = size(file_list);
if nargin < 2
    lengths = 2000000*ones(file_num,1);
end

if nargin < 1
    error('Error: need at least one input argument.')
end


for i = 1:file_num
    call_xt = 0;
    file_name = deblank(char(file_list(i,:)));
    fid = fopen(file_name, 'r');
    
    if fid == -1
        error('Error: check that path has been set to find appropriate file.')
        error(['Cannot find file ' char(file_name(i)) '.'])
    end
    
    calls = fread(fid, 'float32'); %Note assumes input files are 32 bit floating point numbers
    fclose(fid);
    
    call_xt = auto_extract(calls, lengths(i), sample_rate, crit);
    
    [r,num_char] = size(file_name); %Check to see if name has 'F32' suffix
    if num_char>3
        if file_name(1,num_char-3:num_char) == '.F32'
            xt_name = [file_name(1,1:num_char-4) '_xt.F32']
        else
            xt_name = [file_name '_xt.F32']
        end
    else xt_name = [file_name '_xt.F32']
    end
    
    if call_xt
        fid = fopen(xt_name, 'w');
        fwrite(fid, call_xt, 'float32');
        fclose(fid);
    end
end