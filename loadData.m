function [x,y,type,pol,ts] = loadData(fileName,seqStart)
disp('Lecture et conversion des données :')
tic
pMask = bin2dec('00000000000000000000110000000000');
xMask = bin2dec('00000000001111111111000000000000');
yMask = bin2dec('01111111110000000000000000000000');
tMask = bin2dec('10000000000000000000000000000000');

maxEventsBatch = 10^9;

numEvents = seqStart-1;
adresses = [];
ts = [];

while((numEvents-seqStart)<size(adresses,1))
    numEvents=size(adresses,1)+seqStart;
    [adressesTemp, tsTemp] = loadaerdat(fileName, maxEventsBatch, numEvents);
    adresses = [adresses; adressesTemp];
    ts = [ts; tsTemp];
end

[x,y,type,pol]=extractFrameCoordinates(adresses,xMask,yMask,tMask,pMask);
x = x+1;
y = y+1;
pol = pol + 1;
fprintf('\n')
toc
beep
fprintf('\n')
end

