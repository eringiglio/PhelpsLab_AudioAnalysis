function [song,songList] = view_hour_recording(song,samp_freq)

if nargin <2
    samp_freq = 195312.5/2;
end

%song = read_songs(file_name,samp_freq);
%
chnk1 = song(1:60000000);
chnk2 = song(60000001:120000000);
chnk3 = song(120000001:180000000);
chnk4 = song(180000001:240000000);
chnk5 = song(240000001:300000000);
chnk6 = song(300000001:360000000);

songList = [chnk1,chnk2,chnk3,chnk4,chnk5,chnk6];

fig1 = {};
figure
for i=1:6
	thisSong = songList(:,i);
    fig1{i} = subplot (6, 1, i);
    specgram(thisSong, 512, samp_freq);
    caxis([-100 20])
end

fig2 = {};
figure
for i=1:6
    thisSong = songList(:,i);
    fig2{i} = subplot (6, 1, i);
    oscillogram(thisSong, samp_freq);
end
linkaxes([fig2{1},fig2{2},fig2{3},fig2{4},fig2{5},fig2{6}],'y')

