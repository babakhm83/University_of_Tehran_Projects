function [cluster,out_image]=mybfs(in_image,i,j)
    out_image=in_image;
    [WIDTH, HEIGHT]=size(in_image);
    out_image(i,j)=0;
    cluster=[i j];
    ind=1;
    while(ind<=size(cluster,1))
        i=cluster(ind,1);
        j=cluster(ind,2);
        ind=ind+1;
        for a=-1:1
            if(i+a>WIDTH || i+a<=0)
                continue;
            end
            for b=-1:1
                if(j+b>HEIGHT || j+b<=0)
                    continue;
                end
                if(a==0 && b==0)
                    continue;
                end
                if(out_image(i+a,j+b)==1)
                    out_image(i+a,j+b)=0;
                    cluster=[cluster;i+a,b+j];
                end
            end
        end
    end
end