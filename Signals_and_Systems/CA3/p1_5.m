clc;clear;
load Mapset Mapset;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
img=imread([path file]);
img=rgb2gray(img);
msg='signal;';
coded_img=coding(msg,img,Mapset);
n=100;
m=20;
correct=zeros(1,m);
first_wrong_img=-1;
first_wrong_i=-1;
first_wrong_msg=-1;
last_wrong_img=-1;
last_wrong_i=-1;
last_wrong_msg=-1;
for j=1:m
    for i=1:n
        noisy_img=coded_img+uint8(0.1*j*randn(size(coded_img)));
        decoded_msg=decoding(noisy_img,Mapset,ceil(log2(length(Mapset))));
        if(strcmp(msg,decoded_msg))
            correct(j)=correct(j)+1;
        else
            if(first_wrong_img==-1)
                first_wrong_img=noisy_img;
                first_wrong_i=j;
                first_wrong_msg=decoded_msg;
            end
            last_wrong_img=noisy_img;
            last_wrong_i=j;
            last_wrong_msg=decoded_msg;
        end
    end
    correct(j)=correct(j)/n;
end
figure;
plot(1:m,correct);
figure;
imshow(first_wrong_img);
caption = sprintf('This is the first wrong decoded message with %0.1fx noise: %s',first_wrong_i*0.1,first_wrong_msg);
title(caption, 'FontSize', 30);
figure;
imshow(last_wrong_img);
caption = sprintf('This is the last wrong decoded message with %0.1fx noise: %s',last_wrong_i*0.1,last_wrong_msg);
title(caption, 'FontSize', 30);