function [newStim] = convertFile(oldFile)

%Just a wrapper to convert many new stimuli from the RX6 maximal sampling
%rate of 195312.5 to the RX8 maximal rate of 97656.25. Requires downsample,
%view_songs, and write_songs as dependencies. 

stim = read_songs(oldFile,195312.5);

newStim = downsample(stim,97656.25,195312.5);

newFileName = strcat('C:\Users\Biosci\Documents\sound chamber TDT\RX8_stimuli\5_stim\',oldFile);

write_songs(newFileName,newStim);