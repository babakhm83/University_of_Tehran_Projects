fs=100;
ts=1/fs;
t_start=0;
t_end=1;
T=t_end-t_start;
N = fs * T;
t = t_start:ts:t_end-ts;
f = -fs/2:fs/N:fs/2-fs/N;
fc=5;
beta=0.3;
alpha1=0.5;
R1=250000
V1=180/3.6
fd1=beta*V1;
td1=Ro*R1;
alpha2=0.6;
R2=200000
V2=216/3.6
fd2=beta*V2;
td2=Ro*R2;
C=3e8;
Ro=2/C;
x1=alpha1*cos(2*pi*(fc+fd1)*(t-td1));
x2=alpha2*cos(2*pi*(fc+fd2)*(t-td2));
x=x1+x2;
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
[M,new_freq1]=max(X(length(X)/2+2+fc:length(X)));
new_freq1=new_freq1+fc;
arg_max=new_freq1+length(X)/2+1;
new_phase1=abs(angle(X(arg_max)));
estimated_fd1=new_freq1-fc;
estimated_td1=new_phase1/(2*pi*(fc+estimated_fd1));
estimated_V1=estimated_fd1/beta
estimated_R1=estimated_td1/Ro
X(arg_max)=0;
[M,new_freq2]=max(X(length(X)/2+2+fc:length(X)));
new_freq2=new_freq2+fc;
new_phase2=abs(angle(X(new_freq2+length(X)/2+1)));
estimated_fd2=new_freq2-fc;
estimated_td2=new_phase2/(2*pi*(fc+estimated_fd2));
estimated_V2=estimated_fd2/beta
estimated_R2=estimated_td2/Ro