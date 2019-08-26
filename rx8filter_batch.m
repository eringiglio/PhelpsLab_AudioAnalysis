function [startOutputs,startOutputs_labels] = rx8filter_batch(folderName)

%This is a batch processing file intended to take a folder and
%automatically run all files in that folder through rx8Filter.

% EMG, 8/25/19.

inFolder = strcat('/scratch/02985/emg2497/leptinIEG/raw_recordings/',folderName);
outFolder = strcat('/scratch/02985/emg2497/leptinIEG/filtered_recordings/',folderName);

filesToRun = dir(strcat(inFolder,'/*.F32'));

for i=1:length(filesToRun)
    filesToRun(i).name
    thisFile = strcat(filesToRun(i).folder, '/', filesToRun(i).name);
    outFile = strcat(outFolder,filesToRun(i).name);
    song = read_songs(thisFile);
    filtered_song = rx8Filter(song);
    write_songs(outFile,filtered_song);
end