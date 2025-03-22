syms y(t) x(t)
Dy = diff(y);
D2y = diff(y, t, 2);

ode = D2y + 3*Dy + 2*y == 5;
cond1 = y(0) == 1;
cond2 = Dy(0) == 1;
conds = [cond1, cond2];

ySol(t) = dsolve(ode, conds);

disp(ySol);
fplot(ySol, [0, 10]); 
xlabel('time');
ylabel('y(t)');
grid on;