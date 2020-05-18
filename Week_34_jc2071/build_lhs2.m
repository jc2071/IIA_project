function lhsmat = build_lhs2(xs, ys)
%
% function lhsmat = build_lhs(xs, ys)
% 
% Using surface coordinates calculate [A] matrix

np = length(xs) - 1;

% Spatial coords for which to calculate infa and infb
xs_spatial = xs(1:np)';
ys_spatial = ys(1:np)';

% N.B shape of infa, infb is (np,1,np).
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), ...
xs_spatial, ys_spatial);

infa = reshape(infa, np, np);
infb = reshape(infb, np, np);

% Combine infa and infb into psip
psip = [infa, zeros(np,1)] + [zeros(np,1), infb];

% Construct [A]. 1st + Last row same as identity matrix.
% Central elements are [A]i = psip(i+1) - psip(i).
lhsmat = [2, -2, 1, zeros(1,np-5), -1, 2, 0; psip(2:end,:) - psip(1:np-1,:); -1, zeros(1,np-1), 1];
%lhsmat = [1, zeros(1,np); psip(2:end,:) - psip(1:np-1,:); zeros(1,np), 1];

end