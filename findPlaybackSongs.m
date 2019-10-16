function [startOutputs,startOutputs_labels,song] = findPlaybackSongs(fileName,samp_freq,timestamp,filtered)

%This function exists to help me find the beginnings of all songs within a
%60-min recording of a single singing mouse, complete with playbacks. Song
%files should have names in the format DATE_CHAMBER_RECORD_TIME, as in
%'6-10_ch6_2641_10_11_34.F32', or else enter 'n' for parameter timestamp.
% - EMG, 7/5/19.

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

%If you haven't yet filtered the recording, this routine will filter it for
%you. I recommend only doing this, as opposed to filtering all recordings
%ahead of time, if you're running a whole bunch of files on a cluster
%machine. If the recording has been filtered already (default), it just
%reads the song from the filename.
if filtered == 'y'
    song = read_songs(fileName);
elseif filtered == 'n'
    rawsong = read_songs(fileName);
    song = rx8Filter(rawsong);
else
    error("please enter a value of 'yes' or 'no' for the 'filtered' parameter")
end

%Again, if the timestamp is part of your file name, this routine will
%actually take the time the file started and use it to create the actual
%time of day at which the song was created. If it's not, it will just go
%from 0. Default is that the timestamp is not part of the file name because
%I tweak all my playback files into one 1-hr recording before processing,
%but in batch runs I highly recommend using this feature. 
if timestamp == 'y'
    fin = length(fileName);
    sequence = fileName(1:fin-13);
    hour = str2num(fileName(fin-11:fin-10));
    min = str2num(fileName(fin-8:fin-7));
    sec = str2num(fileName(fin-5:fin-4));
elseif timestamp == 'n'
    fin = length(fileName);
    sequence = fileName(1:fin-15);
    hour = 0;
    min = 0;
    sec = 0;
else
    error("please enter a value of 'yes' or 'no' for the 'timestamp' parameter")
end

startOutputs_labels = char('idSequence','h','m','s','sample');

%This downsamples the song to about 100x as few samples as it originally
%had. This really, REALLY saves processing time and has the advantage of
%lumping all the energy within the song and smearing it across a whole
%bunch of frequencies.
dsSong = downsampleSMP(song,1000,samp_freq);

%We are going to use the spectrograms to identify songs, not the actual
%.f32 recording as Steve has traditionally done. This is be much less
%computationally expensive and way faster.
dsSpectro = specgram(dsSong, 512, 1000);

%Here we're taking the absolute value of everything on that spectrogram
%(since much of it is complex numbers and frankly, the hell with dealing
%with that) and also taking the mean of every column to provide us with a
%row of averages. We want to find the columns with a TON of energy in them,
%and having downsampled the songs, that should be evident. 
%While we're at it, we're going to take that threshold line and convert the
%value into "the mean of the whole line of numbers plus X many standard
%deviations above that mean," so we have a line where any peaks above that
%line are almost certainly songs. 
absSpectro = mean(abs(dsSpectro));
threshold = 0.01; %mean(absSpectro) + threshold*std(absSpectro);

%Commented the line specifying the figure out, but if you want to see the
%figure of time vs. the power of the spectrogram, go ahead and uncomment
%these lines. 
%figure()
specLen = length(absSpectro);
dsLen = length(dsSong);
% y = absSpectro;
x = 0:dsLen/(specLen*1000):(dsLen/1000);
x = x(1:specLen);
% plot(x,y)

%grab all indices where the downsampled song rises above a set threshold
k = find(absSpectro > threshold);

%if there are no indices, return empty set--and finish the whole thing early because the heck with this...
if isempty(k) == 1
    "no songs found"
    startOutputs = [];
    song = [];
    return
end
%This is doing some housekeeping for the for loop we're about to set up.
%startsList 
startsList = [];
startsList(1) = k(1);
C = 2;

%Go through those indices of the spectrogram and grab the ones that aren't
%consecutive = grab all the peaks
for i=2:length(k)
    if k(i) - k(i-1) > 1
        startsList(C) = k(i);
        C = C+1;
    end
end

%Here I'm also preallocating some of these matrices for size to save on
%time and generally setting up my variables.
songStartTimes = zeros(length(startsList),1);
secsPast = zeros(length(startsList),1);
startOutputs = cell(length(startsList),5);

for i=1:length(startsList)
    thisIndex = startsList(i);
    % get the timestamp in seconds for the thing you care about, which is how many songs you have
    thisSec = x(thisIndex); 
    % here we want to translate that time in seconds into something in
    % samples so you can trim it quickly and save the file
    thisSongStart = thisSec * samp_freq;
    secsPast(i) = thisSec;
    songStartTimes(i) = thisSongStart;
    %And last of all we want a list of actual timestamps...
    newSec = rem(thisSec,60);
    minAdd = floor(thisSec/60); %floor rather than round because we want the smallest whole number
    newMin = minAdd + min;
    if newMin > 60
        newHour = hour + 1;
        newMin = newMin - 60;
    else
        newHour = hour;
    end
    startOutputs{i,1} = sequence;
    startOutputs{i,2} = newHour;
    startOutputs{i,3} = newMin;
    startOutputs{i,4} = newSec;
    startOutputs{i,5} = thisSongStart;
end