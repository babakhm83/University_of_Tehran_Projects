function decoded_msg=decoding_amp(coded,bit_rate)
    load Mapset.mat Mapset
    bit_len_map=strlength(Mapset{2, 1});
    decoded_msg='';
    fs=100;
    ts=1/fs;
    len=2^bit_rate;
    tsin=0:ts:1-ts;
    bin='';
    for i=1:fs:length(coded)-fs+1
        ro=round(ts*sum(coded(i:i+fs-1).*sin(2*pi*tsin),'all')*(len-1)*2);
        bin=strcat(bin,dec2bin(ro,bit_rate));
    end
    index=1;
    for i=1:bit_len_map:strlength(bin)-bit_len_map+1
        decoded_msg=strcat(decoded_msg,Mapset{1,strcmp(Mapset(2, :), bin(i:i+bit_len_map-1))});
        index=index+1;
    end
end