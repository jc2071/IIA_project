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

% OUtput arrays
Cl = zeros(size(alpha));
Cd = zeros(size(alpha));

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
    [cp, ~] = potential_op ( xs, ys, gam );
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
    [~, ~, ~, iuts, delstaru, thetau] = bl_solv ( su, cpu, Re );
    
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
    [~, ~, ~, ilts, delstarl, thetal] = bl_solv ( sl, cpl, Re);
    
    % Calculate new circulation
    if iuts ~= 0
        icirc_start = ipstag + 1 - iuts;
    else 
        icirc_start = 1;
    end
    if ilts ~= 0
        icirc_stop = ipstag + ilts;
    else 
        icirc_stop = np+1;
    end
    circ = 0;
    for ip = icirc_start:icirc_stop-1
        cp(ip) = 1 - gam(ip)^2;
        dels = sqrt((xs(ip+1)-xs(ip))^2 + (ys(ip+1)-ys(ip))^2);
        circ = circ  +  dels * (gam(ip)+gam(ip+1))/2;
    end
    
    %    lift and drag coefficients
    [Clt, Cdt] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );
    Cl(nalpha) = Clt;
    Cd(nalpha) = Cdt;
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
% not really needed yet)
%[Cl Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );

% Stitch together theta
theta = [thetau(end:-1:1), thetal];

% Create the iss to use x_foil indexes instead of BL ones
iss = [ipstag, zeros(1,8)];
if iunt~=0
        iss(2) = ipstag + 1 - iunt;
end
if iuls~=0
    iss(3) = ipstag + 1 - iuls;
    if iutr~=0
        iss(4) = ipstag + 1 - iutr;
    end
end
if iuts~=0
    iss(5) = ipstag + 1 - iuts;
end
if ilnt~=0
    iss(6) = ipstag + ilnt;
end
if ills~=0
    iss(7) = ipstag + ills;
    if iltr~=0
        iss(8) = ipstag + iltr;
    end
end
if ilts~=0
    iss(9) = ipstag + ilts;
end