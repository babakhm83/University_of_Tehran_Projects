t=0:0.01:1;
z1=sin(2*pi*t);
z2=cos(2*pi*t);

figure;
subplot(1,2,1);
plot(t,z1,'--b')
title('Sin'); % Title
legend('sin')
xlabel('time') % the name of X-axis
ylabel('amplitude') % the name of Y-axis
grid on % Add grid

x0=[0.5 0.2];
s='sin(2 \pi t)';
text(x0(1), x0(2), s);
% hold on

subplot(1,2,2);
plot(t,z2,'r')
title('Cos'); % Title
legend('cos')
xlabel('time') % the name of X-axis
ylabel('amplitude') % the name of Y-axis
grid on % Add grid

y0=[0.25 -0.8];
s='cos(2 \pi t)';
text(y0(1), y0(2), s);