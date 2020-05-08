function [infa, infb] = panelinf(xa, ya, xb, yb, x, y)
%Give the influence coefficients at any point due to a general panel

%So far doing in this long winded way so can keep x and y as matrices
% therefore r becomes a matrix and can't also be a 2x1 vector
del = sqrt((xb-xa)^2+(yb-ya)^2);
r1 = x-xa;
r2 = y-ya;
t1 = (xb-xa)/del;
t2 = (yb-ya)/del;
n1 = -t2;
n2 = t1;
X = r1*t1 + r2*t2;
Y = r1*n1 + r2*n2;

[infa, infb] = refpaninf(del, X, Y);
end