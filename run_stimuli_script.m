[r,c] = size(stimuli_files);

for i=2:r
    file_name1  = stimuli_files(r,1);
    file_name2  = stimuli_files(r,2);
    file_name3  = stimuli_files(r,3);
    name_of_file = stimuli_files(r,4);
    make_stimulus_recording(file_name1, file_name2, file_name3, name_of_file);
end