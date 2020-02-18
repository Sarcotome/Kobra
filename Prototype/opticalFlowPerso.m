function [flowByFrame, dvs_frames] = opticalFlowPerso(ep, em, ts,dt, videoTitle)

fprintf('\n')
tic
pasFleche = 5;
tailleVois = 5;

nFrames = ceil(double(ts(end)-ts(1))/dt);
nEventsP = size(ep(:,3),1);
nEventsM = size(em(:,3),1);
flowByFrame = zeros(180,240,nFrames-1,2);
dvs_frames = zeros(180,240,nFrames);
OnesM = ones(180,240, 'double');

v = VideoWriter(videoTitle);
open(v)

np = 1;
nm = 1;    
disp('Intégration :')

for k = 1:nFrames
    if(mod(k,ceil(nFrames/10))==0)
        disp([num2str(floor(k/(nFrames/100))) '%'])
    end
    while(nm<nEventsM && (em(nm,3)-em(1,3))<(k*dt))
        dvs_frames(em(nm,1),em(nm,2),k)=dvs_frames(em(nm,1),em(nm,2),k)-1; 
        nm = nm+1;
    end
    while(np<nEventsP && (ep(np,3)-ep(1,3))<(k*dt))
        dvs_frames(ep(np,1),ep(np,2),k)=dvs_frames(ep(np,1),ep(np,2),k)+1; 
        np = np+1;
    end
end

voisinage = 2;
disp('Moyennage :')

for k = voisinage+1:nFrames-voisinage
    if(mod(k,ceil(nFrames/10))==0)
        disp([num2str(floor(k/(nFrames/100))) '%'])
    end
    for x = 1+voisinage:240-voisinage
        for y = 1+voisinage:180-voisinage
            dvs_frames(y,x,k) = mean(mean(mean(dvs_frames((y-voisinage):(y+voisinage),(x-voisinage):(x+voisinage),(k-voisinage):(k+voisinage)),1)));
        end
    end
end

disp('Calcul du flow :')

for k = 2:nFrames
    if(mod(k,ceil(nFrames/10))==0)
        disp([num2str(floor(k/(nFrames/100))) '%'])
    end
    flowThisFrameX = zeros(180,240);
    flowThisFrameY = zeros(180,240);

    % dvs_frames(:,:,k) = imgaussfilt(dvs_frames(:,:,k),1);

    cX = [dvs_frames(:,2:240,k) zeros(180,1)] - [dvs_frames(:,1:239,k) zeros(180,1)];
    cY = [dvs_frames(2:180,:,k); zeros(1,240)] - [dvs_frames(1:179,:,k); zeros(1,240)];
    cT = (dvs_frames(:,:,k)-dvs_frames(:,:,k-1));

    for x = (tailleVois+1):(240-tailleVois)
        for y = (tailleVois+1):(180-tailleVois)
            neighborCX = cX((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));
            neighborCY = cY((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));
            neighborCT = cT((y-tailleVois):(y+tailleVois),(x-tailleVois):(x+tailleVois));

            vf = [neighborCX(:) neighborCY(:)]\neighborCT(:);
            flowThisFrameX(y,x) = vf(1);
            flowThisFrameY(y,x) = vf(2);
        end
    end


    flowByFrame(:,:,k-1,1) = -imgaussfilt(flowThisFrameX,20);
    flowByFrame(:,:,k-1,2) = -imgaussfilt(flowThisFrameY,20);

    gcf = figure(1);
    set(gcf, 'Position', get(0, 'Screensize'));
    imagesc(dvs_frames(:,:,k))
    hold on
    quiver(1:pasFleche:240,1:pasFleche:180,flowByFrame(1:pasFleche:180,1:pasFleche:240,k-1,1),flowByFrame(1:pasFleche:180,1:pasFleche:240,k-1,2),'LineWidth',1, 'Color','r');
    quiver(120,90,sum(sum(flowByFrame(:,:,k-1,1))),sum(sum(flowByFrame(:,:,k-1,2))),'LineWidth',1, 'Color','w');
    axis([-20 260 -20 200])
    hold off
    title('Optical flow with DVS data');

    F = getframe(gcf);
    close(1)

    [I, map] = frame2im(F);
    writeVideo(v,I)  

end

close(v)

fprintf('\n')
toc
beep
fprintf('\n')
end

