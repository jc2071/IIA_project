function [cl, cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau)
%
% function [cl, cd] = forces ( circ, cp, delstar1, theta1, delstaru, thetau)
%
% Calculate the forces on the aerofoil.
% circ is Gamma/Uc, cp array of pressure coefficients, delstar u/l upper
% and lower momentum thickness arrays

cl = -2*circ;

theta_te = thetal(end) + thetau(end);
delstar_te = delstarl(end) + delstaru(end);
ue_te = sqrt(1 - cp(end)); % or cp(1) as well maybe. Should be the same
H_te = delstar_te / theta_te;
theta_infinity = theta_te * (ue_te)^((H_te + 5)/2);

cd = 2 * theta_infinity;