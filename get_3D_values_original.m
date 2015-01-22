function[num_notes,note_rate_mean,bandwidth_mean] = get_3D_values(file_name)

population = xlsread(file_name);

% figure out how to read in the file name here--till then, we pull from a
% matrix entered directly into matlab

% pull the number of notes from our starting matrix--note, (1,2) and (1,3)
% should be EMPTY
num_notes = population(1,1);

% first we want to get the average note rate

% set up an equation for duty cycle, then convert it into note rate

coeff1_duty_cycle = population(2,1) + population(3,1);
coeff2_duty_cycle = population(2,2) + population(3,2);
coeff3_duty_cycle = population(2,3) + population(3,3);

% translate duty cycle into note rate, and also seconds while we're at it

coeff1_note_rate = 1000/coeff1_duty_cycle;
coeff2_note_rate = 1000/coeff2_duty_cycle;
coeff3_note_rate = 1000/coeff3_duty_cycle;

%now we collapse the equation itself into a single, averaged value with a
%subroutine

note_rate_mean = find_average_value(coeff1_note_rate,coeff2_note_rate,coeff3_note_rate,num_notes);

% let's do mean bandwidth of the song

% first we need our equation coefficients, same as before

coeff1_bandwidth = population(4,1) - population(5,1);
coeff2_bandwidth = population(4,2) - population(5,2);
coeff3_bandwidth = population(4,3) - population(5,3);

% and now we collapse it, again same as before

bandwidth_mean = find_average_value(coeff1_bandwidth,coeff2_bandwidth,coeff3_bandwidth,num_notes);

% now that we have our mean values for note number, note rate, and
% bandwidth, we're done with this module! HOORAY. Time to go write a
% function to plot everything. 