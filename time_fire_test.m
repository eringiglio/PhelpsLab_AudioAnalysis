  function [zBUS] = time_fire_test(triggerID,numTriggers)

%This function creates a list of five times and passes them to timed_fire
%in order to create a list of playout fires.
zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
if zBUS.ConnectZBUS('GB')
    e = 'connected'
else
    e ='unable to connect'
end
zBUS.FlushIO(1);

if nargin < 2
    numTriggers = 4;
end

if nargin < 1
    triggerID = "A";
end

startTime = datetime(now,'ConvertFrom','datenum');

for i=1:numTriggers
    if triggerID == "A"
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
        tb(i) = timer('TimerFcn',@(~,~)disp(char(i)));
        y(i) = startTime.Year;
        mo(i) = startTime.Month;
        d(i) = startTime.Day;
        h(i) = startTime.Hour;
        mi(i) = startTime.Minute+i;
        s(i) = 0;
    elseif triggerID == "B"
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigB(0,0,2));
        y(i) = startTime.Year;
        mo(i) = startTime.Month;
        d(i) = startTime.Day;
        h(i) = startTime.Hour;
        mi(i) = startTime.Minute+i;
        s(i) = 0;
    else
        error('Please enter A for zBusA trigger or B for zbusB trigger on your timer file.')
    end
end
startat(t,y,mo,d,h,mi,s);
startat(tb,y,mo,d,h,mi,s);
