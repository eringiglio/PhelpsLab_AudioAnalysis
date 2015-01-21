function write_songs(filename, song)

%write_calls(call_num, filename, call_length, calls)

fid = fopen(filename, 'w');

fwrite(fid, song, 'float32');