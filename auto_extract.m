function [calls_xt] = auto_extract(calls, length, sample_rate, crit)

% function [calls_xt] = auto_extract(calls, length, sample_rate, crit)
%
% This function will take a variable CALLS as input, along with a number
% describing the LENGTH in samples of each recording bin, the SAMPLE_RATE
% and the criterion CRIT for deciding which records actually contain calls.
%
% Default for LENGTH is 2000000, for SAMPLE_RATE is 195312.5, and for 
% CRIT is 10.
%
% The routine uses PWELCH to calculate the power of each frequency in each
% recording bin. It then calculates the power associated with the dominant
% frequency in each recording bin, and takes the maximum from all recording
% bins as a reference. Records which have a dominant frequency with a power
% at least 1/CRIT are considered calls and written to the output variable,
% CALLS_XT.
% 
% May 23, 2007. S. Phelps

if nargin < 4
    crit = 10;
end

if nargin < 3
    sample_rate = 195312.5;
end

if nargin < 2
    length = 2000000;
end

if nargin <1
    error('Error: need at least one input argument.')
end

[file_sz,c] = size(calls);
if (file_sz/length - round(file_sz/length)) ~= 0
    error('Error: call variable must be integer multiple of length.')
end


num_bins = file_sz/length;

% ---------------------

% Calculate power of dominant frequency in each recording bin
j=1;
for i = 1:length:file_sz
    [Pxx, F] = pwelch(calls(i:i+length-1),[],[],[],sample_rate);
    max_Pxx(j) = max(Pxx);
    j=j+1;
end

% Find bins with calls and write them to output variable
j=1;
for i=1:num_bins
    if max_Pxx(i)>0
        if (max(max_Pxx)/max_Pxx(i) <= crit)
            calls_xt(j:j+length-1,1) = calls((i-1)*length+1:i*length,1);
            j = j + length;
        end
    end
end
