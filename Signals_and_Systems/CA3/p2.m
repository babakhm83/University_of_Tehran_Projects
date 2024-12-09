clc;clear;[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose the PCB image');
pcb=imread([path file]);
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose the IC image');
ic=imread([path file]);
img=ICrecognition(pcb,ic);
imshow(img);