  function [zBUS] = time_fire_batch(csvFile,numTriggers)

%This function takes a csv file and passes the times listed inside to timed_fire in order to create a list of playout fires (zBUS A triggers) for two chambers as specified in a paired RPvdsEx program. It also takes 'trigger' which should be either A or B, depending on which chamber you intend to trigger.
zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
if zBUS.ConnectZBUS('GB')
    e = 'connected'
else
    e='unable to connect'
end
zBUS.FlushIO(1);

raw = csvimport(csvFile);

if nargin < 2
    numTriggers = length(raw) - 1;
end

times = raw(2:numTriggers+1,:);

[r,~] = size(times);

for i=1:r
    if string(times(i,7)) == "A"
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
        y(i) = times{i,1};
        mo(i) = times{i,2};
        d(i) = times{i,3};
        h(i) = times{i,4};
        mi(i) = times{i,5};
        s(i) = times{i,6};
    elseif string(times(i,7)) == "B"
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigB(0,0,2));
        y(i) = times{i,1};
        mo(i) = times{i,2};
        d(i) = times{i,3};
        h(i) = times{i,4};
        mi(i) = times{i,5};
        s(i) = times{i,6};
    else
        error('Please enter A for zBusA trigger or B for zbusB trigger on your timer file.')
    end
end
startat(t,y,mo,d,h,mi,s);
