clc;clearvars;
noise=randn(1,3000);
mean(noise)
var(noise)
figure;
plot(noise);
figure;
histogram(noise);