clc;close all;clear;
% 1. Load the target image
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
target=imread([path file]);
figure;
imshow(target);
figure;

% 2. Resize the target image
WIDTH=300;
HEIGHT=500;
target=imresize(target,[WIDTH,HEIGHT]);
imshow(target);

% 3. RGB2Gray the target image
target=mygrayfun(target);
imshow(target);

% 4. Binarizing the target image
thresh=graythresh(target)*255;
target=mybinaryfun(target,thresh);
imshow(target*255);
target=~target;
imshow(target*255);

% 5. Removing clusters with less than n pixels from the target image
target=myremovecom(target,500);
imshow(target*255);

% 6. Segmenting the clusters
target=mysegmentation(target);
cluster_target=zeros(size(target));

% 7. Extract letters and numbers 
files=dir('MapSetFa2');
len=length(files)-2;
TRAIN=cell(2,len);

for i=1:len
   TRAIN{1,i}=imread([files(i+2).folder,'\',files(i+2).name]);
   TRAIN{2,i}=files(i+2).name(1);
end
save TRAININGSET TRAIN;

decision=mydecisionmaker2(target);

% 8. Report decision
display(decision);
file = fopen('number_plate.txt', 'wt');
fprintf(file,'%s\n',decision);
fclose(file);
winopen('number_Plate.txt')