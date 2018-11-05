% Two-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

close all; clear all; clc;
%------------------------------------------------------------------------------------------------------
% USER DEFINED PARAM BLOCK
% filePath - set this to wherever the examples are stored
%filePath = 'C:\Documents and Settings\LongLab\My Documents\Mouse Experiments\';
filePath = 'C:\Users\Biosci\Desktop\LongLabPlayoutTests\Outputs\liveTest';
dataPath= filePath;
%dataPath = 'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170624\';
%dataPath = 'S:\Archive\Daniel\MouseSong\RawData\M024\Playback\MATLAB\170707\';
RP = TDTRP('C:\Users\Biosci\Documents\sound chamber TDT\RX8_Continuous_AcquireEMG.rcx','RX8','INTERFACE','GB');
RecordingDur = 4*24*60; 
% User defined time in multiples of buffersize set in RPvdsEX program.
% default buffer size is 1 minute@100k samples/s(see RPvdsEXprogram for details)
FileSeperator = 60; %% In these many full_buffer_lengths create a new file
%-------------------------------------------------------------------------------------------------------

diary('C:\Users\Biosci\Desktop\LongLabPlayoutTests\Outputs\error.txt');
% size of the entire serial buffer
npts = RP.GetTagSize('Ldataout');  %% Buffersize is set to 1 min currently.

% serial buffer will be divided into two buffers A & B
fs = RP.GetSFreq();
bufpts = npts/2; 
t=(1:bufpts)/fs;
    
% begin acquiring
RP.SoftTrg(1);
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);
tooSlowCount=0;

filePath1 = strcat(filePath, 'ch1_test', '.F32');
filePath2 = strcat(filePath, 'ch2_test', '.F32');
f_ch1 = fopen(filePath1,'w');
f_ch2 = fopen(filePath2,'w');
        
% main looping section
for i = 1:RecordingDur
    if (mod(i,FileSeperator) == 1)
        fclose(f_ch1);
        fclose(f_ch2);
        filePath1 = strcat(dataPath, 'ch1_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        filePath2 = strcat(dataPath, 'ch2_',num2str(i),datestr(now,'_HH_MM_SS'), '.F32');
        f_ch1 = fopen(filePath1,'w');
        f_ch2 = fopen(filePath2,'w');
    end

    % wait until done writing A
    while(curindex < bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end
    
    % read segment A
    audio_ch1 = RP.ReadTagVEX('Ldataout', 0, bufpts, 'F32', 'F32', 1);
    audio_ch2 = RP.ReadTagVEX('Rdataout', 0, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch1, audio_ch1, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch2, audio_ch2, 'float32')) ' points to file']);

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
    audio_ch1 = RP.ReadTagVEX('Ldataout', bufpts, bufpts, 'F32', 'F32', 1);
    audio_ch2 = RP.ReadTagVEX('Rdataout', bufpts, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(f_ch1, audio_ch1, 'float32')) ' points to file']);
    disp(['Wrote ' num2str(fwrite(f_ch2, audio_ch2, 'float32')) ' points to file']);

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

fclose(f_ch1);
fclose(f_ch2);

tooSlowCount
% stop acquiring
RP.SoftTrg(2);
RP.Halt;

% plots the last npts data points
subplot(2,1,1)
plot(t,audio_ch1);
axis tight;
subplot(2,1,2)
plot(t,audio_ch2);
axis tight;