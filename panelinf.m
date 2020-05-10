function [infa, infb] = panelinf(xa, ya, xb, yb, x, y)
% Calculate the influence coefficients 
% at any point due to panel xa,ya,xb,yb.

% x, y are 2D matrices in the i,j plane of the array representing
% a spatial field affected by panel k.
% The panel coordinates (xa, ya, xb, yb) become vectors in the k direction 
% where each page/sheet of the 3D array is the field of 
% influence coefficients due to panel k.

% Coming in, xa is a normal j-index row vector of length np
np = length(xa);
% Reshape panel coords to k-index vectors
xa = reshape(xa, 1, 1, np);
ya = reshape(ya, 1, 1, np);
xb = reshape(xb, 1, 1, np);
yb = reshape(yb, 1, 1, np);

% For each panel calculate length and n-t coordinate system
% del, n1, n2, t1 and t2 are k-index vectors
del = sqrt((xb-xa).^2+(yb-ya).^2);
t1 = (xb-xa)./del;
t2 = (yb-ya)./del;
n1 = -t2;
n2 = t1;

% r1, r2 is result of 2D [x] matrix minus 1D k-index xa vector 
% which results in a 3D Array.
r1 = x-xa;
r2 = y-ya;

% Finally compute the normalised coordinates for each spatial point
% into the refpaninf coord system
X = r1.*t1 + r2.*t2;
Y = r1.*n1 + r2.*n2;

% Now del is k-index vector and X, Y are 3D arrays.
[infa, infb] = refpaninf(del, X, Y);
end