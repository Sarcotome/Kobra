clc
close all
clear all

v = [0 1 2 5 10 20 50 100];
n=[];

for i = 1:8
    pathF = strcat('Kobra mesures/20200204 bien/',num2str(v(i)));
    n = [n; nombreEvents(strcat(pathF,'.aedat'))/5];
end

figure(1)
plot(v,n)
title('Number of events with respect to the velocity of the mirror')
xlabel('Mirror velocity in micrometers per second') 
ylabel('Number of events per second') 

% pathF = strcat('Kobra mesures/20200204/0degres.aedat');
% nombreEvents(pathF)
% 
% pathF = strcat('Kobra mesures/20200204/90degres.aedat');
% nombreEvents(pathF)
% 
% pathF = strcat('Kobra mesures/20200204/bruitAvecCache.aedat');
% nombreEvents(pathF)
% 
% pathF = strcat('Kobra mesures/20200204/bruitAvecFrangesFixes.aedat');
% nombreEvents(pathF)

pathF = strcat('Kobra mesures/20200204 bien/45.aedat');
nombreEvents(pathF)

pathF = strcat('Kobra mesures/20200204 bien/90.aedat');
nombreEvents(pathF)

