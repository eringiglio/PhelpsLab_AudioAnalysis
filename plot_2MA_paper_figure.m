function[] = plot_2MA_paper_figure()

%basically, I just want to use this thing to make all the figures I want
%made 

 song = view_songs('Cf24v.f32');
 song_cut = song(1:1000000);
 colors = [0 0 1; 0 1 1];
 colormap(colors)
 % Here's the introductory figure, which has its own code
 figure(1)
 plot_song_figure(song_cut);
 
 % Feeding behavior figure
 figure(2)
 p = panel()
 
 % Playback behavior figure
 figure(3)
 q = panel();
 q.pack(1,2) % here I'm just dividing the panel in two columns
 
 %get some data in here...
 categories = ['2MA';'SAL'];
 mean_lats = [838.3333333;911.9479167];
 mean_num_songs = [1.866667; 1];
 
 %Latency to respond...
 plot3 = subplot(1,2,1);
    bar(categories,mean_lats)
 plot4 = subplot(1,2,2);
    bar(mean_num_songs,colors)

    
 %Arclength figure 
 figure(4)