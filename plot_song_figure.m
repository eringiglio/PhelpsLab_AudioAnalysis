function[song, chunk1, chunk2, chunk3] = plot_song_figure(song, samp_freq)

[file_length,~] = size(song);
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
chnk1_Xi = roundsd(0.09*sec_length,3);
chnk2_Xi = roundsd(0.5*sec_length,3);
chnk3_Xi = roundsd(0.83*sec_length,3);

%let's figure out what the end of my chunks are...
chnk1_start = round(chnk1_Xi * samp_freq);
chnk1_end = round(chnk1_start + window_length);
chnk2_start = round(chnk2_Xi * samp_freq);
chnk2_end = round(chnk2_start + window_length);
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
figure()
p = panel();
% divvy it into two...
p.pack(2, 1);

colorscheme = customcolormap_preset('pasteljet');

% big plot
plot1 = subplot(2,3,1:3);
    spectrogram(song,512,256,512,samp_freq);
    view(90,-90)
    ylabel('Time (seconds)')
    xlabel('Frequency (kHz)')
%    caxis([-200 -30])
    colormap(colorscheme);
    ch=colorbar;
    pause(1);
    delete(ch);    
    t1 = title('A');
    set(t1, 'horizontalAlignment', 'right');
    set(t1, 'units', 'normalized');
    h1 = get(t1, 'position');
    set(t1, 'position', [0 h1(2) h1(3)]);
plot2 = subplot(2,3,4);
    spectrogram(chunk1,512,256,512,samp_freq);
    view(90,-90)
    ylabel('Time (seconds)')
    Ylim = get(gca, 'xlim');
%    set(gca, 'XTick', linspace(Xlim(1), Xlim(2), 3));
    set(gca, 'YTicklabel', roundsd(chnk1_Xi,1):0.05:roundsd(chnk1_Xf,1));
    xlabel('Frequency (kHz)')
%    caxis([-200 -30])
    ch=colorbar;
    pause(1);
    delete(ch);    
    t2 = title('B');
    set(t2, 'horizontalAlignment', 'right');
    set(t2, 'units', 'normalized');
    h1 = get(t2, 'position');
    set(t2, 'position', [0 h1(2) h1(3)]);
plot3 = subplot(2,3,5);
    spectrogram(chunk2,512,256,512,samp_freq);
    view(90,-90)
    ylabel('Time (seconds)')
    Ylim = get(gca, 'xlim');
    set(gca, 'YTicklabel', roundsd(chnk2_Xi,2):0.05:roundsd(chnk2_Xf,2))
    xlabel('')
    set(gca, 'XTicklabel',{' '});
%    caxis([-200 -30])
    ch=colorbar;
    pause(1);
    delete(ch);    
plot4 = subplot(2,3,6);
    spectrogram(chunk3,512,256,512,samp_freq);
    view(90,-90)
    ylabel('Time (seconds)')
    Ylim = get(gca, 'ylim');
    set(gca, 'YTicklabel', roundsd(chnk3_Xi,2):0.05:roundsd(chnk3_Xf,2));
    xlabel('')
    set(gca, 'XTicklabel',[]);
%    caxis([-200 -30])
    ch=colorbar;
    pause(1);
    delete(ch);    
