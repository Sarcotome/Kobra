% attention à la surcharge d'events qui crée une lise d'attente, qui fausse
% les ts, et qui crée donc une impression de shutter rolling, comment
% corriger ça ? Mise à jour du soft ? Réduction de puissance (Densité
% neutre) ? réglage de la caméra ?
% pour 1 mm/s, avec lambda = 500 nm, voir mail avec les liens
% attention à la variation de contraste dûe aux battements des différentes
% fréquences du laser
% PEUT ETRE POURRIONS NOUS DEMANDER UN LASER A 1 LAMBDA


%% Initialisation

warning('off')
clear all
close all
clc

addpath('../processAEDAT-master/misc')
addpath('../Kobra mesures')

aerdatFile = '../Kobra mesures/variation de vitesse.aedat';
seqStart = 288502; % pour supprimer les premiers points gênants, le programme jaer sur le pc de supop ou la caméra fond qu'ils rajoutent une seconde de vide et des artefacts au début
[x,y,type,pol,ts] = loadData(aerdatFile, seqStart);

%% suppression des 'non-gradients', POL = OFF

x(pol==2) = [];
y(pol==2) = [];
type(pol==2) = [];
ts(pol==2) = [];
pol(pol==2) = [];
pol(pol==3) = pol(pol==3)-1;

%% Changement du sens

% x(1:end) = x(end:-1:1);
% y(1:end) = y(end:-1:1);
% pol(1:end) = pol(end:-1:1);

%% Traitement des données

% displayDVSdataNew(x, y, pol, ts, dt, 'Kobra mesures/allData'); % vérification des données



dt = 100; % temps réel entre chaque image en us (20 fps sur la vidéo finale), attention à la mémoire, pas dt trop petit

% displayDVSdataNew(x, y, pol, ts, dt, strcat(strcat('../Kobra mesures/selectedDataDVS_MOY_v_1_dt_',num2str(dt)),'us')); % vérification des données


ep = [y(pol==1) x(pol==1) ts(pol==1)]; % evenement positifs
em = [y(pol==2) x(pol==2) ts(pol==2)]; % evenement negatifs

% figure(1)
% plot3(y(pol==1), x(pol==1), ts(pol==1))

[fl,dvs] = opticalFlowPerso(ep,em,ts,dt,strcat(strcat('../Kobra mesures/opticalFlowDVS_MOY_n_2_v_1_dt_',num2str(dt)),'us'));

%% Intensité temporelle

lambda = 635*10^(-9);

w = 5;
h = 1;

xp = 100;
yp = 100;

signal = intensityOverTime(fl, dvs, xp, yp, w, h);

figure(1)
plot(1:dt/1000:size(signal,1)*dt/1000,signal)
title('Intensité en fonction du temps')
xlabel('Temps en millisecondes')
ylabel("Intensité en nombre d'événements")

FFTSignal = fft(signal);
FFTSignal = abs(FFTSignal(1:floor(size(FFTSignal)/2)));
HzSignal = 1000000/(dt*size(signal,1)):1000000/(dt*size(signal,1)):1000000/(2*dt);

figure(2)
plot(HzSignal,FFTSignal)
title("Tranformée de Fourier de l'intensité en fonction du temps")
xlabel('Hz')

disp(strcat(strcat("Vitesse : ", num2str(1000000*lambda*HzSignal(FFTSignal==max(FFTSignal))/2)),' um/s'))