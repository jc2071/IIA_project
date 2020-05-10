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
A = build_lhs(xs,ys);
b = build_rhs(xs,ys,alpha);
gam = A\b;

%Total circulation
Gam = total_circulation(xs, ys, gam);
Gam %#ok<NOPTS>

%Plot gamma values against theta/pi
plot(theta/pi, gam);
axis([0 2 -2.5 2.5]);