function coded_img=coding(msg,img,map)
    shifted_img=img;
    width=size(img,1);
    height=size(img,2);
    shifted_img(1:width-1,1:height-1)=img(2:width,2:height);
    dif_img=abs(shifted_img-img);
    block_len=log2(length(map));
    width=width-mod(width,block_len);
    height=height-mod(height,block_len);
    blocks_sum_dif=zeros([width/block_len,height/block_len],'uint16');
    for i=1:width
        for j=1:height
            blocks_sum_dif(floor((i-1)/block_len)+1,floor((j-1)/block_len)+1)=blocks_sum_dif(floor((i-1)/block_len)+1,floor((j-1)/block_len)+1)+uint16(dif_img(i,j));
        end
    end
    idx=find(blocks_sum_dif(:).'>median(blocks_sum_dif(:)));
    i=1;
    j=1;
    coded_img=img;
    while(j<=strlength(msg))
        if(i>length(idx))
            error('ERROR: The message is too long.');
        end
        [x,y]=ind2sub(size(blocks_sum_dif),idx(i));
        x=(x-1)*block_len+1;
        y=(y-1)*block_len+1;
        i=i+1;
        for k=1:block_len
            c=msg(j);
            bin=map{2,strcmp(map(1, :), c)};
            for m=1:block_len
                color=dec2bin(coded_img(x+k,y+m),block_len);
                color(block_len)=bin(m);
                coded_img(x+k,y+m)=bin2dec(color);
            end
            j=j+1;
            if(j>length(msg))
                break;
            end
        end
    end
end