function out_image=mysegmentation(in_image)
    out_image=zeros(size(in_image));
    clusters_ind=myfindclusters(in_image);
    for i=1:length(clusters_ind)
        ind=sub2ind(size(out_image),clusters_ind{i}(:,1),clusters_ind{i}(:,2));
        out_image(ind)=i;
    end
end