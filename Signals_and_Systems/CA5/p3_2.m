clc;clearvars;
msg='signal';
ts=1/100;
coded=coding_freq(msg,1);
subplot(1,2,1);
t=0:ts:strlength(msg)*5-ts;
plot(t,coded);
subplot(1,2,2);
coded=coding_freq(msg,5);
t=0:ts:strlength(msg)-ts;
plot(t,coded);