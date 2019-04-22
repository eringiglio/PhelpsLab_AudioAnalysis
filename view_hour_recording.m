function [song,songList] = view_hour_recording(song,samp_freq)

if nargin <2
    samp_freq = 195312.5/2;
end

% raw = read_songs(file_name,samp_freq);
%
% song = BUTTfil(raw);

chnk1 = song(1:60000000);
chnk2 = song(60000001:120000000);
chnk3 = song(120000001:180000000);
chnk4 = song(180000001:240000000);
chnk5 = song(240000001:300000000);
chnk6 = song(300000001:360000000);

songList = [chnk1,chnk2,chnk3,chnk4,chnk5,chnk6];

for i=1:6
	thisSong = songList(:,i);
    subplot (6, 1, i), specgram_to_spectrogram(thisSong, 512, samp_freq);
end
caxis([-100 20])

figure
for i=1:6
    thisSong = songList(:,i);
    subplot (6, 1, i), oscillogram(thisSong, samp_freq);
end
