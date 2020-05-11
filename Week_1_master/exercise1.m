%Reset Workspace
clear
close all

%Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 51;

ymin = -2;
ymax = 2;
ny = 41;

Gamma = 3;
xc = 0.5;
yc = 0.25;

%Create x, y and psi matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);
psi = psipv(xc, yc, Gamma, xm, ym);

%Generate contour plot
c = -0.4:0.2:1.2;
contour(xm, ym, psi,c)
print (gcf, 'LaTeX/Week_1\e1g1', '-depsc' )