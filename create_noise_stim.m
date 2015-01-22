function[noise] = create_noise_stim(file_name, song_file)

%This just automates using mouse_noise_filter to create and name new songs,
%given an input and an output. 

song = read_songs(song_file);

noise = mouse_noise_filter(song);

write_songs(file_name,noise);