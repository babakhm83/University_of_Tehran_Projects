tau=1e-6;
T=1e-5;
ts=1e-9;
t=0:ts:T-ts;
s_s=zeros(1,length(t));
s_s(1:int64(tau/ts))=1;
figure;
plot(t,s_s)
hold on
alpha=0.5;
R=450;
c=3e8;
td=2*R/(c);
t=0:ts:T+td-ts;
r_s=zeros(1,length(t));
r_s(td/ts+1:int64((tau+td)/ts)+1)=alpha;
plot(t,r_s)
legend('SentSignal','ReceivedSignal')