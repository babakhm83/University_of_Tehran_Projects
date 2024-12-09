function out_image=myremovecom(in_image,n)
    out_image=in_image;
    clusters_ind=myfindclusters(in_image);
    for i=1:length(clusters_ind)
        if(size(clusters_ind{i},1)<=n)
            ind=sub2ind(size(out_image),clusters_ind{i}(:,1),clusters_ind{i}(:,2));
            out_image(ind)=0;
        end
    end
end