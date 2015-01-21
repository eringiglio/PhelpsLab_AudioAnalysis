function [songs] = load_songs(filename, num_songs, samp_rate)
% [songs] = load_songs(filename, num_songs, samp_rate)

if nargin<3, samp_rate = 195312.5; end
if nargin<2, num_songs = 1; end

fid = fopen(filename, 'r');
songs = fread(fid, 'float32');
[r,c] = size(songs);

rec_window = floor(r/num_songs);

for i=1:num_songs
    first = (i-1)*rec_window + 1;
    last = i*rec_window;
    if num_songs <5
        subplot(num_songs, 1, i), spectrogram(songs(first:last), 512, 256, [], samp_rate, 'yaxis');
    elseif num_songs <6
        subplot(3, 2, i), spectrogram(songs(first:last), 512, 256, [], samp_rate, 'yaxis');
    end
end
