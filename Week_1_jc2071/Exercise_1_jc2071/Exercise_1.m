
clear
close all

xc = 0.50;
yc = 0.25;
gamma = 3.0;
N = 1000;
x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);
[xg,yg] = meshgrid(x,y);

c = -0.4:0.2:1.2;
[C,h] = contour(xg,yg,psipv(xc,yc,gamma,xg,yg),c);
title("Point Vortex Stream Function " + '$\psi = \frac{\Gamma}{4\pi}log(r^2)$','Interpreter','latex');
xlabel("x");
ylabel("y");
text(-2.3,-1.8,'Vortex at x = 0.5, y = 0.25','FontName','Latin Modern Math')
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math', 'FontSize',12, 'TickLabelInterpreter','latex');
print('-painters','-depsc','tester.eps')
