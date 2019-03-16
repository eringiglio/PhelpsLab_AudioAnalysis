function [] = time_fire_batch(csvFile,trigger,zBUS)

%This function takes a csv file and passes the times listed inside to timed_fire in order to create a list of playout fires (zBUS A triggers) for two chambers as specified in a paired RPvdsEx program. It also takes 'trigger' which should be either A or B, depending on which chamber you intend to trigger.
if nargin < 3
  zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
  if zBUS.ConnectZBUS('GB')
    e = 'connected'
  else
    e='unable to connect'
  end
  zBUS.FlushIO(1);
end

raw = csvimport(csvFile);
times = raw(2:21,:);

[r,c] = size(times);

if trigger == 'A'
  for i=1:r
      t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
      y(i) = times{i,1};
      mo(i) = times{i,2};
      d(i) = times{i,3};
      h(i) = times{i,4};
      mi(i) = times{i,5};
      s(i) = times{i,6};
  end
  startat(t,y,mo,d,h,mi,s);
elseif trigger == 'B'
  for i=1:r
      t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,2));
      y(i) = times{i,1};
      mo(i) = times{i,2};
      d(i) = times{i,3};
      h(i) = times{i,4};
      mi(i) = times{i,5};
      s(i) = times{i,6};
  end
  startat(t,y,mo,d,h,mi,s);
else
  error('Please enter A for zBusA trigger or B for zbusB  trigger')
end