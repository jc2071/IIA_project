
clear
close all

r = 1;
N = 100;
theta = (0:N)*2*pi/N;

xs = r*cos(theta); % surface of cyclinder x
ys = r*sin(theta); % surface of cyclinder y 

x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);

alpha = pi/18;

A = build_lhs(xs,ys);
b = build_rhs(xs, ys, alpha);
gam = inv(A)*b

plot(theta/pi, gam);





