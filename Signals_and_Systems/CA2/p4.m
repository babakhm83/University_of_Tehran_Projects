clc;close all;clear;
% 1. Load the target image
[file,path]=uigetfile({'*.mp4;*.mkv'},'Choose a video');
target=([path file]);
vid = VideoReader(target);
first_ind=40;
last_ind=60;
first_frame = read(vid,first_ind);
after_frame = read(vid,last_ind);
num_frames=vid.NumFrames-20;
imshow(after_frame)

[min_shift_dif_i,edited_first_frame]=find_plate(first_frame,after_frame);

speed=(min_shift_dif_i)*vid.FrameRate/(last_ind-first_ind);
fprintf("the speed is %f pixels per second", speed);

function [min_i,picture]=find_plate(target,next_frame)
    % 2. Resize the target image
    WIDTH=600;
    HEIGHT=900;
    target=imresize(target,[WIDTH,HEIGHT]);
    imshow(target);
    next_frame=imresize(next_frame,[WIDTH,HEIGHT]);
    
    % 3. RGB2Gray the target image
    target=mygrayfun(target);
    imshow(target);
    next_frame=mygrayfun(next_frame);
    
    % 4. Binarizing the target image
    thresh=90;
    target=mybinaryfun(target,thresh);
    imshow(target*255);
    target=~target;
    imshow(target*255);
    picture=target;
    next_frame=mybinaryfun(next_frame,thresh);
    next_frame=~next_frame;
    
    % 5. Find the vertical edges in the target image
    target2=next_frame;
    dif_target=abs(target2-target);
    imshow(dif_target);
    
    % 6. Remove noise from the edges
    dif_target=myremovecom(dif_target,50);
    imshow(dif_target*255);
    
    % 7. Find area with most edges
    box_width=100;
    box_height=300;
    max_i1=1;
    max_j1=1;
    max_dif=0;
    for i = 1:(WIDTH - box_width + 1)
        for j = 1:(HEIGHT - box_height + 1)
            submatrix = dif_target(i:i + box_width - 1, j:j + box_height - 1);
            dif = sum(submatrix(:));
            if dif >= max_dif
                max_dif = dif;
                max_i1 = i;
                max_j1 = j;
            end
        end
    end
    max_i2=WIDTH - box_width + 1;
    max_j2=HEIGHT - box_height + 1;
    max_dif=0;
    for i = fliplr(box_width:WIDTH)
        for j = fliplr(box_height:HEIGHT)
            submatrix = dif_target(i - box_width + 1:i, j - box_height + 1:j);
            dif = sum(submatrix(:));
            if dif >= max_dif
                max_dif = dif;
                max_i2 = i;
                max_j2 = j;
            end
        end
    end
    imshow(dif_target);
    hold on;
    rectangle('Position', [max_j1,max_i1,box_height-1,box_width-1], 'EdgeColor', 'r', 'LineWidth', 2);
    rectangle('Position', [max_j2-box_height+1,max_i2-box_width+1,box_height-1,+box_width-1], 'EdgeColor', 'g', 'LineWidth', 2);
    hold off;

    n=100;
    min_i=1;
    min_val=100000;
    sub_dif=sum(dif_target(max_i1:max_i2,max_j1:max_j2),"all");
    target=target(max_i1:max_i2,max_j1:max_j2);
    for i=1:n
        target3=target;
        target3(1:size(target,1),1:size(target,2)-i)=target(1:size(target,1),i+1:size(target,2));
        dif_target2=abs(target3-target);
        dif_target2=myremovecom(dif_target2,50);
        sub_dif2=sum(dif_target2,"all");
        val=abs(sub_dif2-sub_dif);
        if(val<min_val)
            min_val=val;
            min_i=i;
        end
    end
end