
clear
close all

r = 1;
N = 100;
theta = (0:N)*2*pi/N;

xs = r*cos(theta); % surface of cyclinder x
ys = r*sin(theta); % surface of cyclinder y 

alpha = pi/18;

A = build_lhs(xs,ys);
b = build_rhs(xs, ys, alpha);
gam = inv(A)*b;

plot(theta/pi, gam, 'color' , 'red');
title("Total circulation as fucntion of theta",'Interpreter','latex');
%xticks([0 1/2 1 3/2 2])
%xticklabels({'0','\pi/2' '\pi', '3\pi/2' '2\pi'})
xlabel("x");
ylabel("y");
axis normal
set(gca,'fontname','Latin Modern Math');




