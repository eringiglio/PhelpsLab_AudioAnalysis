function[num_notes,note_rate,bandwidth] = plot_populations_3D

% get values output for each population
[num_notes(1,1),note_rate(1,1),bandwidth(1,1)] = get_3D_values('la_carpintera'); %green
[num_notes(2,1),note_rate(2,1),bandwidth(2,1)] = get_3D_values('irazu'); %green
[num_notes(3,1),note_rate(3,1),bandwidth(3,1)] = get_3D_values('cerro_gomez'); % red
[num_notes(4,1),note_rate(4,1),bandwidth(4,1)] = get_3D_values('cuerici'); % red
[num_notes(5,1),note_rate(5,1),bandwidth(5,1)] = get_3D_values('pittier'); %blue
[num_notes(6,1),note_rate(6,1),bandwidth(6,1)] = get_3D_values('PNR'); %blue
[num_notes(7,1),note_rate(7,1),bandwidth(7,1)] = get_3D_values('volcan_baru'); %blue

%here I'm inputting a variety of colors to distinguish between Cartago, San
%Isidro, and Boquete populations
size = 50;
color = [2;2;3;3;1;1;1];

scatter3(num_notes,note_rate,bandwidth,size,color,'fill')
xlabel('number of notes')
ylabel('note rate')
zlabel('bandwidth') 