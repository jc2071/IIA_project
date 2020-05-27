function [xs, ys, cp, theta, Cl, Cd, iss] = foilsolve(xk, yk, np, Re, alpha, alphaswp)
%
% Run foil code live from WASG. Take in xk, yk knot geometry, np Re and
% alpha are single values
% alphaswp is a sweep of alpha values to calculate cd and cl for.
% cp and theta are returned for the single value of alpha
% iss is array of [ipstag, iunt, iuls, iutr, iuts, ilnt, ills, iltr, ilts]
%                 [  1      2     3     4     5     6     7     8     9  ]


%  Generate high-resolution surface description via cubic splines
nphr = 5*np;
[xshr, yshr] = splinefit ( xk, yk, nphr );
[xsin, ysin] = resyze ( xshr, yshr );
[xs, ys] = make_upanels ( xsin, ysin, np );

%  Assemble the lhs of the equations for the potential flow calculation
A = build_lhs ( xs, ys );
Am1 = inv(A);

% First do the alpha loop. from this we only need cl and cd
%  Loop over alpha values
for nalpha = 1:length(alphaswp)
    
    %    rhs of equations
    alfrad = pi * alphaswp(nalpha)/180;
    b = build_rhs ( xs, ys, alfrad );
    
    %    solve for surface vortex sheet strength
    gam = Am1 * b;
    
    %    calculate cp distribution and overall circulation
    [cp, circ] = potential_op ( xs, ys, gam );
    %    locate stagnation point and calculate stagnation panel length
    [ipstag, fracstag] = find_stag(gam);
    dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);
    
    % UPPER BOUNDARY LAYER
    
    %    first assemble pressure distribution along bl
    clear su cpu
    su(1) = fracstag*dsstag;
    cpu(1) = cp(ipstag);
    for is = ipstag-1:-1:1
        iu = ipstag - is + 1;
        su(iu) = su(iu-1) + sqrt((xs(is+1)-xs(is))^2 + (ys(is+1)-ys(is))^2);
        cpu(iu) = cp(is);
    end
    
    %    check for stagnation point at end of stagnation panel
    if fracstag < 1e-6
        su(1) = 0.01*su(2);    % go just downstream of stagnation
        uejds = 0.01 * sqrt(1-cpu(2));
        cpu(1) = 1 - uejds^2;
    end
    
    %    boundary layer solver
    [~, ~, ~, ~, delstaru, thetau] = bl_solv ( su, cpu, Re );
    
    %    LOWER BL
    
    %    first assemble pressure distribution along bl
    clear sl cpl
    sl(1) = (1-fracstag) * dsstag;
    cpl(1) = cp(ipstag+1);
    for is = ipstag+2:np+1
        il = is - ipstag;
        sl(il) = sl(il-1) + sqrt((xs(is-1)-xs(is))^2 + (ys(is-1)-ys(is))^2);
        cpl(il) = cp(is);
    end
    
    %    check for stagnation point at end of stagnation panel
    if fracstag > 1 - 1e-6
        sl(1) = 0.01*sl(2);    % go just downstream of stagnation
        uejds = 0.01 * sqrt(1-cpl(2));
        cpl(1) = 1 - uejds^2;
    end
    
    %    boundary layer solver
    [~, ~, ~, ~, delstarl, thetal] = bl_solv ( sl, cpl, Re);
    
    %    lift and drag coefficients
    [Cl, Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );
end

% Now do the single value of alpha
%    rhs of equations
alfrad = pi * alpha/180;
b = build_rhs ( xs, ys, alfrad );

%    solve for surface vortex sheet strength
gam = Am1 * b;

%    calculate cp distribution and overall circulation
[cp, ~] = potential_op ( xs, ys, gam );

%    locate stagnation point and calculate stagnation panel length
[ipstag, fracstag] = find_stag(gam);
dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);

%    upper surface boundary layer calc

%    first assemble pressure distribution along bl
clear su cpu
su(1) = fracstag*dsstag;
cpu(1) = cp(ipstag);
for is = ipstag-1:-1:1
    iu = ipstag - is + 1;
    su(iu) = su(iu-1) + sqrt((xs(is+1)-xs(is))^2 + (ys(is+1)-ys(is))^2);
    cpu(iu) = cp(is);
end

%    check for stagnation point at end of stagnation panel
if fracstag < 1e-6
    su(1) = 0.01*su(2);    % go just downstream of stagnation
    uejds = 0.01 * sqrt(1-cpu(2));
    cpu(1) = 1 - uejds^2;
end

%    boundary layer solver
[iunt, iuls, iutr, iuts, ~, thetau] = bl_solv ( su, cpu, Re );

%    lower surface boundary layer calc

%    first assemble pressure distribution along bl
clear sl cpl
sl(1) = (1-fracstag) * dsstag;
cpl(1) = cp(ipstag+1);
for is = ipstag+2:np+1
    il = is - ipstag;
    sl(il) = sl(il-1) + sqrt((xs(is-1)-xs(is))^2 + (ys(is-1)-ys(is))^2);
    cpl(il) = cp(is);
end

%    check for stagnation point at end of stagnation panel
if fracstag > 1 - 1e-6
    sl(1) = 0.01*sl(2);    % go just downstream of stagnation
    uejds = 0.01 * sqrt(1-cpl(2));
    cpl(1) = 1 - uejds^2;
end

%    boundary layer solver
[ilnt, ills, iltr, ilts, ~, thetal] = bl_solv ( sl, cpl , Re);

%    lift and drag coefficients (might want to display these on Wasg but 
% not really needed)
%[Cl Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );

theta = [thetau(end:-1:1), thetal];
iss = [ipstag, iunt, iuls, iutr, iuts, ilnt, ills, iltr, ilts];