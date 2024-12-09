function clusters=myfindclusters(in_image)
    bfs_image=in_image;
    clusters={};
    num_obj=1;
    [WIDTH,HEIGHT]=size(in_image);
    for j=1:HEIGHT
        for i=1:WIDTH
            if(bfs_image(i,j)==1)
                [new_obj_ind,bfs_image]=mybfs(bfs_image,i,j);
                clusters{num_obj}=new_obj_ind;
                num_obj=num_obj+1;
            end
        end
    end
end