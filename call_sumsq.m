function [call_SS] = call_sumsq(call, bin_sz); 
% function [call_SS] = call_sumsq(call, bin_sz); 

if nargin<2 
   bin_sz = 100; 
end 
[call_dur, c] = size (call); 

call2 = call .* call; 
j=1; 

for i=1:bin_sz:(call_dur-bin_sz+1) 
   call_SS(j)=sum(call2(i:(i+(bin_sz-1)))); 
   j=j+1; 
end 

call_SS=call_SS';
