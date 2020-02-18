function eventsByFrames = displayDVSdataNew(x, y, pol, ts, dt, videotitle)
fprintf('\n')
disp('création du fichier vidéo')
tic
res_x = 240;
res_y = 180;

nFrames = ceil(double(ts(end)-ts(1))/dt);
eventsByFrames = zeros(res_y,res_x,nFrames);
v = VideoWriter(videotitle, 'Archival');
open(v)
j=1;
for i = 1:nFrames
    dvs_frames = uint8(zeros(res_y,res_x,3));
    if(mod(i,ceil(nFrames/100))==0)
        disp([num2str(ceil(i/(nFrames/100))) '%'])
    end
    while((ts(j)-ts(1))<(i*dt) && j<size(ts,1))
        dvs_frames(y(j),x(j),pol(j)) = uint8(255);
        eventsByFrames(x(j),y(j),i) = pol(j);
        j = j+1;
    end
    writeVideo(v,dvs_frames)
end
beep
close(v)
fprintf('\n')
toc
fprintf('\n')
end

