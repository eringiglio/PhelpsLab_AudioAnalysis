function [T_tone_Pxx,T_nos_Pxx,T1_Pxx,T2_Pxx,T3_Pxx,T4_Pxx, X_tone_Pxx,X_nos_Pxx,X1_Pxx,X2_Pxx,X3_Pxx,X4_Pxx, T_tone_SNR,T_nos_SNR,T1_SNR,T2_SNR,T3_SNR,T4_SNR, X_tone_SNR,X_nos_SNR,X1_SNR,X2_SNR,X3_SNR,X4_SNR, Noise_Pxx, stim_labels, F] = SNR_batch(xl_file, outfile, distances, site_num)

% function [T_Pxx, X_Pxx, T_SNR, X_SNR, Noise_Pxx, stim_labels, F] =
% SNR_batch(xlfile, outfile, distances, site_num)
%

% Read in list of files
%-----------------------
[num_values, file_list] = xlsread(xl_file);

% Check inputs and assign defaults
%---------------------------------
if nargin<3
    distances = [0.5; 1.0; 5; 10; 15; 20];
end

[num_rows, c] = size(file_list);
[num_dist, c] = size(distances);
num_sites = num_rows/num_dist;

if nargin<4
    site_num = num_sites;
end

if num_sites ~= site_num
    error('Error: the number of sites x number of distances must equal the number of files.')
end

if nargin<2, error('Error: must specify both input and output files.'), end


for i=1:site_num
    for j=1:num_dist
        % Determine file name
        file_posn = (i-1)*num_dist + j;
        file_name = char(file_list(file_posn,:));
        
        % Pass file to rnage_SNR to measure variables
        [T_Pxx, X_Pxx, T_SNR, X_SNR, Nos_Pxx, stim_labels, F] = range_SNR(file_name);
        
        % Reorganize variables to group by site and distance
        T_tone_Pxx(:,j,i) = T_Pxx(:,1);
        T_nos_Pxx(:,j,i) = T_Pxx(:,2);
        T1_Pxx(:,j,i) = T_Pxx(:,3);
        T2_Pxx(:,j,i) = T_Pxx(:,4);
        T3_Pxx(:,j,i) = T_Pxx(:,5);
        T4_Pxx(:,j,i) = T_Pxx(:,6);
        X_tone_Pxx(:,j,i) = X_Pxx(:,1);
        X_nos_Pxx(:,j,i) = X_Pxx(:,2);
        X1_Pxx(:,j,i) = X_Pxx(:,3);
        X2_Pxx(:,j,i) = X_Pxx(:,4);
        X3_Pxx(:,j,i) = X_Pxx(:,5);
        X4_Pxx(:,j,i) = X_Pxx(:,6);
        
        T_tone_SNR(:,j,i) = T_SNR(:,1);
        T_nos_SNR(:,j,i) = T_SNR(:,2);
        T1_SNR(:,j,i) = T_SNR(:,3);
        T2_SNR(:,j,i) = T_SNR(:,4);
        T3_SNR(:,j,i) = T_SNR(:,5);
        T4_SNR(:,j,i) = T_SNR(:,6);
        X_tone_SNR(:,j,i) = X_SNR(:,1);
        X_nos_SNR(:,j,i) = X_SNR(:,2);
        X1_SNR(:,j,i) = X_SNR(:,3);
        X2_SNR(:,j,i) = X_SNR(:,4);
        X3_SNR(:,j,i) = X_SNR(:,5);
        X4_SNR(:,j,i) = X_SNR(:,6);
        
        Noise_Pxx(:,j,i) = Nos_Pxx;
    end
end

