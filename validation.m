
clear; close all; clc

load('Data/naca0012/9e6_-16:1:16_summary.mat', 'clswp','clswp_old','cdswp','alpha');

alphap = [-17,-16,-15.5,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14,15.5,16,17];
cl_alpha = [-1.25,-1.375,-1.53,-1.45,-1.3,-1.05,-0.8,-0.6,-0.4,-0.2,0, ...
    0.2,0.4,0.6,0.8,1.05,1.3,1.45,1.53,1.375,1.25];

cl = [-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2];
cd = [0.01285,0.0105,0.0086,0.0073,0.0065,0.006,0.0058,0.006,0.0065,0.0073,0.0086,0.0105,0.01285];

figure(1)
hold on
plot(alpha,clswp_old, 'LineWidth', 1.2, 'color','k','DisplayName','Initial model')
plot(alpha,clswp, '--', 'LineWidth', 1.2, 'color','k','DisplayName','Revised model')
plot(alphap,cl_alpha,'-sq','LineWidth', 1.2,'color','k','DisplayName','Experimental data','MarkerSize', 8)
hold off
xlabel('Angle of attack  \alpha')
ylabel('Coefficient of lift  C_L')
set(gca, 'FontName','Times', 'FontSize', 14);
legend('location', 'SouthEast', 'FontSize', 14);
print (gcf, ['LaTeX/Graphs/validation1'], '-depsc')

figure(2)
hold on
plot(clswp_old(6:end-5),cdswp(6:end-5), 'LineWidth', 1.2, 'color','k','DisplayName','Initial model')
plot(clswp(6:end-5),cdswp(6:end-5),'--', 'LineWidth', 1.2, 'color','k','DisplayName','Revised model')
plot(cl,cd,'-sq','LineWidth', 1.2,'color','k','DisplayName','Experimental data','MarkerSize', 8)
hold off
xlabel('Coefficient of lift  C_L')
ylabel('Coefficient of drag  C_D')
set(gca, 'FontName','Times', 'FontSize', 14);
legend('location', 'SouthEast', 'FontSize', 14);

print (gcf, ['LaTeX/Graphs/validation2'], '-depsc')
cl = zeros(1,3);
cd = zeros(1,3);
section = 'naca4412';
secfile = ['Geometry/' section '.surf'];
[xk ,yk] = textread ( secfile, '%f%f' );
i = 0;
Re = 9e6;

npp = [5,10,15,20,30,40,50,60,100,150,200,250,300,400,500,600,700,800];
for np = npp
i = i +1;
nphr = 5*np;
[xshr, yshr] = splinefit ( xk, yk, nphr );
[xsin, ysin] = resyze ( xshr, yshr );
[xs, ys] = make_upanels ( xsin, ysin, np );

% OUtput arrays

%  Assemble the lhs of the equations for the potential flow calculation
A = build_lhs ( xs, ys );
Am1 = inv(A);

% First do the alpha loop. from this we only need cl and cd
%  Loop over alpha values

    alpha = 0;
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
        dels = sqrt((xs(ip+1)-xs(ip))^2 + (ys(ip+1)-ys(ip))^2);
        circ = circ  +  dels * (gam(ip)+gam(ip+1))/2;
    end
    
    %    lift and drag coefficients
    [Clt, Cdt] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );
    cl(i) = Clt;
    cd(i) = Cdt;
end

figure(3)
plot(npp,cl,'-sq','color','k','LineWidth', 1.2,'MarkerSize', 8)
ylabel('Coefficient of lift  C_L')
xlabel('Number of panels')
set(gca, 'FontName','Times', 'FontSize', 14);


