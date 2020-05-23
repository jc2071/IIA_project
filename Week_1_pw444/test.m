% Just a file to play around with

%Reset Workspace
clear; close all; clc

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
np = 30;
% r = 1;
theta = (0:np)*2*pi/np;
% xs = r*cos(theta);
% ys = r*sin(theta)./(xs*4+8) + 0.2*(1-xs.^2); % mess around with y to get a nice shape

aoa = 23;
alpha = -aoa*pi/180;

R = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];



%-- makes JOUKOWSKI AEROFOILS --
% + imaginary gives camber
% - real gives thicknes 

a = 1;
c = 0.1;
r = a*(1 +c);
z = -a*c + 1.3i*a*c + r*exp(1i*theta);
zeta = z + (a^2)./z;
xs_temp = real(zeta);
ys_temp = imag(zeta);
m = [xs_temp;ys_temp];

points = R*m;
xs = points(1,:);
ys = points(2,:);
%Calculate gamma vector. This assumes that we are in a free stream already
A = build_lhs(xs,ys);
b = build_rhs(xs,ys,0);
gam = A\b;


% Reshape gamma to be in k direction & calculate infa and infb arrays
gamk = reshape(gam, 1, 1, np+1);
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), xm, ym);

%free stream + circulation on surface
psi = ( ym*cos(0) - xm*sin(0) ) ...
    + sum(infa.*gamk(1:np) + infb.*gamk(2:np+1), 3);


% Now work out cp to get some nice visuals, use meshgrid xm, ym

cp = zeros(ny-1,nx-1);

for i = 1:ny -1
    for j = 1:nx -1
        dpsiy = (psi(i+1,j) - psi(i,j))/ (x(i+1) - x(i));
        dpsix = (psi(i,j+1) - psi(i,j+1))/ (y(i+1) - y(i));
        cp(i,j) = 1 - dpsix^2 - dpsiy^2;
    end
end

cp_foil = zeros(1,nx -1);

for i = 1:length(ys_temp) -1;
    for j = 1:length(xs_temp) -1;
        dpsix = (psi(i,j+1) - psi(i,j+1))/ (y(i+1) - y(i));
        cp_foil(1,j) = 1 - dpsix^2;
    end
end

% Plot the streamfunction contours
c = -10:0.1:10;
%[C,h] = contourf(xm, ym, psi, c);
[C,h] = contourf(xm(1:end-1,1:end-1),ym(1:end-1,1:end-1),cp,c);
set(h,'LineColor','none')
hold on
%d = zeros(size(xs));
%surface([xs;xs],[ys;ys],[d;d], -[gam';gam'].^2+3,'facecol','black','edgecol','interp','linew',2);
fill(xs,ys,[1 1 1])
plot(xs,ys, 'color','black', 'linewidth', 1.5)
hold off
%surf(xm, ym, psi-0.1853)
daspect([1 1 1])

figure(2)
plot(xs_temp(1:end-1), cp_foil)