function[loudSong,ID] = findRealSong(songA,songB)

% define default sample frequency
if nargin<3
    samp_freq = 195312.5;
end

%read songs
%songA = read_songs(song1,samp_freq);
%songB = read_songs(song2,samp_freq);

%determine which is louder

if max(songA) > max(songB)
    loudSong = songA;
    ID = string(song1);
else
    loudSong = songB;
    ID = string(song2);
end
