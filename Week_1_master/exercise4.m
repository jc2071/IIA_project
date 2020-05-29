clear
close all

%Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 51;
ymin = -2;
ymax = 2;
ny = 41;

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

% Reshape gamma into k-vector
gammas = reshape(gammas, 1, 1, np+1);

% Calculate influence coefficients. N.B infa, infb is a 3D array
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), xm, ym);

% Multiply gammas by influence coefficients and add free stream
% contribution ym
psi = ym + sum(infa.*gammas(1:np) + infb.*gammas(2:np+1), 3);

% Plot the streamfunction contours
c = -1.75:0.25:1.75;
fancyplot(xm, ym, zeros(size(xm)), 0, '', 'x', 'y')
hold on
contour(xm, ym, psi, c)
plot(xs, ys)
hold off
print (gcf, 'LaTeX/Week_1/graphs\e4g1', '-depsc' )