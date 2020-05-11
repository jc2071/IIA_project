
clear
close all

xc = 0.50;
yc = 0.25;
gamma = 3.0;
nx = 51;
ny = 41;
x = linspace(-2.5,2.5,nx);
y = linspace(-2,2,ny);
[xg,yg] = meshgrid(x,y);


c = -0.4:0.2:1.2;
[C,h] = contour(xg,yg,psipv(xc,yc,gamma,xg,yg),c);
title("Point Vortex Stream Function " + '$\psi = \frac{\Gamma}{4\pi}log(r^2)$','Interpreter','latex');
clabel(C,h,c,'FontName','Times');
xlabel("x");
ylabel("y");
set(gca,'FontName','Times', 'FontSize',12);
%print (gcf, '/Users/MCJON/Documents/Part IIA SA1 Project/IIA_project/LaTeX/Week_1\Exercise_1_Contourplot', '-depsc' );