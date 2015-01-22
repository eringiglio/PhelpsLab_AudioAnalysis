function [songs] = note_songs(file_name, num_dev)

fid = fopen(file_name, 'r');

if fid == -1
      error('Error: check that path has been set to find appropriate file.')
end

songs = fread(fid, 'float32');
[file_length,c] = size(songs);

% general reading stuff sorted, now let's get to the meat of the program

% ranking input arguments
% if nargin <3
%     num_songs = 1;
% end

% note for here: num_songs was originally an input argument. May change
% later

%Should I institute a basic std_dev here? I think I'm going to
if nargin <2
    num_dev = 3;
end

%Now we have to actually find the onset of song notes. Hm.

% Find the absolute value of the data
absolute = abs(songs);

% finding standard deviations of the sample
std_dev = (num_dev)*(std(absolute));

% find the first place where the program reaches above the bar set by the mean
meanbar = mean(absolute)+std_dev;

% finding where meanbar and songs intercept
intercept = meanbar - songs;
abs_intercept = abs(intercept);
first_onset = find(abs_intercept < 1e-3, 1, 'first');

display(first_onset);




% NOTE FOR FUTURE REFERENCE: this should give me the peaks of every note in
% the song, but isn't onset per se. Not as useful as I initially thought.
%[pks,locs] = findpeaks(absolute, 'MINPEAKHEIGHT', meanbar);