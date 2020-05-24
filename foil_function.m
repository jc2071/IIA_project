function [xs, ys, Clswp, Cdswp, ipstag, iunt, iuls, iutr, iuts, ilnt, ills, iltr, ilts] = foil_function (xk, yk, np, Re, alpha)
%
%
% Takes in information and returns the Cl and Cd for each alpha
% xk, yk vectors, alpha vector

sz = size(alpha);
Clswp = zeros(sz);
Cdswp = zeros(sz);
ipstagswp = zeros(sz); 
iuntswp = zeros(sz);
iulsswp = zeros(sz);
iutrswp = zeros(sz);
iutsswp = zeros(sz);
ilntswp = zeros(sz);
illsswp = zeros(sz);
iltrswp = zeros(sz);
iltsswp = zeros(sz);

%  Generate high-resolution surface description via cubic splines
nphr = 5*np;
[xshr, yshr] = splinefit ( xk, yk, nphr );

%  Resize section so that it lies between (0,0) and (1,0)
[xsin, ysin] = resyze ( xshr, yshr );

%  Interpolate to required number of panels (uniform size)
[xs, ys] = make_upanels ( xsin, ysin, np );

%  Assemble the lhs of the equations for the potential flow calculation
A = build_lhs ( xs, ys );
Am1 = inv(A);

%  Loop over alpha values
for nalpha = 1:length(alpha)
    
    %    rhs of equations
    alfrad = pi * alpha(nalpha)/180;
    b = build_rhs ( xs, ys, alfrad );
    
    %    solve for surface vortex sheet strength
    gam = Am1 * b;
    
    %    calculate cp distribution and overall circulation
    [cp, circ] = potential_op ( xs, ys, gam );
    
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
    [iunt, iuls, iutr, iuts, delstaru, thetau] = bl_solv ( su, cpu, Re );
    
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
    [ilnt, ills, iltr, ilts, delstarl, thetal] = bl_solv ( sl, cpl , Re);
    
    %    lift and drag coefficients
    [Cl, Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );
    
    %    copy Cl and Cd into arrays for alpha sweep plots
    Clswp(nalpha) = Cl;
    Cdswp(nalpha) = Cd;
    ipstagswp(nalpha) = ipstag;
    iuntswp(nalpha) = iunt;
    iulsswp(nalpha) = iuls;
    iutrswp(nalpha) = iutr;
    iutsswp(nalpha) = iuts;
    ilntswp(nalpha) = ilnt;
    illsswp(nalpha) = ills;
    iltrswp(nalpha) = iltr;
    iltsswp(nalpha) = ilts;
end
end

