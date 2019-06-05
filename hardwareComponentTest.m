% one-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)
% Intended for use with a single clear chamber setup in order to test each
% piece of equipment as cycled through

close all; clear all; clc;
%------------------------------------------------------------------------------------------------------
% USER DEFINED PARAM BLOCK
% filePath - set this to wherever the examples are stored, alter with each
% run and each piece of equipment tested with this format: m#g#b#a#, where
% m is the number of each microphone, g is the number of the gooseneck amp,
% b is the number of the barrel amp in use, and a is the number of the
% white amp. Each setup should therefore get a unique four-digit number. 
% Known good barrel amp: 2. 
%filePath = 'C:\Documents and Settings\LongLab\My Documents\Mouse Experiments\';

%csvs of times for timers specifying (here) when to play song (A) vs tone (B) stimuli
timerA = 'C:\Users\Biosci\Desktop\Erin\IEG\exampleTrigger.csv';

filePath = 'C:\Users\Biosci\Desktop\Erin\StimuliTests\6-03_5';
dataPath= filePath;
%dataPath = 'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170624\';
%dataPath = 'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170707\';
RP = TDTRP('C:\Users\Biosci\Desktop\Github\RPvdsEx_Code\RX8 code\hardwareTest_EMG.rcx','RX8','INTERFACE','GB');
RecordingDur = 1*1*10; 
% User defined time in multiples of buffersize set in RPvdsEX program.
% default buffer size is 1 minute@100k samples/s(see RPvdsEXprogram for details)
FileSeperator = 60; %% In these many full_buffer_lengths create a new file
%-------------------------------------------------------------------------------------------------------

% size of the entire serial buffer
npts = RP.GetTagSize('3dataout');  %% Buffersize is set to 1 min currently.

% serial buffer will be divided into two buffers A & B
fs = RP.GetSFreq();
bufpts = npts/2; 
t=(1:bufpts)/fs;
    
% begin acquiring
RP.SoftTrg(1);
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);
tooSlowCount=0;

filePath3 = strcat(filePath, '.F32');
f_ch3 = fopen(filePath3,'w');

%Set up timers for recording at specified intervals

%triggering timers
zBUS = time_fire_batch(timerA,'A',3);

% main looping section
for i = 1:RecordingDur
    if (mod(i,FileSeperator) == 1)
        fclose(f_ch3);
        f_ch3 = fopen(filePath3,'w');
    end

    % wait until done writing A
    while(curindex < bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end
    
    % read segment A
    audio_ch3 = RP.ReadTagVEX('3dataout', 0, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch3, audio_ch3, 'float32')) ' points to file']);

    % checks to see if the data transfer rate is fast enough
    curindex = RP.GetTagVal('index');
    disp(['Current buffer index: ' num2str(curindex)]);
    if(curindex < bufpts)
        warning('Transfer rate is too slow');
        tooSlowCount=tooSlowCount+1;
    end

    % wait until start writing A 
    while(curindex > bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end

    % read segment B
    audio_ch3 = RP.ReadTagVEX('3dataout', bufpts, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch3, audio_ch3, 'float32')) ' points to file']);

    % make sure we're still playing A 
    curindex = RP.GetTagVal('index');
    disp(['Current index: ' num2str(curindex)]);
    if(curindex > bufpts)
        warning('Transfer rate too slow');
        tooSlowCount=tooSlowCount+1;
    end
    clc;
    i
end

fclose(f_ch3);

tooSlowCount
% stop acquiring
RP.SoftTrg(2);
RP.Halt;