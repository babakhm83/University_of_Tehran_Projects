function p4_4(x,speed)
    sz=size(x);
    sz(1)=floor(sz(1)/speed);
    y=zeros(sz);
    if speed>1
        z=speed;
        for i=1:size(y,1)
            y(i)=x(floor(z));
            z=z+speed;
        end
    else
        speed=1/speed;
        z=speed;
        j=2;
        for i=2:size(y,1)
            if i==ceil(z)
                y(i)=x(j);
                z=z+speed;
                j=j+1;
            else
                y(i)=(x(j-1)*(i-ceil(z-speed))+x(j)*(ceil(z)-i))/(ceil(z)-ceil(z-speed));
            end
        end
    end
    sound(y,48000)
end