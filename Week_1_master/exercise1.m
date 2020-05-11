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
fancyplot(xm, ym, psi, c, ...
  'Point Vortex Stream Function $\psi = \frac{\Gamma}{4\pi}log(r^2)$',...
  'x', 'y') 

print (gcf, 'LaTeX/Week_1/graphs\e1g1', '-depsc' )