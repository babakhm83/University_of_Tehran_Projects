function p4_3(x,speed)
    if speed==2
       sound(x(1:2:end,:),48000)
    elseif speed==0.5
        y=[x(1)];
        for i=2:size(x,1)
            y=[y;(x(i-1)+x(i))/2;x(i)];
        end
        sound(y,48000)
    else
        error('Invalid value for speed');
    end
end