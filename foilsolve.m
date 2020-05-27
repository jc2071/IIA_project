function [xs, ys, cp] = foilsolve(xk, yk, np, Re, alpha)

%  Generate high-resolution surface description via cubic splines
nphr = 5*np;
[xshr, yshr] = splinefit ( xk, yk, nphr );
[xsin, ysin] = resyze ( xshr, yshr );
[xs, ys] = make_upanels ( xsin, ysin, np );

%  Assemble the lhs of the equations for the potential flow calculation
A = build_lhs ( xs, ys );
alfrad = pi * alpha/180;
b = build_rhs ( xs, ys, alfrad );
gam = A\b;

%    calculate cp distribution and overall circulation
[cp, circ] = potential_op ( xs, ys, gam );
end