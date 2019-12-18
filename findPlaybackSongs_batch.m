function [startOutputs,startOutputs_labels] = findPlaybackSongs_batch(csvFile,samp_freq,timestamp,filtered)

%This is a batch processing file intended to identify song content from a
%list of files input from a CSV. Your CSV should be a single list of names
%of song files. csvFile = the name of your file. 


%if you enter fewer than five arguments, default = you've already filtered
%the songs using rx8Filter. If you haven't run rx8Filter on the recording
%yet, I recommend inputting 'n' for this argument. It will increase the
%runtime and resources but will also make identifying songs much easier and
%more effective.
if nargin <4
    filtered = 'y';
end

%if you enter fewer than five arguments, default = your song file doesn't
%include a timestamp in it. The recording software automatically appends
%the number of minutes running and the time at which the file was created
%to the name of any file it makes. If your file ends with something like
%[number which is a multiple of 60 + 1]_HH_MM_SS.F32, you may want to
%enable this option by including 'y' in your file. The default is that the
%file will not use this and will assume your file is named
%[something]_playback.F32, and it will trim off that _playback.F32 ending
%and use the rest as an identifier for the pieces it grabs and outputs.
%This is primarily used so that when you take these later to go back over
%the 48h pre-playback recordings, you know exactly which hour-long files to
%pull each recorded song out of. 
if nargin<3
    timestamp = 'n';
end

%threshold = the number of standard deviations in the overall recording
%file to count beyond the mean in order to identify a song. 8 should be
%more than sufficient, but if you need to vary this, it's here.
% if nargin<3
%     threshold = 8;
% end

%If you're working with RX6 data, you'll want your sampling frequency to be
%different. The default for this routine is to use the maximum sampling
%frequency of the RX8.
if nargin<2
    samp_freq = 195312.5/2;
end

%--------------

outFile = '/scratch/02985/emg2497/leptinIEG/batchOutputs/';
fileList = csvimport(csvFile);
diaryFile = strcat(outFile,'diary.txt');
diary diaryFile;

%call write_playbackSongs while you're at it once you've got the output file,
%really....

for i=1:length(fileList)
    fileList(i)
    [outputTable,~,song] = findPlaybackSongs(fileList{i},samp_freq,timestamp,filtered); 
    if isempty(outputTable) == 1
        continue
    end
    write_playbackSongs(outputTable,song,outFile);
    tableName = strcat(outFile,outputTable{1,1},'_',string(i),'_songTimes.csv');
    writecell(outputTable,tableName); %this routine works best for writing structured matrices to csvs
end

diary off;