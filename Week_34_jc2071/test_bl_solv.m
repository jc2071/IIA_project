%  Zero pressure gradient b-l; bl_solv and Blasius

clear all

Re = 10000000;

n = 100;
x = linspace(1/n,1,n);
cp = zeros(1,n);



[int, ils, itr, its ,delstar, theta] = bl_solv ( x, cp, Re );
blthet = 0.664 * sqrt(x/Re);

if int~=0
  disp(['Natural transition at x = ' num2str(x(int))])
end
figure(1)
plot(x,blthet,'-',x,theta,'x')
xlabel('x')
ylabel('\theta')
legend('Blasius','blsolv')


figure(2)
plot(x,delstar)

