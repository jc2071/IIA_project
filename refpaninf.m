function [infa, infb] = refpaninf(del, X, Y)
%
% function [infa, infb] = refpaninf(del, X, Y)
%
% Calculate the influence coefficients for a reference panel of vorticity.
% X and Y can be 3D arrays with del as a k-vector giving length of each
% panel. Where each panel is a page of the 3D array.
%

% Trap to make min(abs(Y)) 1e-8 to avoid numerical difficulties
Y = Y .* (abs(Y) >= 1e-8) + sign(Y) .* (abs(Y) < 1e-8) * 1e-8;
Y(Y==0) = 1e-8;

% Calculate integrals using element operations
I0 = -( X.*log(X.^2 + Y.^2) - (X-del).*log((X-del).^2 + Y.^2) ...
-2*del +2*Y.*(atan(X./Y)-atan((X-del)./Y)) )/(4*pi);

I1 = ( (X.^2 + Y.^2).*log(X.^2 + Y.^2) ...
-((X-del).^2+Y.^2).*log((X-del).^2+Y.^2) -2*X.*del + del.^2)/(8*pi);

% N.B Elemental division of a 3D array by k-vector
% divides each sheet by k-vector value at that k index.
infa = (1-X./del).*I0 - I1./del;
infb = (X./del).*I0 + I1./del;

end