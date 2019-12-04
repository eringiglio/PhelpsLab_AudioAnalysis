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


if triggerID == "A"
    for i=1:numTriggers
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
        tb(i) = timer('TimerFcn',@(~,~)disp(char(i)));
        y(i) = startTime.Year;
        mo(i) = startTime.Month;
        d(i) = startTime.Day;
        h(i) = startTime.Hour;
        mi(i) = startTime.Minute+i;
        s(i) = 0;
    end
elseif triggerID == "B"
    for i=1:numTriggers
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigB(0,0,2));
        tb(i) = timer('TimerFcn',@(~,~)disp(char(i)));
        y(i) = startTime.Year;
        mo(i) = startTime.Month;
        d(i) = startTime.Day;
        h(i) = startTime.Hour;
        mi(i) = startTime.Minute+i;
        s(i) = 0;
    end
elseif triggerID == "AB"
    for i=1:numTriggers
        t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigB(0,0,2));
        tb(i) = timer('TimerFcn',@(~,~)disp(char(i)));
        y(i) = startTime.Year;
        mo(i) = startTime.Month;
        d(i) = startTime.Day;
        h(i) = startTime.Hour;
        mi(i) = startTime.Minute+i;
        s(i) = 0;
    end
    for i=1:numTriggers
        t(i+numTriggers) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
        tb(i+numTriggers) = timer('TimerFcn',@(~,~)disp(char(i)));
        y(i+numTriggers) = startTime.Year;
        mo(i+numTriggers) = startTime.Month;
        d(i+numTriggers) = startTime.Day;
        h(i+numTriggers) = startTime.Hour;
        mi(i+numTriggers) = startTime.Minute+i;
        s(i+numTriggers) = 0;
    end
else
        error('Please enter A for zBusA trigger or B for zbusB trigger on your timer file.')
end
startat(t,y,mo,d,h,mi,s);
startat(tb,y,mo,d,h,mi,s);
