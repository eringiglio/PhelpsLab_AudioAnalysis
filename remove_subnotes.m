function [new_note_starts, new_note_ends, new_note_durs, new_INI] = remove_subnotes(note_starts, note_ends, min_note_dur)

% function [new_note_starts, new_note_ends, new_note_durs, new_INI] = remove_subnotes(note_starts, note_ends, min_note_dur)

note_durs = note_ends - note_starts;
[note_num, c] = size(note_durs);
new_note_starts = 0;
new_note_ends = 0;

j=1;
for i =1:note_num
    if note_durs(i,1) > min_note_dur
        new_note_starts(j,1) = note_starts(i,1);
        new_note_ends(j,1) = note_ends(i,1);
        j=j+1;
    end
end

new_note_durs = new_note_ends - new_note_starts;
[note_num, c] = size(new_note_durs);
new_INI = new_note_starts(2:note_num,1) - new_note_ends(1:(note_num-1),1);