%Designed to plot a figure that will let me showcase the differences in the two
%types of vocalizations. The top half will be done in Plotly: distributions
%of song length, then panels showing PC loading values and then the PCA without song length demonstrating
%the differential clusters on PC1 and PC3. On this half, I want to see
%examples of the vocalizations themselves stacked neatly within a larger
%whole...

shortSong = view_songs('M3novel1_3a.f32');
longSong = view_songs('M3novel1_1a.f32');

%Defining some useful parameters
num_songs=1; %note that this refers to the number of songs within each given panel. 
samp_freq = 195312.5;
window_length = 35000;

%Useful for determining windows in seconds...
time_between = 1/samp_freq;
trimStart = round(samp_freq*0.2);
trimEnd = trimStart+1499999;
longTrim = longSong(trimStart:trimEnd);

%open new figure
figure()

colorscheme = customcolormap_preset('pasteljet');

subplot(2,4,[1:3])
    spectrogram(longTrim,512,256,512,samp_freq);
    view(90,-90)
    ylabel('Time (seconds)')
    xlabel('Frequency (kHz)')
%    caxis([-200 -30])
    colormap(colorscheme);
    ch=colorbar;
    pause(1);
    delete(ch);    
    t1 = title('D');
    set(t1, 'horizontalAlignment', 'right');
    set(t1, 'units', 'normalized');
    h1 = get(t1, 'position');
    set(t1, 'position', [0 h1(2) h1(3)]);
subplot(2,4,4)
    spectrogram(shortSong,512,256,512,samp_freq);
    view(90,-90)
%    caxis([-200 -30])
    colormap(colorscheme);
    ch=colorbar;
    pause(1);
    delete(ch);    
    ylabel('Time (seconds)')
    t1 = title('E');
    set(t1, 'horizontalAlignment', 'right');
    set(t1, 'units', 'normalized');
    h1 = get(t1, 'position');
    set(t1, 'position', [0 h1(2) h1(3)]);
subplot(2,4,[5:7])
    y = longTrim;
    song_length=length(longTrim);
    x = 0:time_between:(song_length-1)*time_between;
    plot(x,y)
    ylabel('Amplitude')
    xlabel('Time (seconds)')
    t1 = title('F');
    set(t1, 'horizontalAlignment', 'right');
    set(t1, 'units', 'normalized');
    h1 = get(t1, 'position');
    set(t1, 'position', [0 h1(2) h1(3)]);
subplot(2,4,8)
    y = shortSong;
    song_length=length(shortSong);
    x = 0:time_between:(song_length-1)*time_between;
    plot(x,y)
    xlabel('Time (seconds)')
    t1 = title('G');
    set(t1, 'horizontalAlignment', 'right');
    set(t1, 'units', 'normalized');
    h1 = get(t1, 'position');
    set(t1, 'position', [0 h1(2) h1(3)]);

   