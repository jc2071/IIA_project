function [xscrooked, yscrooked] = unsyze (xsin, ysin, xs, ys)
%
% Undo the effects of the resyze for plotting back on the WASG reference
% frame
% XS and YS are the WASG points ans are used to determine where to move
% xsin and ysin back to

% locate leading edge (point furthest from TE at (1,0))
rte = sqrt((xs-1).^2 + ys.^2);
indle = find(rte==max(rte));
indle = indle(1);  % in case of double match
cawd = rte(indle);

% move section te to 0,0
xsin = xsin -1;

% unrotate
coz = -xs(indle)/cawd;
zin = ys(indle)/cawd;
rotmat = [coz -zin; zin coz]; % sign flipped to go other way
x2y2 = rotmat * [xsin; ysin];

% unscale and shift tw back to 1,0
xscrooked = x2y2(1,:) * cawd + 1;
yscrooked = x2y2(2,:) * cawd;

