clear
close all

% Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 51;

ymin = -2;
ymax = 2;
ny = 41;

% Vortex parameters
Gamma = 3;
xc = 0.5;
yc = 0.25;

% Create x, y and psi matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);
psi = psipv(xc, yc, Gamma, xm, ym);

% Generate contour plot
c = -0.4:0.2:1.2;
[C,h] = contour( xm, ym, psipv(xc ,yc, Gamma, xm, ym), c );
title("Point Vortex Stream Function " + ...
    '$\psi = \frac{\Gamma}{4\pi}log(r^2)$','Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times')
set(gca,'fontname','Times', 'FontSize',12);
print (gcf, 'LaTeX/Week_1\e1g1', '-depsc' )