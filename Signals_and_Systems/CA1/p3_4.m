tau=1e-6;
T=1e-5;
ts=1e-9;
t=0:ts:T-ts;
s_s=zeros(1,length(t));
s_s(1:int64(tau/ts))=1;
alpha=0.5;
R=450;
c=3e8;
td=2*R/(c);
t=0:ts:T+td-ts;
r_s=zeros(1,length(t));
r_s(td/ts+1:int64((tau+td)/ts)+1)=alpha;

n=200;
error=zeros(1,n);
for i=1:n
    for j=1:100
        s=r_s+0.1*i*rand(size(r_s));
        r=distance_from_signal_using_correlation(s_s,s,ts,tau);
        error(i)=error(i)+abs(r-R);
    end
end
error=error./100;
figure;
yline(10,'--b')
hold on
plot(error)
wrongs=find(error>=10);
wrongs(1)