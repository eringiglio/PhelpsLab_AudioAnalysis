function[song, chunk1, chunk2, chunk3] = panel_figure(song, samp_freq)

[file_length,c] = size(song);

% define default number of bins in the sample (number of songs = bins)
if nargin<3                
    num_songs=1;
end

% define default sample frequency
if nargin<2
    samp_freq = 195312.5;
end

%window length here!
window_length = 35000;

%Useful for determining windows in seconds...
time_between = 1/samp_freq;
sec_length = file_length * time_between;

%Grab some windows, here, in seconds
chnk1_Xi = roundsd(0.1*sec_length,3);
chnk2_Xi = roundsd(0.5*sec_length,3);
chnk3_Xi = roundsd(0.8*sec_length,3);

%let's figure out what the end of my chunks are...
chnk1_start = chnk1_Xi * samp_freq;
chnk1_end = chnk1_start + window_length;
chnk2_start = chnk2_Xi * samp_freq;
chnk2_end = chnk2_start + window_length;
chnk3_start = round(chnk3_Xi * samp_freq);
chnk3_end = round(chnk3_start + window_length);

%and my endpoints, if you will...
chnk1_Xf = chnk1_end * time_between;
chnk2_Xf = chnk2_end * time_between;
chnk3_Xf = chnk3_end * time_between;

%pull out windows of early, middle, and late song
chunk1 = song(chnk1_start:chnk1_end);
chunk2 = song(chnk2_start:chnk2_end);
chunk3 = song(chnk3_start:chnk3_end);

%set up panel
figure(2)
%caxis([-80 35])
p = panel();
% divvy it into two...
p.pack(2, 1);
%...and three
p(2,1).pack(1,3);

% Now we PLOT
p(1,1).select();
    specgram(song, 512, samp_freq);
    xlabel('Time (seconds)')
    ylabel('Frequency (Hz)')
    caxis([-80 35])
p(2,1,1,1).select();
    specgram(chunk1, 512, samp_freq);
    xlabel('Time (seconds)')
    Xlim = get(gca, 'xlim');
    set(gca, 'XTicklabel', roundsd(chnk1_Xi,1):0.05:roundsd(chnk1_Xf,1));
    ylabel('Frequency (Hz)')
    caxis([-80 35])
p(2,1,1,2).select();
    specgram(chunk2, 512, samp_freq);
    xlabel('Time (seconds)')
    Xlim = get(gca, 'xlim');
    set(gca, 'XTicklabel', roundsd(chnk2_Xi,2):0.05:roundsd(chnk2_Xf,2))
    ylabel('')
    set(gca, 'YTicklabel',{' '});
    caxis([-80 35])
p(2,1,1,3).select();
    specgram(chunk3, 512, samp_freq);
    xlabel('Time (seconds)')
    Xlim = get(gca, 'xlim');
    set(gca, 'XTicklabel', roundsd(chnk3_Xi,2):0.05:roundsd(chnk3_Xf,2));
    ylabel('')
    set(gca, 'YTicklabel',[]);
    caxis([-80 35])