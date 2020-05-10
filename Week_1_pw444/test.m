% Just a file to play around with

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

%Create spatial matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

%Define a surface & angle of attack
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta)./(xs*4+8) + 0.2*(1-xs.^2); % mess around with y to get a nice shape
alpha = pi/18;

%Calculate gamma vector. This assumes that we are in a free stream already
A = build_lhs(xs,ys);
b = build_rhs(xs,ys,alpha);
gam = A\b;

% Reshape gamma to be in k direction & calculate infa and infb arrays
gam = reshape(gam, 1, 1, np+1);
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), xm, ym);

%free stream + circulation on surface
psi = ( ym*cos(alpha) - xm*sin(alpha) ) ...
    + sum(infa.*gam(1:np) + infb.*gam(2:np+1), 3);

% Plot the streamfunction contours
c = -5:0.08:5;
contour(xm, ym, psi, c)
hold on
plot(xs, ys)
hold off
daspect([1 1 1])