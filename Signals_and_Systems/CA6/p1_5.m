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
R1=250000;
V1=180/3.6;
fd1=beta*V1;
td1=Ro*R1;
alpha2=0.6;
R2=200000;
V2=216/3.6;
fd2=beta*V2;
td2=Ro*R2;
C=3e8;
Ro=2/C;
x1=alpha1*cos(2*pi*(fc+fd1)*(t-td1));
x2=alpha2*cos(2*pi*(fc+fd2)*(t-td2));
plot(t,x1+x2);
title('Received signal for two objects');
xlabel('Time (s)');
ylabel 'x(t)';