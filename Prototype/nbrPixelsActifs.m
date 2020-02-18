H = 180;
W = 240;
step = 0.01;
n=[];

for alpha = 0:step:pi/4
    nmax = 0;
    for x0 = -tan(alpha)*H/2:step:(W+tan(alpha)*H/2)
        I = zeros(H,W);
        for y = -H/2:step:H/2
            xp = floor(y*tan(alpha)+x0);
            yp = floor(y+H/2);
            if(xp>0 && xp<=W && yp>0 && yp<=H)
                I(yp,xp) = 1;
            end
        end
        if(sum(I(:))>nmax)
            nmax = sum(I(:));
        end
    end
    n = [n; nmax];
end

for alpha = pi/4:-step:0
    nmax = 0;
    for x0 = -tan(alpha)*W/2:step:(H+tan(alpha)*W/2)
        I = zeros(W,H);
        for y = -W/2:step:W/2
            xp = floor(y*tan(alpha)+x0);
            yp = floor(y+W/2);
            if(xp>0 && xp<=H && yp>0 && yp<=W)
                I(yp,xp) = 1;
            end
        end
        if(sum(I(:))>nmax)
            nmax = sum(I(:));
        end
    end
    n = [n; nmax];
end

figure(1)
plot(0:180/pi*step:90, n)
xlabel('Angle in degrees') 
ylabel('Number of events') 
title('Maximum number of pixels activated by a fringe crossing the screen')
