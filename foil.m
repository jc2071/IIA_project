%   foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  and boundary layer solver.
%

close; clear all;

%  Read in the parameter file
caseref = input('Enter case reference: ','s');
parfile = ['Parfiles/' caseref '.txt'];
fprintf(1, '%s\n\n', ['Reading in parameter file: ' parfile])
[section np Re alpha] = par_read(parfile);

%  Read in the section geometry
secfile = ['Geometry/' section '.surf'];
[xk yk] = textread ( secfile, '%f%f' );

%  Generate high-resolution surface description via cubic splines
nphr = 5*np;
[xshr yshr] = splinefit ( xk, yk, nphr );

%  Resize section so that it lies between (0,0) and (1,0)
[xsin ysin] = resyze ( xshr, yshr );

%  Interpolate to required number of panels (uniform size)
[xs ys] = make_upanels ( xsin, ysin, np );

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
    [cp, circ_old] = potential_op ( xs, ys, gam );
    %    locate stagnation point and calculate stagnation panel length
    [ipstag fracstag] = find_stag(gam);
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
    [iunt iuls iutr iuts delstaru thetau] = bl_solv ( su, cpu, Re );
    
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
    [ilnt ills iltr ilts delstarl thetal] = bl_solv ( sl, cpl , Re);
    
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
    [Cl_old, Cd_old] = forces ( circ_old, cp, delstarl, thetal, delstaru, thetau );
    [Cl, Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );
    
    %    copy Cl and Cd into arrays for alpha sweep plots
    
    clswp(nalpha) = Cl;
    cdswp(nalpha) = Cd;
    clswp_old(nalpha) = Cl_old;
    cdswp_old(nalpha) = Cd_old;
    lovdswp(nalpha) = Cl/Cd;
    
    %    screen output
    
    disp ( sprintf ( '\n%s%5.3f%s', ...
        'Results for alpha = ', alpha(nalpha), ' degrees' ) )
    
    disp ( sprintf ( '\n%s%5.3f', '  Lift coefficient: ', Cl ) )
    disp ( sprintf ( '%s%7.5f', '  Drag coefficient: ', Cd ) )
    disp ( sprintf ( '%s%5.3f\n', '  Lift-to-drag ratio: ', Cl/Cd ) )
    
    upperbl = sprintf ( '%s', '  Upper surface boundary layer:' );
    if iunt~=0
        is = ipstag + 1 - iunt;
        upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ...
            '    Natural transition at x = ', xs(is) );
    end
    if iuls~=0
        is = ipstag + 1 - iuls;
        upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ...
            '    Laminar separation at x = ', xs(is) );
        if iutr~=0
            is = ipstag + 1 - iutr;
            upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ...
                '    Turbulent reattachment at x = ', xs(is) );
        end
    end
    if iuts~=0
        is = ipstag + 1 - iuts;
        upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ...
            '    Turbulent separation at x = ', xs(is) );
    end
    upperbl = sprintf ( '%s\n', upperbl );
    disp(upperbl)
    
    lowerbl = sprintf ( '%s', '  Lower surface boundary layer:' );
    if ilnt~=0
        is = ipstag + ilnt;
        lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ...
            '    Natural transition at x = ', xs(is) );
    end
    if ills~=0
        is = ipstag + ills;
        lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ...
            '    Laminar separation at x = ', xs(is) );
        if iltr~=0
            is = ipstag + iltr;
            lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ...
                '    Turbulent reattachment at x = ', xs(is) );
        end
    end
    if ilts~=0
        is = ipstag + ilts;
        lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ...
            '    Turbulent separation at x = ', xs(is) );
    end
    lowerbl = sprintf ( '%s\n', lowerbl );
    disp(lowerbl)
    
    % check if folder exisrts and if not make it
    if ~exist(['Data/', section], 'dir')
        mkdir(['Data/', section])
    end
    
    % Make a nice string of the Reynolds number
    ReLongStr = num2str(Re);
    disp(ReLongStr)
    last_index = length(ReLongStr);
    for r = length(ReLongStr):-1:1
        if ReLongStr(r) ~= '0'
            last_index = r;
            disp(last_index)
            break
        end
    end
    expon = num2str(floor(log10(Re)));
    if last_index == 1
        ReStr = [ReLongStr(1), 'e', expon];
    else
        ReStr = [ReLongStr(1), '.', ReLongStr(2:last_index), 'e', expon];
    end
    
    %    save data for this alpha
    fname = ['Data/', section, '/', ReStr, '_',  num2str(alpha(nalpha)), '.mat'];
    save ( fname, 'Cl', 'Cd', 'xs', 'cp', ...
        'sl', 'delstarl', 'thetal', 'lowerbl', ...
        'su', 'delstaru', 'thetau', 'upperbl' )
end

%  save alpha sweep data in summary file

fname = ['Data/', section, '/', ReStr, '_', num2str(alpha(1)), ':',...
    num2str((alpha(end)-alpha(1))/(length(alpha)-1)), ':',...
    num2str(alpha(end)), '_summary.mat'];
save ( fname, 'xs', 'ys', 'alpha', 'clswp', 'cdswp', 'lovdswp' )

%plot to compare old and new models
figure(1)
hold on
plot(alpha, clswp_old, 'b.-', 'Linewidth', 4)
plot(alpha, clswp, 'r.-', 'Linewidth', 4)
hold off
axis([-20 20 -1.6 1.6])
xlabel('\alpha')
ylabel('C_L')
legend('Initial model', 'Revised model', 'Location', 'Southeast')

figure(2)
hold on
plot(clswp_old, cdswp, 'b.-', 'LineWidth', 4);
plot(clswp, cdswp, 'r.-', 'LineWidth', 4);
hold off
axis([-1.6 1.6 0 0.016])
xlabel('C_L');
ylabel('C_D')
legend('Initial model', 'Revised model', 'Location', 'Southeast')