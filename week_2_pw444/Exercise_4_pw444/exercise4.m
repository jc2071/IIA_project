%Script file for Exercise 4

%Reset Workspace
clear
close all

%Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 251;
ymin = -2;
ymax = 2;
ny = 201;

%Define the cylinder and its circulation
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta);
gamma_s = -2*sin(theta);

%Create matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

psi = ym; % free stream
for p = 1:np %loop over the panels
[infa, infb] = panelinf(xs(p), ys(p), xs(p+1), ys(p+1), xm, ym);
psi = psi + gamma_s(p)*infa + gamma_s(p+1)*infb;
end

c = -1.75:0.05:1.75;
contour(xm, ym, psi, c)
hold on
plot(xs, ys)
hold off
daspect([1 1 1])