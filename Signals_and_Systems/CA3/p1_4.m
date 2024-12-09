clc;clear;
load Mapset Mapset;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
img=imread([path file]);
img=rgb2gray(img);
msg='signal;';
coded_img=coding(msg,img,Mapset);
decoding(coded_img,Mapset,ceil(log2(length(Mapset))))