function [] = timed_fire(year,month,day,hour,minute,second,zBUS)
% This function is designed to take an input of the dateTime and then fire
%a ZBus A trigger that should generate the playout of a song.

% Erin M Giglio, March 2019

if nargin < 7
  zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
  if zBus.ConnectZBUS('GB')
    e = 'connected'
  else
    e='unable to connect'
  end
  zBUS.FluishIO(1);

end
raw = csvimport(csvfile);
times = raw(2:21,:);

[r,c] = size(times);

for i=1:r
    t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,5));
    y(i) = times{i,1};
    mo(i) = times{i,2};
    d(i) = times{i,3};
    h(i) = times{i,4};
    mi(i) = times{i,5};
    s(i) = times{i,6};
startat(t,y,mo,d,h,mi,s);
