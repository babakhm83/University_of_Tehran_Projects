fs=100;
T = 1;
N = fs * T;
t = linspace(0, T-T/N, N);
f = linspace(-fs/2, fs/2-fs/N, N);
x1=cos(30*pi*t+pi/4);
subplot(1,2,1);
plot(t,x1);
title('x1(t)=cos(30*pi*t+\pi/4)');
xlabel('Time (s)');
subplot(1,2,2);
X1=fftshift(fft(x1));
X1=X1/max(abs(X1));
plot(f,abs(X1));
title('X1(t)=fft(x1(t))');
ylabel 'Magnitude'
xlabel('Frequency (Hz)');
tol = 1e-6;
X1(abs(X1) < tol) = 0;
theta = angle(X1);
plot(f,theta/pi)
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'