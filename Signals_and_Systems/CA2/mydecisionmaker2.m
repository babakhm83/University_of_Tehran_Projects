function decision=mydecisionmaker2(in_image)
    load TRAININGSET TRAIN;
    n_seg=max(in_image,[],"all");
    decision=[];
    [width,height]=size(TRAIN{1,1});
    for n=1:n_seg
        [row,col]=find(in_image==n);
        seg_image=zeros(size(in_image));
        seg_image(sub2ind(size(seg_image),row,col))=1;
        seg_image=~seg_image;
        Y=seg_image(min(row):max(row),min(col):max(col));
        imshow(Y);
        Y=imresize(Y,[width,height]);
        imshow(Y);
        ro=zeros(1,length(TRAIN));
        k=13:length(TRAIN);
        len_decision=length(decision);
        if(len_decision==2)
            k=1:12;
        end
        for i=k
            ro(i)=corr2(TRAIN{1,i},Y);
        end
        [MAXRO,pos]=max(ro);
        if MAXRO>.7
            out=TRAIN{2,pos};
            if(length(decision)<2)
                decision=[decision,out];
            elseif(length(decision)==2)
                decision=[out,decision];
            else
                decision=[decision(1:len_decision-3),out,decision(len_decision-2:len_decision)];
            end
        end
    end
end