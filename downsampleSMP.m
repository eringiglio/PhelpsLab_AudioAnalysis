function [new_stim] = downsampleSMP(stimulus, new_rate, old_rate, method)

if nargin<4, method = 'avg'; end

[stim_sz, c] = size(stimulus);
step_sz = round(old_rate/new_rate);
j=1;

for i=1:step_sz:stim_sz
    if method == 'avg'
        end_step = i + step_sz - 1;
        end_step = min(end_step,stim_sz);
        new_stim(j,1)=mean(stimulus(i:end_step,1));
    else
        new_stim(j,1)=stimulus(i,1);
    end
    j=j+1;
end