function [infa, infb] = panelinf( xa, ya, xb, yb, x, y )
%
% function [infa, infb] = panelinf( xa, ya, xb, yb, x, y )
% 
% x and y are 2D matrices indexed by i,j. xa, xb etc are panel coordinates and
% can be input as vectors to calculate several panels simultaneously
%

np = length(xa);

% Reshape panel coords to k-vectors
xa = reshape(xa, 1, 1, np);
ya = reshape(ya, 1, 1, np);
xb = reshape(xb, 1, 1, np);
yb = reshape(yb, 1, 1, np);

% For each panel calculate length and n-t coordinate system
% del, n1, n2, t1 and t2 are k-vectors
del = sqrt((xb-xa).^2+(yb-ya).^2);
t1 = (xb-xa)./del;
t2 = (yb-ya)./del;
n1 = -t2;
n2 = t1;

% r1, r2 is result of 2D [x] matrix minus 1D k-index xa vector 
% which results in a 3D Array.
r1 = x-xa;
r2 = y-ya;

% Finally, compute the normalised coordinates for each spatial point
% into the refpaninf coord system
X = r1.*t1 + r2.*t2;
Y = r1.*n1 + r2.*n2;

[infa, infb] = refpaninf(del, X, Y);

end