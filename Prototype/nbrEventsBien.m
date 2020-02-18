close all
clc

addpath('../processAEDAT-master/misc')

pathFI = '../Kobra mesures/20200211b/'; % choisir le bon dossier

v = [0 1 2 5 10 20 40 60 80 100];
nbr=zeros(size(v));

pathF = pathFI;
pathF = strcat(pathF,num2str(v(1)));
pathF = strcat(pathF,'.aedat');
[x,y,type,pol,ts] = loadData(pathF, 0);

n = 0;

for i = 1:size(ts,1)
    if(ts(i)-ts(1)>2500000)
        break
    elseif (ts(i)-ts(1)>1500000)
     n=n+1;
    end
end
nbr(1) = n;

for k = 2:size(v,2)
    pathF = pathFI;
    pathF = strcat(pathF,num2str(v(k)));
    pathF = strcat(pathF,'.aedat');
    [x,y,type,pol,ts] = loadData(pathF, 0);
    
    n = 0;

    for i = 1:size(ts,1)
        if(ts(i)-ts(1)>1500000+0.5/v(k)*1000000)
            break
        elseif (ts(i)-ts(1)>1500000)
            n=n+1;
        end
    end
    nbr(k) = n*v(k)/0.5;
end

figure(1)
plot(v,nbr)
title('Number of events with respect to the velocity of the mirror')
xlabel('Mirror velocity in micrometers per second') 
ylabel('Number of events per second') 
