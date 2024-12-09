[x fs]=audioread('audio.wav');
figure;
plot(x);
xlabel('time');
audiowrite('x.wav',x,fs);