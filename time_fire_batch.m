function [] = time_fire_batch(xlsFile,)

%This function takes an Excel file and passes the times listed inside to timed_fire in order to create a list of playout fires (zBUS A triggers) for two chambers as specified in a paired RPvdsEx program.

zBUS = actxcontrol('ZBUS.x',[1,1,1,1]);
if zBus.ConnectZBUS('GB')
  e = 'connected'
else
  e='unable to connect'
end
zBUS.FluishIO(1);

