function[song] = listen_to_song(file_name, wav_file_name, samp_rate)

% define default sample frequency--if you don't put it in on your own, it
% defaults to this
if nargin<3
    samp_rate = 195312;
end

song = read_songs(file_name, samp_rate);

% This is necessary because audiowrite (below) will only accept values in
% the range of -1 to 1, so we correct the song data to match
correction = max(abs(song));
song_corrected = song/correction;

%Should probably scale the frequencies down so I can actually hear them.
%How much did Bret do?
scaled_samp_rate = round(samp_rate/5);

audiowrite(wav_file_name, song_corrected, scaled_samp_rate);