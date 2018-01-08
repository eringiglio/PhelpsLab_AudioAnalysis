function [] = choose_stim_options(songList)

%Intended to, when we have more songs than we actually need to construct a sample, create pairmatchable stimuli for all combinations of 5 of those songs, presented in a randomized order. 

%How many songs are in my list?
[r,num_songs] = size(songList);

%Cool, so 