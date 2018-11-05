function [] = timed_fire(year,month,day,hour,minute,second,zBUS)
% This function is designed to take an input of the dateTime and then fire
%a ZBus A trigger that should generate the playout of a song.
% Erin M Giglio, 2018

if nargin < 7
  zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
  if zBus.ConnectZBUS('GB')
    e = 'connected'
  else
    e='unable to connect'
  end
  zBUS.FluishIO(1);
end

t = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,5));
startat(t,2018,11,2,18,26,00);
