function[summary_table] = quick_song_stats_batch(xl_file,range)

[param_list, song_list] = xlsread(xl_file);

%song_list = song_list(2:num_rows,1); %Note I could choose to save rest of string data and write it to output file below.

[num_songs, c] = size(song_list);
[num_songs2, c2] = size(param_list);

if num_songs ~= num_songs2
    error('Error: file list and parameter list must be of equal lengths.')
end

if c2 ~= 3, error('Error: expecting three columns in parameter file.'), end

%if you don't feel like dealing with a range...

if nargin<2, range = [1, num_songs];
else
    [r,c] = size(range);
    if (r ~= 1) | (c ~= 2)
        error('Error specifying range: must be integer values of form [min max].')
    end
    if (round(range(1,1)) ~= range(1,1)) | (round(range(1,2)) ~= range(1,2))
        error('Error specifying range: must be integer values of form [min max].')
    end
end

%let's get down to business
file_min = range(1,1);
file_max = range(1,2);

parameters = param_list(file_min:file_max,:);



%Let's just get all the summary stats from everything...

for i=1:num_songs
    % Extract specified song from file
    file_name = char(song_list(i,:)); %***
    fid = fopen(file_name,'r');
    
    song_length = parameters(i,1);
    song_position = parameters(i,2);
    samp_rate = parameters(i,3);
    
    n = song_position*song_length;
    song = fread(fid, n, 'float32');
    if song_position > 1
            song = song(((song_position-1)*song_length + 1):song_position*song_length);
    elseif song_position == 1
        song = song(1:song_length);
    else
        error('Error specifying song position. Should be positive integer size 1 or larger.')
    end
    fclose(fid);
    
    % Define song ID
    song_id_temp = deblank(char(song_list(i,:)));
    [r,c] = size(song_id_temp);
    
    if (song_id_temp(1,c-3:c) == '.F32')
        song_id_temp = song_id_temp(1,1:c-4);
        
    elseif (song_id_temp(1,c-3:c) == '.f32')
        song_id_temp = song_id_temp(1,1:c-4);
    end
    song_id = sprintf('%s_%.0f', song_id_temp, song_position);

    %Now we'll want to pass this to quick_song_stats...
    [summary_table(i,:)] = quick_song_stats(song);
end