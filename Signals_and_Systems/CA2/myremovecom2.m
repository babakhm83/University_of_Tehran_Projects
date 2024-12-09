function out_image=myremovecom2(in_image,n,m)
    out_image=in_image;
    clusters_ind=myfindclusters(in_image);
    for i=1:length(clusters_ind)
        if(size(clusters_ind{i},1)<=n || size(clusters_ind{i},1)>=m)
            ind=sub2ind(size(out_image),clusters_ind{i}(:,1),clusters_ind{i}(:,2));
            out_image(ind)=0;
        end
    end
end
