function [songStim,toneStim,noiseStim] = make_5song_stim(song1,song2,song3,song4,song5,FileID,samp_freq)

	%defining default sample frequency
	if nargin<7
	samp_freq = 195312.5;
	end

	%reminding you to put in the filename base
	if nargin<5
		print('Error: remember to provide file names for song, tone, and noise, in that order')
	end

	%reminding you to put in all 5 songs
	if nargin<5
		print('Error: remember to put all 5 songs in')
    end
    
    %Fuck, we're gonna want to normalize all of them to 1 individually.
   	%normalize all songs within the raw file to the highest amp maximum
    song1Norm = song1/max(abs(song1));
    song2Norm = song2/max(abs(song2));
    song3Norm = song3/max(abs(song3));
    song4Norm = song4/max(abs(song4));
    song5Norm = song5/max(abs(song5));
    
    %stick all songs end to end
	songsAppend = song1Norm;
	songsAppend(2000001:4000000) = song2Norm;
	songsAppend(4000001:6000000) = song3Norm;
	songsAppend(6000001:8000000) = song4Norm;
	songsAppend(8000001:10000000) = song5Norm;

	songStim = songsAppend;

	%making noises... which are already normalized
	noise1 = make_mouse_noise(song1);
	noise2 = make_mouse_noise(song2);
	noise3 = make_mouse_noise(song3);
	noise4 = make_mouse_noise(song4);
	noise5 = make_mouse_noise(song5);

	noiseAppend = noise1;
	noiseAppend(length(noise1):2000000) = 0;
	noiseAppend(2000001:length(noise2)+2000000) = noise2;
	noiseAppend(length(noise2)+2000000:4000000) = 0;
	noiseAppend(4000001:length(noise3)+4000000) = noise3;
	noiseAppend(length(noise3)+4000000:6000000) = 0;
	noiseAppend(6000001:length(noise4)+6000000) = noise4;
	noiseAppend(length(noise4)+6000000:8000000) = 0;
	noiseAppend(8000001:length(noise5)+8000000) = noise5;
	noiseAppend(length(noise5)+8000000:10000000) = 0;

	noiseStim = noiseAppend;

	%making the tone stimuli
	tone1 = make_mouse_tone(song1);
	tone2 = make_mouse_tone(song2);
	tone3 = make_mouse_tone(song3);
	tone4 = make_mouse_tone(song4);
	tone5 = make_mouse_tone(song5);

	toneStim = tone1;
	toneStim(2000001:4000000) = tone2;
	toneStim(4000001:6000000) = tone3;
	toneStim(6000001:8000000) = tone4;
	toneStim(8000001:10000000) = tone5;

	song_file = FileID + "_SON.f32";
	noise_file = FileID + "_NOS.f32";
	tone_file = FileID + "_TON.f32";

	write_songs(song_file,songStim);
	write_songs(noise_file,noiseStim);
	write_songs(tone_file,toneStim);