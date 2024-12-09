clc;
clearvars;
tau=1e-6;
T=1e-5;
ts=1e-9;
t=0:ts:T-ts;
s_s=zeros(1,length(t));
s_s(1:floor(tau/ts))=1;
figure;
plot(t,s_s);
ylim([0 1.1])