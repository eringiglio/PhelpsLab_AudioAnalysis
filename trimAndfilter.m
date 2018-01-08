function[final_song] = trimAndFilter(song,binNumber,indexStart,indexEnd)

%Look, if you want to use this for RX8 songs, just bloody make a new version with a different sampling rate. It's a pain to specify samp_freq otherwise.
samp_freq = 195312.5;

% If you don't want to enter bin lengths manually, don't bother yourself with it
if nargin<4
    indexEnd = 2000000;
end

% define default sample frequency
if nargin<3
    indexStart = 1;
end

%use the bin numbers, dammit. if you don't want to use the bin numbers and want manual shit, put in literally any other number there.
if binNumber == 1
	indStart = 1;
	indEnd = 2000000;
elseif binNumber == 2
	indStart = 2000001;
	indEnd = 4000000;
elseif binNumber == 3;
	indStart = 4000001;
	indEnd = 6000000;
else
	indStart = indexStart;
	indEnd = indexEnd;
end

%trim down the field to just the bin with the song
trimmed_song = song(indStart:indEnd);

%filter the trimmed song itself
song_filtered = BUTTfil(trimmed_song);

%fix the amplitude
maxPeak = max(abs(song_filtered));
ampfix = song_filtered/maxPeak;

final_song = view_modified_songs(ampfix);