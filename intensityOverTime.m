function signal = intensityOverTime(flowByFrame, dvsByFrame, xp, yp, w, h)
    signal = [];
    for i = 1:size(flowByFrame,3)
        I = zeros([size(flowByFrame,1),size(flowByFrame,2)]);
        vFlow = reshape(flowByFrame(yp,xp,i,:),[1 2]);
        vFlow = vFlow/norm(vFlow);
        nFlow = [-vFlow(2) vFlow(1)];
        v1 = vFlow*h+nFlow*w;
        v2 = vFlow*h-nFlow*w;
        v3 = -vFlow*h-nFlow*w;
        v4 = -vFlow*h+nFlow*w;
        I = rgb2gray(insertShape(I,'FilledPolygon',{[v1 v2 v3 v4]}, 'Color', 'white'))>0;
        I = I.*dvsByFrame(:,:,i);
        signal = [signal; mean(I(:))];
    end
end

