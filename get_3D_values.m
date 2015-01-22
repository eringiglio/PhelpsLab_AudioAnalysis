function[num_notes,note_rate_mean,bandwidth_mean,r] = get_3D_values(file_name)

song_values = xlsread(file_name);

%we need a sense for how many rows of individuals are in our matrix
[r,c] = size(song_values);

% pull the number of notes from our starting matrix--note, (1,2) and (1,3)
% should be EMPTY
num_notes = song_values(1:r,1);

% first we want to get the average note rate

% set up an equation for duty cycle, then convert it into note rate

coeff1_duty_cycle = song_values(1:r,2) + song_values(1:r,5);
coeff2_duty_cycle = song_values(1:r,3) + song_values(1:r,6);
coeff3_duty_cycle = song_values(1:r,4) + song_values(1:r,7);

% translate duty cycle into note rate, and also seconds while we're at it

for i=1:r
    coeff1_note_rate(i,1) = 1000/coeff1_duty_cycle(i,1);
    coeff2_note_rate(i,1) = 1000/coeff2_duty_cycle(i,1);
    coeff3_note_rate(i,1) = 1000/coeff3_duty_cycle(i,1);
end

%now we collapse the equation itself into a single, averaged value with a
%subroutine

note_rate_mean = find_average_value(coeff1_note_rate,coeff2_note_rate,coeff3_note_rate,num_notes);

% let's do mean bandwidth of the song

% first we need our equation coefficients, same as before

coeff1_bandwidth = song_values(1:r,8) - song_values(1:r,11);
coeff2_bandwidth = song_values(1:r,9) - song_values(1:r,12);
coeff3_bandwidth = song_values(1:r,10) - song_values(1:r,13);

% and now we collapse it, again same as before

bandwidth_mean = find_average_value(coeff1_bandwidth,coeff2_bandwidth,coeff3_bandwidth,num_notes);

% now that we have our mean values for note number, note rate, and
% bandwidth, we're done with this module! HOORAY. Time to go write a
% function to plot everything. 