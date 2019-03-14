function [] = time_fire_batch(csvFile,trigger)

%This function takes a csv file and passes the times listed inside to timed_fire in order to create a list of playout fires (zBUS A triggers) for two chambers as specified in a paired RPvdsEx program.

zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
if zBus.ConnectZBUS('GB')
  e = 'connected'
else
  e='unable to connect'
end
zBUS.FluishIO(1);

raw = csvimport(csvfile);
times = raw(2:21,:);

[r,c] = size(times);


if trigger == 'A'
  for i=1:r
      t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,5));
      y(i) = times{i,1};
      mo(i) = times{i,2};
      d(i) = times{i,3};
      h(i) = times{i,4};
      mi(i) = times{i,5};
      s(i) = times{i,6};
  startat(t,y,mo,d,h,mi,s);
elif trigger == 'B'
for i=1:r
    t(i) = timer('TimerFcn',@(~,~)zBUS.zBusTrigA(0,0,5));
    y(i) = times{i,1};
    mo(i) = times{i,2};
    d(i) = times{i,3};
    h(i) = times{i,4};
    mi(i) = times{i,5};
    s(i) = times{i,6};
startat(t,y,mo,d,h,mi,s);
