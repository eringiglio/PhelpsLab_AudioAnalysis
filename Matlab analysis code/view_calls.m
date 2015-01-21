function [calls] = view_calls(file_name, samp_freq, call_length);

    % [calls] = view_calls(file_name, samp_freq, call_length)

    fid = fopen(file_name, 'r');

    if fid == -1
        error('Error: check that path has been set to find appropriate file.')
    end

    calls = fread(fid, 'float32');
    [file_length,c] = size(calls);
    if nargin<3
        num_calls=1;
    else num_calls = floor(file_length/call_length); %floor rounds down, in case the file_length is off.
    end

    if nargin<2
        samp_freq = 195312.5;
    end

    disp(num_calls)
    %-------------------
    % Now plot calls in spectrogram form
    %-------------------
    for i=1:num_calls
        start = (i-1)*(call_length)+1;
        finish = i*call_length;
        if num_calls == 1
            specgram(calls, 512, samp_freq);
        elseif num_calls <= 4
            subplot (4, 1, i), specgram(calls(start:finish), 512, samp_freq);
        elseif num_calls <= 6
            subplot (6, 1, i), specgram(calls(start:finish), 512, samp_freq);
        elseif num_calls <= 8
            subplot (4, 2, i), specgram(calls(start:finish), 512, samp_freq);
        elseif num_calls <= 12
            subplot (6, 2, i), specgram(calls(start:finish), 512, samp_freq);
        end
    end
