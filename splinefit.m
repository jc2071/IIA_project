function [xsin ysin] = splinefit(xk,yk,npin)
%
%  function [xsin ysin] = splinefit(xk,yk,npin)
% 
%  Produces npin panel surface description (xsin,ysin) via cubic spline
%  fit with knots in (xk,yk).  Note that TE point should be repeated.
%
  
% parameter u is based on panel lengths
lens = sqrt((xk(2:end)-xk(1:end-1)).^2 + (yk(2:end)-yk(1:end-1)).^2);
u = [0; cumsum(lens)];

% spline fits to x and y as functions of u
uin = linspace(0,u(end),npin+1);
xsin = spline(u,xk,uin);
ysin = spline(u,yk,uin);
