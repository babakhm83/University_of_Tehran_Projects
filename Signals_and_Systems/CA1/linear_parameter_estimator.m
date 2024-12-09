function b = linear_parameter_estimator(x,y)
     x=[x;ones(size(x))];
     x=x';
     y=y';
     b = (x'*x)\(x'*y);
end
% function ab = linear_parameter_estimator(x,y)
%     fun=@(ab)sum((y-ab(1)*x-ab(2)).^2);
%     ab0=[1,0];
%     ab=fminsearch(fun,ab0);
% end