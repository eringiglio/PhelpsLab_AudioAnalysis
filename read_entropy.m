function [H, X, spectro_matrix] = read_entropy(song, samp_freq)

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

%getting a spectrogram to work with; taking the absolute value while we're
%at it because that will work more efficiently with entropy and remove
%imaginary numbers
spectro_matrix = abs(specgram(song, 512, samp_freq));

%defining functions
[r,c] = size(spectro_matrix); 

for i = 1:c
    %H(1,i) = entropy(spectro_matrix(:,i));
    for j=1:r
        cell_temp(j,1) = spectro_matrix(j,i)/sum(spectro_matrix(:,i));
    end
    H(i,1) = -sum(cell_temp.*log(cell_temp));
    
    X(i,1) = (0.5*(512/samp_freq)) * i;
end