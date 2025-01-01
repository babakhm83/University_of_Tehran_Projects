fs=50;
T = 2;
N = fs * T;
t = linspace(-1, T-1-T/N, N);
f = linspace(-fs/2, fs/2-fs/N, N);
x1=cos(10*pi*t);
subplot(1,2,1);
plot(t,x1);
title('x1(t)=cos(10*\pi*t)');
xlabel('Time (s)');
ylabel 'Magnitude'
subplot(1,2,2);
X1=fftshift(fft(x1));
X1=X1/max(abs(X1));
plot(f,abs(X1));
title('X1(t)=fft(x1(t))');
xlabel('Frequency (Hz)');
ylabel 'Magnitude'
