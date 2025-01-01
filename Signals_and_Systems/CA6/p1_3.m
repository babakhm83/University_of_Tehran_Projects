fs=100;
ts=1/fs;
t_start=0;
t_end=1;
T=t_end-t_start;
N = fs * T;
t = t_start:ts:t_end-ts;
f = -fs/2:fs/N:fs/2-fs/N;
fc=5;
alpha=0.5;
beta=0.3;
R=250000
V=180/3.6
fd=beta*V;
C=3e8;
Ro=2/C;
td=Ro*R;
x=alpha*cos(2*pi*(fc+fd)*(t-td));
X=fftshift(fft(x));
X=X/max(abs(X));
subplot(1,2,1);
plot(f,abs(X));
title('Received signal');
xlabel('Time (s)');
ylabel 'Magnitude';
tol = 1e-6;
X(abs(X) < tol) = 0;
theta = angle(X);
subplot(1,2,2);
plot(f,theta);
title('Received signal');
xlabel 'Frequency (Hz)';
ylabel 'Phase';
[M,new_freq]=max(X(length(X)/2+2+fc:length(X)));
new_freq=new_freq+fc;
new_phase=abs(angle(X(new_freq+length(X)/2+1)));
estimated_fd=new_freq-fc;
estimated_td=new_phase/(2*pi*(fc+estimated_fd));
estimated_V=estimated_fd/beta
estimated_R=estimated_td/Ro