function decision=mydecisionmaker2(in_image)
    load TRAININGSET TRAIN;
    n_seg=max(in_image,[],"all");
    decision=[];
    [width,height]=size(TRAIN{1,1});
    for n=1:n_seg
        [row,col]=find(in_image==n);
        seg_image=zeros(size(in_image));
        seg_image(sub2ind(size(seg_image),row,col))=1;
        Y=seg_image(min(row):max(row),min(col):max(col));
        imshow(Y);
        Y=imresize(Y,[width,height]);
        imshow(Y);
        ro=zeros(1,length(TRAIN));
        for k=1:length(TRAIN)   
            ro(k)=corr2(TRAIN{1,k},Y);
        end
        [MAXRO,pos]=max(ro);
        if MAXRO>.47
            out=TRAIN{2,pos};       
            decision=[decision out];
        end
    end
end