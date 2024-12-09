clc;close all;clear;
% 1. Load the target image
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
target=imread([path file]);
figure;
imshow(target);

% 2. Resize the target image
WIDTH=600;
HEIGHT=900;
target=imresize(target,[WIDTH,HEIGHT]);
imshow(target);

% 3. RGB2Gray the target image
target=mygrayfun(target);
imshow(target);

% 4. Binarizing the target image
thresh=90;
target=mybinaryfun(target,thresh);
imshow(target*255);
target=~target;
imshow(target*255);
picture=target;

% 6. Remove noise from the edges
target=myremovecom2(target,5,900);
imshow(target*255);

% 5. Find the vertical edges in the target image
target2=target;
target2(1:size(target,1),1:size(target,2)-1)=target(1:size(target,1),2:size(target,2));
imshow(target2);
dif_target=abs(target2-target);
imshow(dif_target);

% 7. Find area with most edges
box_width=80;
box_height=400;
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

% 8. Resize the plate
target=picture(max_i1:max_i2,max_j1:max_j2);
WIDTH=300;
HEIGHT=500;
target=imresize(target,[WIDTH,HEIGHT]);
imshow(target);

% 9. Removing clusters with less than n pixels from the plate
target=myremovecom(target,500);
imshow(target*255);

% 10. Segmenting the clusters
target=mysegmentation(target);
cluster_target=zeros(size(target));

% 11. Extract letters and numbers 
files=dir('MapSetFa2');
len=length(files)-2;
TRAIN=cell(2,len);

for i=1:len
   TRAIN{1,i}=imread([files(i+2).folder,'\',files(i+2).name]);
   TRAIN{2,i}=files(i+2).name(1);
end
save TRAININGSET TRAIN;

decision=mydecisionmaker3(target);

% 12. Report decision
display(decision);
file = fopen('number_plate.txt', 'wt');
fprintf(file,'%s\n',decision);
fclose(file);
winopen('number_Plate.txt')