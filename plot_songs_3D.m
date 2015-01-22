function[num_notes,note_rate,bandwidth] = plot_songs_3D(file_name,point_size)

%NOTES ABOUT THIS FUNCTION: For the individual values, individual 107 has a
%weird-ass note rate. Check that out. 

%setting a default size
if nargin < 2;
    point_size = 50;
end

[num_notes,note_rate,bandwidth,r] = get_3D_values(file_name);

%pulling the colors of each value from the matrix
song_values = xlsread(file_name);
population = song_values(1:r,14);

%listing seven "counters" to give me my matrices for plotting
t = 0; 
u = 0;
v = 0; 
w = 0; 
x = 0;
y = 0; 
z = 0; 

%assigning each population set to its own matrix as I go, because
%apparently I have to do that if I want a legend in my plot
for i=1:r
    if population(i,1) == 1
        num_notes_1(t+1,1) = num_notes(i,1);
        note_rate_1(t+1,1) = note_rate(i,1);
        bandwidth_1(t+1,1) = bandwidth(i,1);
        t = t+1;
    elseif population(i,1) == 2
        num_notes_2(u+1,1) = num_notes(i,1);
        note_rate_2(u+1,1) = note_rate(i,1);
        bandwidth_2(u+1,1) = bandwidth(i,1);
        u = u+1; 
    elseif population(i,1) == 3
        num_notes_3(v+1,1) = num_notes(i,1);
        note_rate_3(v+1,1) = note_rate(i,1);
        bandwidth_3(v+1,1) = bandwidth(i,1);
        v = v+1; 
    elseif population(i,1) == 4
        num_notes_4(w+1,1) = num_notes(i,1);
        note_rate_4(w+1,1) = note_rate(i,1);
        bandwidth_4(w+1,1) = bandwidth(i,1);
        w = w+1; 
    elseif population(i,1) == 5
        num_notes_5(x+1,1) = num_notes(i,1);
        note_rate_5(x+1,1) = note_rate(i,1);
        bandwidth_5(x+1,1) = bandwidth(i,1);
        x = x+1; 
    elseif population(i,1) == 6
        num_notes_6(y+1,1) = num_notes(i,1);
        note_rate_6(y+1,1) = note_rate(i,1);
        bandwidth_6(y+1,1) = bandwidth(i,1);
        y = y+1; 
    elseif population(i,1) == 7
        num_notes_7(z+1,1) = num_notes(i,1);
        note_rate_7(z+1,1) = note_rate(i,1);
        bandwidth_7(z+1,1) = bandwidth(i,1);
        z = z+1; 
    end
end

%now the graphing bits
hold on
grid on
scatter3(num_notes_1,note_rate_1,bandwidth_1,point_size,'fill')
scatter3(num_notes_2,note_rate_2,bandwidth_2,point_size,'fill')
scatter3(num_notes_3,note_rate_3,bandwidth_3,point_size,'fill')
scatter3(num_notes_4,note_rate_4,bandwidth_4,point_size,'fill')
scatter3(num_notes_5,note_rate_5,bandwidth_5,point_size,'fill')
scatter3(num_notes_6,note_rate_6,bandwidth_6,point_size,'fill')
scatter3(num_notes_7,note_rate_7,bandwidth_7,point_size,'fill')
xlabel('number of notes')
ylabel('note rate')
zlabel('bandwidth') 
legend('La Carpintera','Irazu','Cerro Gomez','Cuerici','Pittier','PNR','Volcan Baru')