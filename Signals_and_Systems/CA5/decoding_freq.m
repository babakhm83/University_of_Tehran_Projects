function decoded_msg=decoding_freq(coded,bit_rate)
    load Mapset.mat Mapset
    bit_len_map=strlength(Mapset{2, 1});
    decoded_msg='';
    fs=100;
    % ts=1/fs;
    % tsin=0:ts:1-ts;
    f=(fs/2-1)/(2^bit_rate-1);
    bin='';
    for i=1:fs:length(coded)-fs+1
        fft_coded=fftshift(fft(coded(i:i+fs-1)));
        max_f_val=0;
        max_f_idx=0;
        for j=0:(2^bit_rate-1)
            fi=floor(j*f);
            if(fi==0)
                fi=fi+1;
            end
            if(max_f_val<abs(fft_coded(fi+fs/2+1)))
                max_f_val=abs(fft_coded(fi+fs/2+1));
                max_f_idx=j;
            end
        end
        bin=strcat(bin,dec2bin(max_f_idx,bit_rate));
    end
    index=1;
    for i=1:bit_len_map:strlength(bin)-bit_len_map+1
        decoded_msg=strcat(decoded_msg,Mapset{1,strcmp(Mapset(2, :), bin(i:i+bit_len_map-1))});
        index=index+1;
    end
end