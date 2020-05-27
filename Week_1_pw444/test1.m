% Just a file to play around with

%Reset Workspace
clear
close all

%Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 101;
ymin = -2;
ymax = 2;
ny = 81;

%Create spatial matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

%Define a surface & angle of attack
np = 100;
% r = 1;
theta = (0:np)*2*pi/np;
% xs = r*cos(theta);
% ys = r*sin(theta)./(xs*4+8) + 0.2*(1-xs.^2); % mess around with y to get a nice shape
alpha = pi/18;

%-- makes JOUKOWSKI AEROFOILS --
% + imaginary gives camber
% - real gives thicknes 

a = 1;
c = 0.1;
r = a*(1 +c);
z = -a*c + 1.3i*a*c + r*exp(1i*theta);
zeta = z + (a^2)./z;
xs = real(zeta);
ys = imag(zeta);


%Calculate gamma vector. This assumes that we are in a free stream already
A = build_lhs(xs,ys);
b = build_rhs(xs,ys,alpha);
gam = A\b;
gam = [gam(end);zeros(19,1);gam(21:end)];

% Reshape gamma to be in k direction & calculate infa and infb arrays
gamk = reshape(gam, 1, 1, np+1);
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), xm, ym);

%free stream + circulation on surface
psi = ( ym*cos(alpha) - xm*sin(alpha) ) ...
    + sum(infa.*gamk(1:np) + infb.*gamk(2:np+1), 3);


% Plot the streamfunction contours
c = -100:0.06:100;
contour(xm, ym, psi, c)
hold on
d = zeros(size(xs));
surface([xs;xs],[ys;ys],[d;d], -[gam';gam'].^2+3,'facecol','no','edgecol','interp','linew',2);
plot(xs,ys, 'color','magenta')
%hold off
%surf(xm, ym, psi-0.1853)
daspect([1 1 1])