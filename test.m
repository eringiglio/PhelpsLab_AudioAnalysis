function[timeFire] = test(csvfile)

% You want to have a header that can then be removed from your input file,
% because csvimport will automatically assign one and will turn everything
% in to a string whether or not it is. I have here chosen in the example
% file to assign that value to nicknames for the time points they designate
% (e.g. y = year). 

raw = csvimport(csvfile);
times = raw(2:21,:);

[r,c] = size(times);

for i=1:r
    t(i) = timer('TimerFcn',@(~,~)fprintf('This message is sent at time %s\n', datestr(now,'HH:MM:SS')));
    y(i) = times{i,1};
    mo(i) = times{i,2};
    d(i) = times{i,3};
    h(i) = times{i,4};
    mi(i) = times{i,5};
    s(i) = times{i,6};
end        


t = timer('TimerFcn',@(~,~)fprintf('This message is sent at time %s\n', datestr(now,'HH:MM:SS')));
startat(t,y,mo,d,h,mi,s);