function img=ICrecognition(pcb,ic)
    pcb=rgb2gray(pcb);
    ic=rgb2gray(ic);
    box_width=size(ic,1);
    width=size(pcb,1);
    box_height=size(ic,2);
    height=size(pcb,2);
    img=pcb;
    ic=double(ic);
    pcb=double(pcb);
    norm2=sum(ic.^2,"all");
    correlation=zeros((width - box_width + 1),(height - box_height + 1));
    rot_correlation=zeros((width - box_width + 1),(height - box_height + 1));
    rot_ic=rot90(ic,2);
    rot_norm2=sum(ic.^2,"all");
    for i = 1:(width - box_width + 1)
        for j = 1:(height - box_height + 1)
            subpcb = pcb(i:i + box_width - 1, j:j + box_height - 1,:);
            norm1=sum(subpcb.^2,"all");
            norm=sqrt(norm1*norm2);
            cor = subpcb .* ic ./ norm;
            cor=sum(cor,'all');
            correlation(i,j)=cor;
            rot_norm=sqrt(norm1*rot_norm2);
            cor = subpcb .* rot_ic ./ rot_norm;
            cor=sum(cor,'all');
            rot_correlation(i,j)=cor;
        end
    end
    thresh=mean(correlation(:))+3*std(correlation(:));
    rot_thresh=mean(rot_correlation(:))+3*std(rot_correlation(:));
    for i = 1:(width - box_width + 1)
        for j = 1:(height - box_height + 1)
            if(correlation(i,j)>thresh)
                img = insertShape(img, 'Rectangle', [j,i,box_height-1,box_width-1], 'Color', 'blue', 'LineWidth', 3);
                correlation(i:i + box_width - 1, j:j + box_height - 1,:)=0;
            end
            if(rot_correlation(i,j)>rot_thresh)
                img = insertShape(img, 'Rectangle', [j,i,box_height-1,box_width-1], 'Color', 'blue', 'LineWidth', 3);
                rot_correlation(i:i + box_width - 1, j:j + box_height - 1,:)=0;
            end
        end
    end
end