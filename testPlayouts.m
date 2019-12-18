  % Two-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

close all; clear all; clc;
%------------------------------------------------------------------------------------------------------
% USER DEFINED PARAM BLOCK
% filePath - set this to wherever the examples are stored
%filePath = 'C:\Documents and Settings\LongLab\My Documents\Mouse Experiments\';
filePath = 'C:\Users\Biosci\Desktop\Erin\IEG\raw_outputs\12-04-19\T';
dataPath= filePath;
diary 'C:\Users\Biosci\Desktop\Erin\IEG\raw_outputs\12-04-19\diary.txt'; % saving command window outputs for debugging later
%'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170707\';   
RP = TDTRP('C:\Users\Biosci\Desktop\Github\RPvdsEx_Code\1Ch_RX8_indTriggerEMG.rcx','RX8','INTERFACE','GB');
RecordingDur = 5; %*60; 
% User defined time in multiples of buffersize set in RPvdsEX program.
% default buffer size is 1 minute@100k samples/s(see RPvdsEXprogram for details)
FileSeperator = 60; % 60; %% In these many full_buffer_lengths create a new file
%-------------------------------------------------------------------------------------------------------
   
%Set up the playout systems
time_fire_test();

% size of the entire serial buffer
npts = RP.GetTagSize('4dataout');  %% Buffersize is set to 1 min currently.

% serial buffer will be divided into two buffers A & B
fs = RP.GetSFreq();
bufpts = npts/2; 
t=(1:bufpts)/fs;
    
% begin acquiring
RP.SoftTrg(1);
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);
tooSlowCount=0;

filePath4 = strcat(filePath, '.F32');
f_ch4 = fopen(filePath4,'w');        
% main looping section
for i = 1:RecordingDur
    if (mod(i,FileSeperator) == 1)
        fclose(f_ch4);
        filePath4 = strcat(dataPath, datestr(now,'_HH_MM_SS'), '.F32');
        f_ch4 = fopen(filePath4,'w');
    end

    % wait until done writing A
    while(curindex < bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end
    
    % read segment A
    audio_ch4 = RP.ReadTagVEX('4dataout', 0, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch4, audio_ch4, 'float32')) ' points to file']);

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
    audio_ch4 = RP.ReadTagVEX('4dataout', bufpts, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch4, audio_ch4, 'float32')) ' points to file']);

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

fclose(f_ch4);

tooSlowCount
% stop acquiring
RP.SoftTrg(2);
RP.Halt;

% plots the last npts data points
%view_modified_songs(audio_ch4(1:3000000),fs);