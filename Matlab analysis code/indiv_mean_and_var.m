function [indiv_mean, indiv_var, indiv_id, indiv_call_count] = indiv_mean_and_var(xl_file, output_file)

% function indiv_mean_and_var(xl_file, output_file, range)
%
% This has been giving me the most perplexing output -- animals with single calls get a single wildly large value for all means, and another for all variances.
%

[depend_measures, nominal_vars] = xlsread(xl_file);
[num_calls, num_vars] = size(depend_measures);

call_id = nominal_vars(2:num_calls+1,1); % nominal variable have an extra variable corresponding to the header

n=1; %counts individuals
j=1; %counts calls assigned to an individual ID

indiv_dep(1,:) = depend_measures(1,:);

call_id = char(call_id);

for i = 2:num_calls % Group calls by ID (in first column of input)
    
    if (call_id(i,:)) == (call_id(i-1,:))
        j=j+1;
        indiv_dep(j,:) = depend_measures(i,:);
        
        if (i == num_calls)
            indiv_mean(n,:) = mean(indiv_dep);
            indiv_var(n,:) = var(indiv_dep);
            indiv_id(n,:) = call_id(i, :);
            indiv_call_count(n,1) = j;
        end
        
    else      %Complete measures for individual and initiate new individuals
        if j ~= 1
            indiv_mean(n,:) = mean(indiv_dep);
            indiv_var(n,:) = var(indiv_dep);
        else
            indiv_mean(n,:) = indiv_dep(1,:);
            indiv_var(n,:) = 0;
        end
        
        indiv_id(n,:) = call_id(i-1, :);
        indiv_call_count(n,1) = j;
        
        n=n+1;                                  %increment individual counter
        j=1;                                    %reset call counter
        
        indiv_dep = zeros(1,num_vars);
        indiv_dep(1,:) = depend_measures(i,:);  %reset individual measures
    end
end

mean_output_file = strcat(output_file, '_mean.txt');
mean_fid = fopen(mean_output_file, 'w');

var_output_file = strcat(output_file, '_var.txt');
var_fid = fopen(var_output_file, 'w');

[num_indiv, num_vars] = size(indiv_mean);

for i=1:num_indiv
    
    fprintf(mean_fid, '%s \t %.0f \t %12g \t', deblank(indiv_id(i,:)), indiv_call_count(i,1), indiv_mean(i,:)); 
    fprintf(mean_fid, '\n');
    
    fprintf(var_fid, '%s \t %.0f \t %12g \t', deblank(indiv_id(i,:)), indiv_call_count(i,1), indiv_var(i,:)); 
    fprintf(var_fid, '\n');
end

fclose(mean_fid);
fclose(var_fid);







