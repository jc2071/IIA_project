%Script file for Exercise 5

%Reset Workspace
clear
close all

%Define the cylinder and its circulation
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta);
alpha = pi/18;

%Calculate gamma vector
A = build_lhs(xs,ys)
b = build_rhs(xs,ys,alpha)
gam = A\b;

%For total circulation - if np is big Gam2 is close to Gam
panel_length = sqrt(2*r^2*(1-cos(2*pi/np)));
Gam = sum(gam(1:np))*(panel_length) %#ok<NOPTS>
Gam2 = sum(gam(1:np))*(2*pi*r)/np %#ok<NOPTS>

%Plot gamma values against theta/pi
plot(theta/pi, gam);
axis([0 2 -2.5 2.5]);