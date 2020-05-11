clear
close all

% Set parameters
xmin = 0;
xmax = 5;
nx = 51;

ymin = 0;
ymax = 4;
ny = 41;

% Panel Coordinates
xa = 3.5;
ya = 2.5;
xb = 1.6;
yb = 1.1;

%Create matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

%Obtain actual result
[infa, infb] = panelinf(xa, ya, xb, yb, xm, ym);

%For discrete approximation set up approximate result matrices
del = sqrt((xb-xa)^2+(yb-ya)^2);
nv = 100;
aprxinfa = zeros(size(xm));
aprxinfb = zeros(size(xm));

%Loop over each discrete vortex and seperate out the gamma_a and gamma_b
%coefficients
for k = 1:nv
    xc = xa + (k-0.5)/nv*(xb-xa);
    yc = ya + (k-0.5)/nv*(yb-ya);
    Gamma_a = (1-(k-0.5)/nv)*del/nv;
    Gamma_b = ((k-0.5)/nv)*del/nv;
    aprxinfa = aprxinfa + psipv(xc, yc, Gamma_a, xm , ym);
    aprxinfb = aprxinfb + psipv(xc, yc, Gamma_b, xm , ym);
end

% Plotting Options
c = -0.15:0.05:0.15;

figure(1)
fancyplotsubplot(xm, ym, infa, c, ...
    '$f_a$ contour plot due to panel', 'x', 'y', ...
     xm, ym, aprxinfa, c, '$f_a$ contour approximation', 'x', 'y',6,7)
 print (gcf, 'LaTeX/Week_1/graphs\e3g1', '-depsc' )
 
figure(2)
fancyplotsubplot(xm, ym, infb, c, ...
    '$f_b$ contour plot due to panel', 'x', 'y', ...
     xm, ym, aprxinfb, c, '$f_b$ contour approximation', 'x', 'y',6,7)
 print (gcf, 'LaTeX/Week_1/graphs\e3g2', '-depsc' )

