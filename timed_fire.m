function [] = timed_fire(year,month,day,hour,minute,second,trigger,zBUS)
% This function is designed to take an input of the dateTime and then fire
%a ZBus A trigger that should generate the playout of a song.

% Erin M Giglio, March 2019

if nargin < 8
  zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
  if zBus.ConnectZBUS('GB')
    e = 'connected'
  else
    e='unable to connect'
  end
  zBUS.FluishIO(1);

if trigger == 'A'
  t = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,5));
elseif trigger == 'B'
  t = timer('TimerFcn',@(~,~)zBUS.zBusTrigB(0,0,5));
else
  error('Please enter A or B for trigger.')
startat(t,year,month,day,hour,minute,second);
