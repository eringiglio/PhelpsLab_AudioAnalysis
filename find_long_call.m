function [new_note_starts, new_note_ends, new_note_durs, new_INI] = find_long_call(note_starts, note_ends, INI, INI_max)

%
%

if nargin < 4
    INI_max = 50; %default criterion for calling a sequence of notes a separate call is an inter-note interval greater than 50ms
end

[note_num, c] = size(note_starts);



% Find inter-call intervals, defined as internote intervals > INI_max
%-----------------------------------------------------------------
j=1;
call_starts = 1; %use note numbers instead of times for call length -- simplifies extracting of calls

for i =1:note_num-1
    if INI(i)>INI_max
        call_ends(j) = i;       %ending note for call 
        call_starts(j+1) = i+1; %beginning note for next call -- if there's an INI, there's a note that follows
        j=j+1;
    end
end

call_ends(j) = note_num;


% Find and extract longest call
%------------------------------
[max_length, longest_call] = max(call_ends-call_starts); %longest_call tells you which row of call starts and ends to find note numbers for call to extract

new_note_starts = note_starts(call_starts(longest_call):call_ends(longest_call));
new_note_ends = note_ends(call_starts(longest_call):call_ends(longest_call));

new_note_durs = new_note_ends - new_note_starts;

[new_note_num, I] = size(new_note_starts);

new_INI = new_note_starts(2:new_note_num) - new_note_ends(1:new_note_num-1);