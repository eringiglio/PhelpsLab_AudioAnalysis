%% Script to automatically detect S.teg Songs from continuous recordings
% and find the starts and stops of individual songs. I'm not interested in
% paired recordings, so this code will be designed according to the needs
% of someone working with a single recording. I also want outputs of: all
% timestamps of songs produced, plus small files of each song for ease of
% later analysis. 
% Erin Giglio, May 2019.
% 

%% Initializations
% Change these default values if needed
clear;clc;close all;
filePath = '/scratch/02985/emg2497/leptinIEG/raw_recordings/4-03-19/'; % Date path
outPath = '/scratch/02985/emg2497/leptinIEG/trimmedSongs/';
f_group = dir([filePath '4-01_ch3*.F32']);
indName = "M883_";
[~,idx] = sort([f_group.datenum]);

nFiles = length(f_group);
Fs = 195312.5/2;% original sampling rate
FsN = 1000;% new sampling  rate
lowF = 15e3;highF = 40e3;%range of syllable frequency
syllSmooth = .01;%smoothing of syllables, in seconds
[a,b] = rat(Fs/FsN);%ratio of sampling rates
gap_thr = 0.5*FsN; % sec (2 vocalizations separated by gap_thr is treated as 2 separate songs)
% 
bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
          'CutoffFrequency1',lowF,'CutoffFrequency2',highF, ...
          'SampleRate',Fs);
%      
signal_thr_ch1 = 5e-4; % To be adjusted empirically depending upon background noise of recordings

Times = struct('Name',[],'Starts',[],'Stops',[]);

for f = 1:nFiles % In original config, each file is an hour
    tic
    f_group(idx(f)).name
    fid_ch1 = fopen([filePath f_group(idx(f)).name],'r');

    [ch1Raw, c1] = fread(fid_ch1,'float32');
    
    fclose('all');
    
    dataOutCh1 = filtfilt(bpFilt,ch1Raw);

    dsCh1= resample(dataOutCh1.^2,b,a);%downsample but include FIR filter (better than smooth-->decimate fcn)
    
    tMouse = dsCh1>signal_thr_ch1;
   
    Times(f).Name = [filePath f_group(idx(f)).name];
    
    t = find(tMouse == 1);
    if (~isempty(t))
        
        [temp_starts, temp_stops] =  findStartStops(t,gap_thr);
        song_idx = (temp_stops - temp_starts)> gap_thr;
        
        fin_starts = round(temp_starts*(Fs/FsN));
        fin_stops = round(temp_stops*(Fs/FsN));
        
        Times(f).Starts = fin_starts(song_idx);
        Times(f).Stops = fin_stops(song_idx);
    else
        Times(f).Starts = NaN;
        Times(f).Stops = NaN;
    end
    
    for thisSong = 1:length(fin_starts)
        thisStart = fin_starts(thisSong);
        thisStop = fin_stops(thisSong);
        begIndex = thisStart - 100000;
        endIndex = max(3000000+begIndex,thisStop);
        if endIndex > 360000000
            begIndex = 360000000-2999999;
            endIndex = 360000000;
        elseif begIndex < 1
            begIndex = 1;
            endIndex = 30000000;
        end
        chunk = ch1Raw(begIndex:endIndex);
        filtChunk = rx8Filter(chunk);
        nameRoot = string(regexp(f_group(idx(f)).name,'(?<=_ch\d_).+(?=\.F32)','match'));
        thisName = strcat(indName,nameRoot,'_',string(thisSong),'.F32');
        write_songs(thisName,filtChunk);
    end
    
    toc
    close all;
end
Params = struct('Fs',[],'FsN',[],'lowF',[],'highF',[],'syllSmooth',[], ...
    'signal_thr',[],'gap_thr',[]);
Params.Fs = Fs; Params.FsN = FsN; Params.lowF = lowF; Params.highF = highF;
Params.syllSmooth = syllSmooth; Params.signal_thr = signal_thr_ch1;
Params.gap_thr = gap_thr;

jsonName = strcat(indName, '.txt');
jsonOut = jsonencode(Times);

fid = fopen(jsonName,'w');
fwrite(fid,jsonOut);
close all;