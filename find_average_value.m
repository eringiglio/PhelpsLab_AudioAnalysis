function[average_value] = find_average_value(coeff1,coeff2,coeff3,num_notes)

%Because we're now doing this to handle a set of coefficients all at once,
%we need another for loop to do this to spit out a set of values for each
%population.

%here we want the length of each coefficient--it should be a single column
%of unknown length
[r,c] = size(coeff1);

for j=1:r
    for i=1:num_notes
        note_value(i,1) = coeff1(j,1)*((i-1)^2)+coeff2(j,1)*(i-1)+coeff3(j,1);
    end
average_value(j,1) = mean(note_value);
end