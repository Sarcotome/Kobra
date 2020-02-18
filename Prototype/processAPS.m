%% Init
clear all
close all
clc

addpath('../processAEDAT-master/misc')
addpath('../processAEDAT-master/misc/davis')
addpath('../Kobra mesures')

% aerdatFile = '../Kobra mesures/Analyse des mesures #1 20190128/1ums_1um_APS_globalshutter.aedat';
aerdatFile = '../Kobra mesures/Analyse des mesures #2 20200203/1ums_1um_APS_3.aedat';


frames = getAPSframesDavisGS(aerdatFile);

%% File writer

v = VideoWriter('../Kobra mesures/testAPS', 'Grayscale AVI');
open(v)

frameImage = zeros(180, 240,size(frames,4));

for i = 1:size(frames,4)
    frameImage(:,:,i) = squeeze((frames(3,:,:,i)-min(min(frames(3,:,:,i))))/(max(max(frames(3,:,:,i)))-min(min(frames(3,:,:,i))))).';
    writeVideo(v,frameImage(:,:,i))
end

close(v)

%% Flow
    
gradientsOfFrameX = zeros(180,240);
gradientsOfFrameY = zeros(180,240);
mX = zeros(size(frames,4)-1,1);
mY = zeros(size(frames,4)-1,1);
flowByFrame =  zeros(180,240,size(frames,4)-1,2);   
OnesM = ones(180,240);
tailleVois = 20;
    
speedFactor = 5; % (5 means 5 times slower)
v = VideoWriter('../Kobra mesures/opticalFlowAPSTest2');
open(v)

for k = 1:size(frames,4)-1
    [gradientsOfFrameX,gradientsOfFrameY] = gradient(frameImage(:,:,k));
    
    flowThisFrameX = zeros(180,240);
    flowThisFrameY = zeros(180,240);
    
    cT = frameImage(:,:,k+1)-frameImage(:,:,k);
    
%     for x = (tailleVois+1):(240-tailleVois)
%         for y = (tailleVois+1):(180-tailleVois)
%             neighborCX = gradientsOfFrameX((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));
%             neighborCY = gradientsOfFrameY((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));
%             neighborCT = cT((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));
% 
%             vf = [neighborCX(:) neighborCY(:)]\neighborCT(:);
%             flowThisFrameX(y,x) = vf(1);
%             flowThisFrameY(y,x) = vf(2);
%         end
%     end
%     
    flowThisFrameY(gradientsOfFrameX~=0) = OnesM(gradientsOfFrameX~=0);
    flowThisFrameX(gradientsOfFrameX~=0) = (cT(gradientsOfFrameX~=0)-gradientsOfFrameY(gradientsOfFrameX~=0))./gradientsOfFrameX(gradientsOfFrameX~=0);
    flowThisFrameX(and(gradientsOfFrameX==0, gradientsOfFrameY~=0)) = OnesM(and(gradientsOfFrameX==0, gradientsOfFrameY~=0));
    flowThisFrameY(and(gradientsOfFrameX==0, gradientsOfFrameY~=0)) = (cT(and(gradientsOfFrameX==0, gradientsOfFrameY~=0))-gradientsOfFrameX(and(gradientsOfFrameX==0, gradientsOfFrameY~=0)))./gradientsOfFrameY(and(gradientsOfFrameX==0, gradientsOfFrameY~=0));        
    flowThisFrameX(and(gradientsOfFrameX==0, gradientsOfFrameY==0)) = 0;
    flowThisFrameY(and(gradientsOfFrameX==0, gradientsOfFrameY==0)) = 0; 

    mX(k) = mean(mean(flowThisFrameX));
    mY(k) = mean(mean(flowThisFrameY));
    
%     flowByFrame(:,:,k,1) = flowThisFrameX;
%     flowByFrame(:,:,k,2) = flowThisFrameY;
    
    flowByFrame(:,:,k,1) = -imgaussfilt(flowThisFrameX,50);
    flowByFrame(:,:,k,2) = -imgaussfilt(flowThisFrameY,50);
    
    gcf = figure(1);
    set(gcf, 'Position', get(0, 'Screensize'));
    contour(1:240,1:180,frameImage(:,:,k))
    hold on
    quiver(1:10:240,1:10:180,flowByFrame(1:10:180,1:10:240,k,1),flowByFrame(1:10:180,1:10:240,k,2),'LineWidth',1, 'Color','r');
    text(-10,-10,strcat(num2str(180/pi*angle(mX(k)+1j*mY(k))),'^{\circ}'),'Color','red','FontSize',10);
    hold off
    axis([-20 260 -20 200])
    title('Optical flow with APS data');

    F = getframe(gcf);
    [I, map] = frame2im(F);
    for i = 1:speedFactor
        writeVideo(v,I)
    end
end

close(v)

%% Flow by Matlab

v = VideoWriter('Kobra mesures/opticalFlowAPSTestMatlabHS');
open(v)

for i = 1:size(frames,4)
    flow = estimateFlow(opticalFlowHS,frameImage(:,:,i));
    gcf = figure(1);
    set(gcf, 'Position', get(0, 'Screensize'));
    contour(1:240,1:180,frameImage(:,:,i))
    hold on
    quiver(1:10:240,1:10:180,flow.Vx(1:10:180,1:10:240),flow.Vy(1:10:180,1:10:240),'LineWidth',1, 'Color','r');
    axis([-20 260 -20 200])
    hold off
    title('Optical flow with APS data - Matlab opticalFlowHS version');

    F = getframe(gcf);
    [I, map] = frame2im(F);
    for k = 1:speedFactor
        writeVideo(v,I)
    end
end

close(v)

v = VideoWriter('Kobra mesures/opticalFlowAPSTestMatlabFarneback');
open(v)

for i = 1:size(frames,4)
    flow = estimateFlow(opticalFlowFarneback,frameImage(:,:,i));
    gcf = figure(1);
    set(gcf, 'Position', get(0, 'Screensize'));
    contour(1:240,1:180,frameImage(:,:,i))
    hold on
    quiver(1:10:240,1:10:180,flow.Vx(1:10:180,1:10:240),flow.Vy(1:10:180,1:10:240),'LineWidth',1, 'Color','r');
    axis([-20 260 -20 200])
    hold off
    title('Optical flow with APS data - Matlab opticalFlowFarneback version');

    F = getframe(gcf);
    [I, map] = frame2im(F);
    for k = 1:speedFactor
        writeVideo(v,I)
    end
end

close(v)

v = VideoWriter('Kobra mesures/opticalFlowAPSTestMatlabLK');
open(v)

for i = 1:size(frames,4)
    flow = estimateFlow(opticalFlowLK,frameImage(:,:,i));
    gcf = figure(1);
    set(gcf, 'Position', get(0, 'Screensize'));
    contour(1:240,1:180,frameImage(:,:,i))
    hold on
    quiver(1:10:240,1:10:180,flow.Vx(1:10:180,1:10:240),flow.Vy(1:10:180,1:10:240),'LineWidth',1, 'Color','r');
    axis([-20 260 -20 200])
    hold off
    title('Optical flow with APS data - Matlab opticalFlowLK version');

    F = getframe(gcf);
    [I, map] = frame2im(F);
    for k = 1:speedFactor
        writeVideo(v,I)
    end
end

close(v)
