% Two-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

close all; clear all; clc;
%------------------------------------------------------------------------------------------------------
% USER DEFINED PARAM BLOCK
% filePath - set this to wherever the examples are stored
%filePath = 'C:\Documents and Settings\LongLab\My Documents\Mouse Experiments\';
timerList = 'C:\Users\Biosci\Desktop\David\AR_IEG\timer_files\12-6-19.csv';
filePath = 'C:\Users\Biosci\Desktop\David\AR_IEG\raw_outputs\12-6-19\12-5-19_';
dataPath= filePath;
diary 'C:\Users\Biosci\Desktop\David\AR_IEG\raw_outputs\12-6-19\diary.txt'; % saving command window outputs for debugging later
%dataPath = 'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170624\';
%dataPath =
%'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170707\';   
RP = TDTRP('C:\Users\Biosci\Documents\sound chamber TDT\4Ch_RX8_djz.rcx','RX8','INTERFACE','GB');
RecordingDur = 44*60; 
% User defined time in multiples of buffersize set in RPvdsEX program.
% default buffer size is 1 minute@100k samples/s(see RPvdsEXprogram for details)
FileSeperator = 60; %% In these many full_buffer_lengths create a new file
%-------------------------------------------------------------------------------------------------------
   
%Set up the playout systems
zBUS = time_fire_batch(timerList);

% size of the entire serial buffer
npts = RP.GetTagSize('3dataout');  %% Buffersize is set to 1 min currently.

% serial buffer will be divided into two buffers A &                             B
fs = RP.GetSFreq();
bufpts = npts/2; 
t=(1:bufpts)/fs;
    
% begin acquiring
RP.SoftTrg(1);
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);
tooSlowCount=0;

filePath3 = strcat(filePath, 'ch3_test', '.F32');
filePath4 = strcat(filePath, 'ch4_test', '.F32');
filePath5 = strcat(filePath, 'ch5_test', '.F32');
filePath6 = strcat(filePath, 'ch6_test', '.F32');
f_ch3 = fopen(filePath3,'w');
f_ch4 = fopen(filePath4,'w');
f_ch5 = fopen(filePath5,'w');
f_ch6 = fopen(filePath6,'w');
        
% main looping section
for i = 1:RecordingDur
    if (mod(i,FileSeperator) == 1)
        fclose(f_ch3);
        fclose(f_ch4);
        fclose(f_ch5);
        fclose(f_ch6);
        filePath3 = strcat(dataPath, 'ch3_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        filePath4 = strcat(dataPath, 'ch4_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        filePath5 = strcat(dataPath, 'ch5_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        filePath6 = strcat(dataPath, 'ch6_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        f_ch3 = fopen(filePath3,'w');
        f_ch4 = fopen(filePath4,'w');
        f_ch5 = fopen(filePath5,'w');
        f_ch6 = fopen(filePath6,'w');
    end

    % wait until done writing A
    while(curindex < bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end
    
    % read segment A
    audio_ch3 = RP.ReadTagVEX('3dataout', 0, bufpts, 'F32', 'F32', 1);
    audio_ch4 = RP.ReadTagVEX('4dataout', 0, bufpts, 'F32', 'F32', 1);
    audio_ch5 = RP.ReadTagVEX('5dataout', 0, bufpts, 'F32', 'F32', 1);
    audio_ch6 = RP.ReadTagVEX('6dataout', 0, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch3, audio_ch3, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch4, audio_ch4, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch5, audio_ch5, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch6, audio_ch6, 'float32')) ' points to file']);

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
    audio_ch4 = RP.ReadTagVEX('4dataout', bufpts, bufpts, 'F32', 'F32', 1);
    audio_ch5 = RP.ReadTagVEX('5dataout', bufpts, bufpts, 'F32', 'F32', 1);
    audio_ch6 = RP.ReadTagVEX('6dataout', bufpts, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch3, audio_ch3, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch4, audio_ch4, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch5, audio_ch5, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch6, audio_ch6, 'float32')) ' points to file']);

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
fclose(f_ch4);
fclose(f_ch5);
fclose(f_ch6);

tooSlowCount
% stop acquiring
RP.SoftTrg(2);
RP.Halt;

% plots the last npts data points
subplot(2,2,1)
plot(t,audio_ch3);
axis tight;
subplot(2,2,2)
plot(t,audio_ch4);
axis tight;
subplot(2,2,3)
plot(t,audio_ch5);
axis tight;
subplot(2,2,4)
plot(t,audio_ch6);
axis tight;