function[filtered_song] = filter_songs(song,hi_freq,lo_freq,samp_freq)

%This fuction kind of sucks. Try Tracys BUTTFIL function instead, it works better.

% define default sample frequency
if nargin<4                
    samp_freq = 195312.5;
end

% define default hi and lo frequencies of the bandpass
if nargin<3
    lo_freq = 200;
end

if nargin<2
    hi_freq = 7800;
end

wnHi = hi_freq/(samp_freq/2);
wnLo = lo_freq/(samp_freq/2);

[b,a] = butter(2,[wnLo,wnHi]);

filtered_song = filter(b,a,song);