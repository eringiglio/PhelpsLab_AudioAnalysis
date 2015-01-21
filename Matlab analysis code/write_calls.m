function write_calls(call_num, filename, call_length, calls)

%write_calls(call_num, filename, call_length, calls)

fid = fopen(filename, 'w');

[r,c] = size(calls);

if(call_num*call_length > r)
    error('File too short for requested call extraction, or calls not found.')
end

start = (call_num-1)*call_length+1;
finish = call_num*call_length;

fwrite(fid, calls(start:finish), 'float32');