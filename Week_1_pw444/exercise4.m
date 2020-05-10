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

%Create matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

%Define the cylinder and its circulation
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta);
gammas = -2*sin(theta);

% Reshape gamma into k-index vector
gammas = reshape(gammas, 1, 1, np+1);

% psi due to free stream
psi = ym;

% psi due to np panels.
% first calculate 3D array infa & infb, each sheet is a different panel
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), xm, ym);
% then multiply by gamma (k-vector) and sum along k axis
psi = psi + sum(infa.*gammas(1:np) + infb.*gammas(2:np+1), 3);

% Plot the streamfunction contours
c = -1.75:0.05:1.75;
contour(xm, ym, psi, c)
hold on
plot(xs, ys)
hold off
daspect([1 1 1])