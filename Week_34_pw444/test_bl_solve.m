%  Zero pressure gradient b-l; bl_solv and Blasius
clc;
clear;
close all;

ReL = 1e7;

n = 100;
x = linspace(1/n,1,n);
cp = zeros(1,n);

[int, ils, itr, its, delstar, theta] = bl_solve ( x, cp, ReL );
blthet = 0.664 * sqrt(x/ReL); % blasius

if int~=0
  disp(['Natural transition at x = ' num2str(x(int))])
end

plot(x,blthet,'-',x,theta,'x')
xlabel('x/L')
ylabel('\theta/L')
legend('Blasius','blsolv')


