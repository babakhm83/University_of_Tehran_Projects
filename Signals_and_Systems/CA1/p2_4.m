p2=load('p2.mat');

x=[-1:0.01:1];
a=3;
b=1;
y0=a*x+b;
linear_parameter_estimator(x,y0)
y1=y0+randn(size(y0));
linear_parameter_estimator(x,y1)
linear_parameter_estimator(p2.x,p2.y)