function coded_msg=coding_amp(msg,bit_rate)
    load Mapset.mat Mapset
    fs=100;
    ts=1/fs;
    bin='';
    for i=1:strlength(msg)
        c=extract(msg,i);
        bin=strcat(bin,Mapset{2,strcmp(Mapset(1, :), c)});
    end
    t=0:ts:strlength(bin)/bit_rate-ts;
    coded_msg=zeros(size(t));
    i=1;
    tsin=0:ts:1-ts;
    for j=1:bit_rate:length(bin)-bit_rate+1
        val=bin2dec(bin(j:j+bit_rate-1));
        coded_msg((i-1)*fs+1:i*fs)=val*sin(2*pi*tsin)/(2^bit_rate-1);
        i=i+1;
    end
    % plot(t,coded_msg);
end