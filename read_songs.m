function [songs] = read_songs(file_name, samp_freq, num_songs)

fid = fopen(file_name, 'r');

if fid == -1
      error('Error: check that path has been set to find appropriate file.')
end

songs = fread(fid, 'float32');
[file_length,c] = size(songs);

fclose(fid);

% define default number of bins in the sample (number of songs = bins)
if nargin<3                
    num_songs=1;
end

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

song_length = floor(file_length/num_songs);