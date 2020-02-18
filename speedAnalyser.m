%% Initialisation

warning('off')
clear all
close all
clc

addpath('processAEDAT-master/misc')
addpath('Kobra mesures')

%% Initialisation des paramètres
clc
close all

dt = 10000;
ndt = 5;
lambda = 635*10^(-9);

w = 5;
h = 1;

xp = 100;
yp = 100;

%% Chargement des données
clc

aerdatFile = '/Kobra mesures/variation de vitesse.aedat';
seqStart = 288502; % pour supprimer les premiers points gênants, le programme jaer sur le pc de supop ou la caméra fond qu'ils rajoutent une seconde de vide et des artefacts au début
[x,y,type,pol,ts] = loadData(aerdatFile, seqStart);

%% Pré-traitement
clc
close all

x(pol==2) = [];
y(pol==2) = [];
type(pol==2) = [];
ts(pol==2) = [];
pol(pol==2) = [];
pol(pol==3) = pol(pol==3)-1;


ep = [y(pol==1) x(pol==1) ts(pol==1)]; % evenement positifs
em = [y(pol==2) x(pol==2) ts(pol==2)]; % evenement negatifs

%% Traitement
clc
close all

nFrames = (ts(end)-ts(1))/dt;
signal = [];

for i = ndt:ndt:nFrames
    
    if(mod(i,floor(nFrames/100))==0)
        disp([num2str(floor(i/(nFrames/100))) '%'])
    end
    
    condP = and((ep(:,3)-ts(1))<dt*i,(ep(:,3)-ts(1))>dt*(i-ndt));
    condM = and((em(:,3)-ts(1))<dt*i,(em(:,3)-ts(1))>dt*(i-ndt));
    condT = and((ts(:)-ts(1))<dt*i,(ts(:)-ts(1))>dt*(i-ndt));
    
    epTemp = ep(condP,:);
    emTemp = em(condM,:);
    tsTemp = ts(condT);
    
    [fl,dvs] = dvsFlow(epTemp,emTemp,tsTemp,dt);
    signal = [signal; intensityOverTime(fl, dvs, xp, yp, w, h)];
end

%% Résultats
clc
close all

plot(1:dt/1000:size(signal,1)*dt/1000,signal)
title('Intensité en fonction du temps')
xlabel('Temps en millisecondes')
ylabel("Intensité en nombre d'événements")