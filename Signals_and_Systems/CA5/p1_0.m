fs=20;
T = 1;
N = fs * T;
t = linspace(0, T-T/N, N);
f = linspace(-fs/2, fs/2-fs/N, N);
x1=exp(1j*2*5*pi*t)+exp(1j*2*8*pi*t);
x2=exp(1j*2*5*pi*t)+exp(1j*2*5.1*pi*t);
X1 = fftshift(fft(x1));
X1=X1/max(abs(X1));
X2 = fftshift(fft(x2));
X2=X2/max(abs(X2));
plot(f,abs(X1));
hold on;
plot(f,abs(X2/max(abs(X2))));
title('Magnitude of Signals');
xlabel('Frequency (Hz)');
legend(['X1[f]';'X2[f]'])
ylabel 'Magnitude'
hold off;