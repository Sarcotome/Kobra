function [x,y,type, pol]=extractFrameCoordinates(AE,xMask,yMask,typeMask,polMask)
% extracts x,y,type addresses of events given raw addresses AE and x and y
% masks and type mask. type maks is optional and if ommited type is not
% extracted

x=zeros(size(AE));
y=zeros(size(AE));
pol=zeros(size(AE));
type=zeros(size(AE));

AE=double(AE);
for i=32:-1:1
    if (bitget(xMask,i)==1)
        x=bitshift(x,1);
        x=bitor(bitget(AE,32),x);
    end
    if (bitget(yMask,i)==1)
        y=bitshift(y,1);
        y=bitor(bitget(AE,32),y);
    end
    if (bitget(polMask,i)==1)
        pol=bitshift(pol,1);
        pol=bitor(bitget(AE,32),pol);
    end
    if (bitget(typeMask,i)==1)
        type=bitshift(type,1);
        type=bitor(bitget(AE,32),type);
    end
    AE=bitshift(AE,1);
end
