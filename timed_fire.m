function [] = timed_fire(year,month,day,hour,minute,second)
% This function is designed to take an input of the dateTime and then fire 
%a ZBus A trigger that should generate the playout of a song. 

t = timer('TimerFcn',@(~,~)disp('Test'));
startat(t,2018,11,2,18,26,00);
