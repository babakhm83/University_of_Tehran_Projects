clc;clear;
load Mapset Mapset;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif*.jfif'},'Choose an image');
img=imread([path file]);
img=rgb2gray(img);
msg='signal;';
coded_img=coding(msg,img,Mapset);
subplot(1,2,1);
imshow(img);
title('Original image');
subplot(1,2,2);
imshow(coded_img);
title('Coded image');
sum(coded_img-img,'all')