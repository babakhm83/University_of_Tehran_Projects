function out_image=mybinaryfun(in_image,thresh)
    out_image=in_image;
    w_ind=out_image>thresh;
    b_ind=out_image<thresh;
    ind=out_image==thresh;
    out_image(b_ind)=0;
    out_image(w_ind)=1;
    if(sum(w_ind,'all')>=sum(b_ind,'all'))
        out_image(ind)=0;
    else
        out_image(ind)=1;
    end
end