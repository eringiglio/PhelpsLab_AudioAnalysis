function[timeList] = checkPlaybacks(hourRecording,csvFile,samp_freq)

% This function exists in order to take a csv list of times at which a
% stimulus was output and create a set of 20 30sec slices of each,
% displayed 10sec before and 20sec after the stimulus playout time was
% recorded. 

%EMG, 7/18/19

% define default sample frequency
if nargin<3
    samp_freq = 195312.5/2;
end

raw = csvimport(csvFile);
timeList = raw(2:length(raw),:);

timeSlices = {};

for i=1:length(timeList)
    min = timeList{i,5};
    sec = timeList{i,6};
    thisTime = 60*min + sec;
    thisStart = thisTime - 10;
    thisEnd = thisTime + 20;
    timeSlices{i,1} = thisStart * samp_freq;
    timeSlices{i,2} = thisEnd * samp_freq;
end

%Now I just want to see the specgrams. There are twenty, but from
%experience they don't look great on one plot. So I'm going to instead
%do...
piece = {};
figure
for i=1:10
	thisSong = hourRecording(timeSlices{i,1}:timeSlices{i,2});
    piece{i} = subplot (5, 2, i);
    specgram(thisSong, 512, samp_freq);
    title(char(i),'Interpreter','none')
    caxis([-100 20])
end

figure
for i=11:20
	thisSong = hourRecording(timeSlices{i,1}:timeSlices{i,2});
    piece{i} = subplot (5, 2, i-10);
    specgram(thisSong, 512, samp_freq);
    title(char(i),'Interpreter','none')
    caxis([-100 20])
end
