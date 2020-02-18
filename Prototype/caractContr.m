close all
clc

addpath('../processAEDAT-master/misc')

pathFI = '../Kobra mesures/20200211a/caracterisation_contraste.aedat'; % choisir le bon dossier

dt = 1000000; % en us

[x,y,type,pol,ts] = loadData(pathFI, 0);

n=1;
nbr=zeros((ts(end)-ts(1))/dt,1);
p=zeros(size(nbr));

for k = 1:size(nbr,1)
    p(k) = (k-1)*10*dt/1000000;
    while (n<size(ts,1) && ts(n)-ts(1)<k*dt)
         n=n+1;
    end
    if(k~=1)
        nbr(k) = (n-nbr(k-1))*1000000/dt;
    else
        nbr(k) = n*1000000/dt;
    end
end

figure(1)
plot(p,nbr)
title('Number of events with respect to the position of the mirror')
xlabel('Relative position in um') 
ylabel('Number of events per second') 
